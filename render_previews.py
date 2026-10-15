#!/usr/bin/env python3
"""Render preview images of the chore board from chore_board.scad.

    python3 render_previews.py                  # everything
    python3 render_previews.py stls mounting    # just some groups
    python3 render_previews.py --set retention=magnet --set 'tokens=J, M'
    python3 render_previews.py --fn 64 --supersample 1   # quicker, lower quality

Groups (default: all):
    main      preview.png                    the assembled board
    stls      renders/<stl name>.png        one image per STL that build_stls.py makes
    mounting  renders/mounting/<option>.png the back of the board for each built-in
                                             mounting option, plus the board in the
                                             stand and hanging on a door

Needs OpenSCAD on your PATH, or set OPENSCAD to its path. On a Linux machine
without a display, install xvfb (e.g. `sudo apt install xvfb`); the script uses
xvfb-run automatically when there is no display.
"""
import argparse, os, re, shutil, subprocess, sys, tempfile
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
SCAD = os.path.join(HERE, "chore_board.scad")

# Extra scenes for the mounting renders. Appended to a temporary copy of the
# model in place of its normal output section, so every setting still applies.
SCENES = r'''
// ---------------- render scenes (preview images only)
scene = "back";
module sliders_at_print() for (i=[0:nrows-1], j=[0:ncols-1])
    translate([col_x(j) + step_x(print_step), row_y(i), 0]) slider();
module whole_board() { board_fixed(); sliders_at_print(); }

if (scene == "back") {
    // turned over so the back faces up, title edge still at the top
    translate([board_w, 0, plate_t]) rotate([0, 180, 0]) whole_board();
    color(board_colour) translate([board_w, 0, 0]) mirror([1,0,0]) mount_extras();
}
if (scene == "stand") {
    color(board_colour) stand();
    // board seated in the slot, leaning back
    translate([stand_len/2 - board_w/2, st_fy, st_base]) rotate([-stand_angle, 0, 0])
        translate([0, stand_slot_clr + plate_t, 0]) rotate([90, 0, 0]) whole_board();
}
if (scene == "hooks") rotate([90, 0, 0]) {    // scene is built with y up; turn it so z is up
    // door slab, two arms over its top, board hanging on the ledges
    door_h = hk_ydt;   // door top sits under the bridge
    color("BurlyWood", 0.6) translate([-hook_door_t, -20, -30]) cube([hook_door_t, door_h + 20, board_w + 60]);
    for (zz=[25, board_w - 25 - hook_width]) color(board_colour) translate([0, 0, zz]) hook_arm();
    translate([hk_zb, hk_yb, board_w]) rotate([0, 90, 0]) whole_board();
}
'''

# Camera angles (gimbal: rotate x, y, z).
CAM_FRONT = "0,0,0,35,0,15,0"
CAM_BACK = "0,0,0,25,0,10,0"

# (file name, extra settings) for the back-of-board mounting renders.
# Options that only work without the corner magnets turn them off.
MOUNT_BACKS = [
    ("magnets",         []),
    ("keyholes",        [("board_magnets", "false"), ("keyholes", "true")]),
    ("adhesive_strips", [("board_magnets", "false"), ("strips", "true")]),
    ("french_cleat",    [("board_magnets", "false"), ("cleat", "true")]),
    ("cord_holes",      [("cord_holes", "true")]),
    ("bumper_pads",     [("board_magnets", "false"), ("bumpers", '"on"')]),
]
MOUNT_SCENES = [
    ("stand",           "stand", [("stand", "true")], "0,0,0,72,0,35,0"),
    ("door_hooks",      "hooks", [("hooks", "true")], "0,0,0,75,0,120,0"),
    ("door_hooks_side", "hooks", [("hooks", "true")], "0,0,0,85,0,0,0"),
]


def find_openscad():
    return os.environ.get("OPENSCAD") or shutil.which("openscad") or shutil.which("openscad-nightly")


def needs_xvfb():
    return (sys.platform.startswith("linux") and not os.environ.get("DISPLAY")
            and not os.environ.get("WAYLAND_DISPLAY") and shutil.which("xvfb-run"))


def scad_value(v):
    """Pass numbers, booleans, lists and quoted strings through; quote anything else."""
    v = v.strip()
    if re.fullmatch(r"-?\d+(\.\d+)?", v) or v in ("true", "false") or v[:1] in ('[', '"'):
        return v
    return '"' + v.replace('"', '\\"') + '"'


def safe(name):
    return re.sub(r"[^A-Za-z0-9_-]+", "_", name).strip("_") or "blank"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("groups", nargs="*", metavar="GROUP", help="main, stls, mounting (default: all)")
    ap.add_argument("--set", action="append", default=[], metavar="NAME=VALUE",
                    help="override a setting (repeatable), same as build_stls.py")
    ap.add_argument("--size", default="2400,1900", help="image size for the main and board renders")
    ap.add_argument("--fn", type=int, default=96,
                    help="curve smoothness ($fn) for the renders; higher is smoother but slower")
    ap.add_argument("--supersample", type=int, default=2,
                    help="render this many times larger and scale down for smooth edges "
                         "(needs Pillow; 1 = off)")
    ap.add_argument("--jobs", type=int, default=max(1, (os.cpu_count() or 2) - 1),
                    help="how many images to render at once")
    args = ap.parse_args()

    groups = set(args.groups) or {"main", "stls", "mounting"}
    bad = groups - {"main", "stls", "mounting"}
    if bad:
        sys.exit(f"Unknown group(s): {', '.join(sorted(bad))}. Choose from: main, stls, mounting")

    openscad = find_openscad()
    if not openscad:
        sys.exit("OpenSCAD not found - install it or set OPENSCAD to its path.")
    prefix = ["xvfb-run", "-a"] if needs_xvfb() else []
    ss = max(1, args.supersample)
    if ss > 1:
        try:
            from PIL import Image
        except ImportError:
            print("Pillow not installed - rendering without supersampling (pip install pillow)")
            ss = 1

    overrides = []
    for item in args.set:
        if "=" not in item:
            sys.exit(f"--set needs NAME=VALUE, got '{item}'")
        k, v = item.split("=", 1)
        overrides.append((k.strip(), scad_value(v)))

    tmp = tempfile.mkdtemp()
    # a copy of the model with the render scenes in place of its output section
    src = open(SCAD, encoding="utf-8").read()
    cut = src.find("// ================================================================ output")
    if cut < 0:
        sys.exit("Couldn't find the output section in chore_board.scad")
    scenes = os.path.join(tmp, "scenes.scad")
    with open(scenes, "w", encoding="utf-8") as f:
        f.write(src[:cut] + SCENES)

    def render(scad, out, defines, camera, size, png=True):
        target = out
        if png and ss > 1:              # render big, then scale down for anti-aliasing
            w, h = (int(v) for v in size.split(","))
            out = os.path.join(tmp, "big_" + os.path.basename(target))
            size = f"{w*ss},{h*ss}"
        cmd = prefix + [openscad, "-o", out]
        if png:
            cmd += ["--colorscheme=Tomorrow", "--viewall", "--autocenter",
                    f"--imgsize={size}", f"--camera={camera}", "-D", f"$fn={args.fn}"]
        for k, v in defines + overrides:
            cmd += ["-D", f"{k}={v}"]
        cmd.append(scad)
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0 or not os.path.exists(out):
            raise RuntimeError(f"OpenSCAD failed for {os.path.basename(target)}:\n{(res.stdout + res.stderr)[-1500:]}")
        if out != target:
            from PIL import Image
            im = Image.open(out)
            im.resize((im.width // ss, im.height // ss), Image.LANCZOS).save(target)
            os.remove(out)
        return res

    # token list and retention, as build_stls.py names its STLs
    try:
        info = render(SCAD, os.path.join(tmp, "info.stl"), [("part", '"info"')], "", "", png=False)
    except RuntimeError as e:
        m = re.search(r'Assertion .*? failed: "(.*?)"', str(e))
        sys.exit("Invalid settings: " + (m.group(1) if m else str(e)))
    text = info.stderr + info.stdout
    retention = re.search(r'"RETENTION=(\w+)', text).group(1)
    test_ret = re.search(r'TEST_RETENTION=(\w+)', text).group(1)
    tokens = [(int(i), n) for i, n in re.findall(r'TOKEN=(\d+)=(.*?)"', text)]

    prev = os.path.join(HERE, "renders")
    mount = os.path.join(prev, "mounting")
    os.makedirs(mount, exist_ok=True)

    jobs = []   # (scad, output, defines, camera, size)
    if "main" in groups:
        jobs.append((SCAD, os.path.join(prev, "preview.png"), [], CAM_FRONT, args.size))
    if "stls" in groups:
        jobs += [
            (SCAD, os.path.join(prev, f"board_{retention}.png"), [("part", '"board"')], CAM_FRONT, args.size),
            (SCAD, os.path.join(prev, f"slider_test_{test_ret}.png"), [("part", '"slider_test"')],
             "0,0,0,45,0,20,0", "1800,1260"),
            (SCAD, os.path.join(prev, "tray.png"), [("part", '"tray"')], "0,0,0,60,0,150,0", "1600,1330"),
        ]
        used = set()
        for i, name in tokens:
            base = f"token_{safe(name)}_{retention}"
            fname, n = base, 2
            while fname in used:
                fname, n = f"{base}_{n}", n + 1
            used.add(fname)
            jobs.append((SCAD, os.path.join(prev, fname + ".png"),
                         [("part", '"token"'), ("token_index", str(i))], "0,0,0,50,0,20,0", "1400,1200"))
    if "mounting" in groups:
        for name, defs in MOUNT_BACKS:
            jobs.append((scenes, os.path.join(mount, name + ".png"),
                         [("scene", '"back"')] + defs, CAM_BACK, "2000,1660"))
        for name, scene, defs, cam in MOUNT_SCENES:
            jobs.append((scenes, os.path.join(mount, name + ".png"),
                         [("scene", f'"{scene}"')] + defs, cam, "2000,1660"))

    print(f"Rendering {len(jobs)} image(s)  (retention: {retention}, tokens: "
          f"{', '.join(n or 'blank' for _, n in tokens)})")
    failed = False
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        futs = [(j[1], pool.submit(render, *j)) for j in jobs]
        for out, fut in futs:
            try:
                fut.result()
                print("  done:", os.path.relpath(out, HERE))
            except Exception as e:
                failed = True
                print("  FAILED:", e)
    shutil.rmtree(tmp, ignore_errors=True)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
