#!/usr/bin/env python3
"""Build the chore board STLs from chore_board.scad.

Run with -h for the list of STLs and every option, or --options PART
for the options of a single STL.
"""
import argparse, os, re, shutil, subprocess, sys, tempfile, textwrap
from concurrent.futures import ThreadPoolExecutor

HERE = os.path.dirname(os.path.abspath(__file__))
SCAD = os.path.join(HERE, "chore_board.scad")

# ---------------------------------------------------------------- the STLs
PARTS = {
    "board": dict(
        file="board_<retention>.stl",
        desc="The board: title, labels, key and every slider, printed in one "
             "piece with the sliders in place, plus any separate mounting parts that "
             "are switched on (cleat rail, stand, door hanger arms) laid out beside it. "
             "Print face-up, no supports.",
        sections=["Title and labels", "Slider steps", "Text", "Board layout",
                  "Mounting: magnets", "Mounting: keyhole slots", "Mounting: adhesive strips",
                  "Mounting: French cleat", "Mounting: cord holes",
                  "Mounting: stand", "Mounting: door hooks",
                  "Mounting: bumper pads",
                  "Slider (print-in-place)", "Knob", "Tokens",
                  "Token magnets (retention = magnet)",
                  "Token twist lock (retention = twist)"],
        note="From [Tokens], only 'retention' affects the board (it sets the knob recess)."),
    "slider_test": dict(
        file="slider_test_<test_retention>.stl",
        desc="A small coupon with one print-in-place slider, plus one test token "
             "(the first entry in 'tokens'). Print this first to check clearances, "
             "the click-stops and the token fit.",
        sections=["Slider steps", "Board layout", "Slider (print-in-place)", "Knob",
                  "Tokens", "Token magnets (retention = magnet)",
                  "Token twist lock (retention = twist)"],
        note="Uses 'test_retention' (default twist) rather than 'retention'. "
             "From [Board layout], only 'plate_t' and 'back_chamfer' apply."),
    "tokens": dict(
        file="token_<name>_<retention>.stl  (one per entry in 'tokens')",
        desc="The swappable 'who did it' tokens, one STL per entry. Make as many "
             "copies as you need by cloning in your slicer. Print plug-side down.",
        sections=["Tokens", "Token magnets (retention = magnet)",
                  "Token twist lock (retention = twist)", "Text"],
        note="From [Text], only 'font' applies (for letter tokens)."),
    "tray": dict(
        file="tray.stl",
        desc="Wall tray for loose tokens, with a scooped front and magnet pockets "
             "in the back. Print upright, no supports.",
        sections=["Token tray", "Tray magnets"],
        note=None),
}

# ---------------------------------------------------------------- read options from the scad file
def read_options():
    """Return {section: [(name, default, choices, description)]} from the scad file."""
    sections, current, desc = {}, None, []
    with open(SCAD, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            m = re.match(r"/\*\s*\[(.+?)\]\s*\*/", line)
            if m:
                current, desc = m.group(1), []
                if current == "Hidden":
                    break
                sections[current] = []
                continue
            if current is None:
                continue
            if line.startswith("//"):
                desc.append(line[2:].strip())
                continue
            m = re.match(r"(\w+)\s*=\s*(.+?);\s*(?://\s*(\[.*\]))?\s*$", line)
            if m:
                sections[current].append((m.group(1), m.group(2), m.group(3), " ".join(desc)))
            desc = []
    return sections


def wrap(text, indent, width=88):
    return textwrap.fill(text, width=width, initial_indent=indent, subsequent_indent=indent)


def format_part(name, info):
    out = [f"  {name}", wrap(f"File: {info['file']}", "      "), wrap(info["desc"], "      ")]
    out.append(wrap("Options: " + ", ".join(f"[{s}]" for s in info["sections"]), "      "))
    if info["note"]:
        out.append(wrap("Note: " + info["note"], "      "))
    return "\n".join(out)


def format_sections(names, options):
    out = []
    for sec in names:
        out.append(f"\n  [{sec}]")
        for name, default, choices, desc in options.get(sec, []):
            head = f"    {name} = {default}"
            if choices:
                head += f"   choices: {choices.strip('[]')}"
            out.append(head)
            out.append(wrap(desc or "(no description)", "        "))
    return "\n".join(out)


def build_epilog(options):
    used = []
    for p in PARTS.values():
        for s in p["sections"]:
            if s not in used:
                used.append(s)
    return "\n".join([
        "STL FILES (written to the output folder):",
        "",
        "\n\n".join(format_part(n, i) for n, i in PARTS.items()),
        "",
        "OPTIONS (change with --set NAME=VALUE, or edit chore_board.scad):",
        format_sections(used, options),
        "",
        "EXAMPLES:",
        "  python3 build_stls.py                          build everything",
        "  python3 build_stls.py tokens                   just the tokens",
        "  python3 build_stls.py --set retention=magnet   magnet board + tokens",
        "  python3 build_stls.py tokens --set 'tokens=J, M, blank'",
        "  python3 build_stls.py --set 'title=Feed the cat' \\",
        "      --set 'key_symbols=empty, full' --set print_step=0 \\",
        "      --set 'row_labels=Mon, Tue, Wed, Thu, Fri' --set 'col_labels=Breakfast, Dinner'",
        "  python3 build_stls.py --set keyholes=true --set board_magnets=false",
        "  python3 build_stls.py --set stand=true      board STL includes the stand",
        "  python3 build_stls.py --set hooks=true --set hook_door_t=35   adds over-door hanger arms",
        "  python3 build_stls.py --options tray           options for one STL",
    ])

# ---------------------------------------------------------------- openscad
def find_openscad():
    return os.environ.get("OPENSCAD") or shutil.which("openscad") or shutil.which("openscad-nightly")


def scad_value(v):
    """Pass numbers, booleans, lists and quoted strings through; quote anything else."""
    v = v.strip()
    if re.fullmatch(r"-?\d+(\.\d+)?", v) or v in ("true", "false") or v[:1] in ('[', '"'):
        return v
    return '"' + v.replace('"', '\\"') + '"'


def run(openscad, defines, extra, out_path):
    cmd = [openscad, "-o", out_path]
    for k, v in defines:
        cmd += ["-D", f"{k}={v}"]
    cmd += extra + [SCAD]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0 or not os.path.exists(out_path):
        raise RuntimeError(f"OpenSCAD failed for {os.path.basename(out_path)}:\n{res.stderr[-2000:]}")
    return res


def safe(name):
    return re.sub(r"[^A-Za-z0-9_-]+", "_", name).strip("_") or "blank"

# ---------------------------------------------------------------- main
def main():
    options = read_options()
    known = {n for sec in options.values() for n, *_ in sec}

    argv = sys.argv[1:]
    passthrough = []
    if "--" in argv:
        i = argv.index("--")
        argv, passthrough = argv[:i], argv[i + 1:]

    ap = argparse.ArgumentParser(
        description="Build the chore board STLs from chore_board.scad. "
                    "Each STL is built by OpenSCAD; tokens get one STL each.",
        epilog=build_epilog(options),
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("parts", nargs="*", metavar="PART", help=f"which STLs to build: {', '.join(PARTS)} (default: all)")
    ap.add_argument("--set", action="append", default=[], metavar="NAME=VALUE",
                    help="override an option (repeatable); text needs no quotes and "
                         "lists are comma separated, e.g. 'tokens=J, M, blank'")
    ap.add_argument("--options", nargs="?", const="all", metavar="PART",
                    help="show the options for one STL (or all) and exit")
    ap.add_argument("--list", action="store_true", help="list the STLs and exit")
    ap.add_argument("--outdir", default=os.path.join(HERE, "stl"),
                    help="output folder (default: ./stl next to this script)")
    ap.add_argument("--jobs", type=int, default=max(1, (os.cpu_count() or 2) - 1),
                    help="how many STLs to build at once")
    args = ap.parse_args(argv)

    if args.list:
        print("\n\n".join(format_part(n, i) for n, i in PARTS.items()))
        return
    if args.options:
        names = list(PARTS) if args.options == "all" else [args.options]
        for n in names:
            if n not in PARTS:
                sys.exit(f"Unknown part '{n}'. Choose from: {', '.join(PARTS)}")
            print(format_part(n, PARTS[n]))
            print(format_sections(PARTS[n]["sections"], options) + "\n")
        return

    bad = [p for p in args.parts if p not in PARTS]
    if bad:
        sys.exit(f"Unknown part(s): {', '.join(bad)}. Choose from: {', '.join(PARTS)}")
    wanted = args.parts or list(PARTS)

    overrides = []
    for item in args.set:
        if "=" not in item:
            sys.exit(f"--set needs NAME=VALUE, got '{item}'")
        k, v = item.split("=", 1)
        k = k.strip()
        if k not in known:
            sys.exit(f"Unknown option '{k}'. Run with -h to see all options.")
        overrides.append((k, scad_value(v)))

    openscad = find_openscad()
    if not openscad:
        sys.exit("OpenSCAD not found - install it or set OPENSCAD to its path.")
    os.makedirs(args.outdir, exist_ok=True)

    # ask the scad file for its token list and retention modes (also validates the settings)
    with tempfile.TemporaryDirectory() as tmp:
        try:
            info = run(openscad, [("part", '"info"')] + overrides, passthrough, os.path.join(tmp, "i.stl"))
        except RuntimeError as e:
            msg = re.findall(r"Assertion .*? failed: \"(.*?)\"", str(e))
            sys.exit("Invalid settings: " + (msg[0] if msg else str(e)))
    text = info.stderr + info.stdout
    retention = re.search(r'"RETENTION=(\w+)', text).group(1)
    test_ret = re.search(r'TEST_RETENTION=(\w+)', text).group(1)
    tokens = [(int(i), n) for i, n in re.findall(r'TOKEN=(\d+)=(.*?)"', text)]

    jobs = []
    if "board" in wanted:
        jobs.append(([("part", '"board"')], f"board_{retention}.stl"))
    if "slider_test" in wanted:
        jobs.append(([("part", '"slider_test"')], f"slider_test_{test_ret}.stl"))
    if "tray" in wanted:
        jobs.append(([("part", '"tray"')], "tray.stl"))
    if "tokens" in wanted:
        used = set()
        for i, name in tokens:
            base = f"token_{safe(name)}_{retention}"
            fname, n = base, 2
            while fname in used:
                fname, n = f"{base}_{n}", n + 1
            used.add(fname)
            jobs.append(([("part", '"token"'), ("token_index", str(i))], fname + ".stl"))

    for line in re.findall(r'INFO: (.*?)"\s*$', text, flags=re.M):
        print("  " + line.replace(chr(92) + chr(34), chr(34)))
    print(f"Retention: {retention}   Slider test: {test_ret}   "
          f"Tokens: {', '.join(n or 'blank' for _, n in tokens)}")
    print(f"Building {len(jobs)} STL(s) into {args.outdir} ...")

    def do(job):
        defines, fname = job
        run(openscad, defines + overrides, passthrough, os.path.join(args.outdir, fname))
        return fname

    failed = False
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        for fut in [pool.submit(do, j) for j in jobs]:
            try:
                print("  done:", fut.result())
            except Exception as e:
                failed = True
                print("  FAILED:", e)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
