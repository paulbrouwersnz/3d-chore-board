// =====================================================================
//  Chore Board  (default: "Dog walking")  -  OpenSCAD
//  ---------------------------------------------------------------
//  One file, all settings.  Open in OpenSCAD and use the Customizer,
//  or edit the values below.
//
//  Components (set 'part'):
//    board        board with every slider printed in place (face-up)
//    slider_test  one-slider test coupon + one test token, to check
//                 clearances and token fit before printing the board.
//                 Uses 'test_retention' (default: twist)
//    token        a single token: tokens[token_index]
//    tray         wall tray for loose tokens
//    assembled    preview only
//    info         echoes the token list (used by build_stls.py)
//
//  To make every STL at once, run:   python3 build_stls.py
//  It writes board, slider test, tray and ONE STL PER TOKEN into
//  ./stl - print each token as many times as you need (clone it in
//  your slicer).
//
//  Sliders: a double-dovetail carriage runs in a channel inside the
//  board (trapped front and back), with a neck up through a slot to
//  the knob.  Sprung arms on both sides click into notches, one per
//  step.  Everything is vertical or 45 degrees: no supports.  After
//  printing, push each knob firmly once to free it.  Use ~0.15 mm
//  elephant-foot compensation in your slicer.
//
//  Tokens sit in a recess in each knob top, held by small magnets or
//  a quarter-turn twist lock ('retention').
// =====================================================================

/* [Output] */
// Component to render: assembled preview, board, slider test, one token, tray, or info for the build script
part = "assembled"; // [assembled, board, slider_test, token, tray, info]
// Which entry of 'tokens' to render when part = "token" (0 = first)
token_index = 0;

/* [Title and labels] */
// Title text across the top of the board
title = "Dog walking";
// Heading above the row labels ("" for none)
row_header = "";
// Row labels, comma separated; the number of entries sets the number of rows
row_labels = "Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday";
// Slider column labels, comma separated; the number of entries sets the number of columns
col_labels = "AM, PM, Night";

/* [Slider steps] */
// Key symbols under each heading, comma separated, left to right. Each symbol is one click-stop, so the number of symbols sets the number of steps (2 or more). Putting "not done" first means a ruler slid down a column resets every slider at once. Use: empty, half, full, cross, tick, none, a token shape, or short text
key_symbols = "empty, half, full";
// Step the sliders are printed in (0 = leftmost, normally the "not done" step)
print_step = 0;
// Distance between neighbouring stops (mm)
step_pitch = 10;

/* [Text] */
// Font for all text (any installed font, e.g. "Liberation Sans:style=Bold")
font = "Liberation Sans:style=Bold";
// Title text height (mm)
title_size = 11;
// Row and column label text height (mm)
label_size = 5.5;
// Size of the key symbols under the headings (mm)
key_size = 5;
// How far text and symbols stand out from the board face (mm)
relief = 0.6;

/* [Board layout] */
// Space around the edges of the board (mm)
margin = 8;
// Height of the title band (mm)
title_h = 22;
// Height of the heading row: column labels + key (mm)
header_h = 18;
// Height of each row (mm)
row_h = 15;
// Width of the row-label column (mm)
row_label_w = 48;
// Width of each slider column; widened automatically if too small for the sliders (mm)
col_w = 38;
// Radius of the board's rounded corners (mm)
corner_r = 6;
// Board thickness; houses the slider channels (mm)
plate_t = 7;
// 45-degree chamfer on the rear edge of the board (mm)
back_chamfer = 1.0;
// 45-degree chamfer on the front (top) outside edge of the board (mm)
front_chamfer = 1.0;

/* [Mounting: magnets] */
// Add magnet pockets in the four rear corners of the board
board_magnets = true;
// Board magnet pocket diameter: magnet + clearance (mm)
board_mag_d = 10.2;
// Board magnet pocket depth. Keep this LESS than the magnet thickness so the magnets stand
// about 0.5 mm proud of the back: they touch the fridge directly for full pull, and the
// board is held clear of the surface so the sliders don't drag on it (mm)
board_mag_h = 2.5;
// Distance from the board edges to the pocket centres (mm)
board_mag_inset = 9;

/* [Mounting: keyhole slots] */
// Two keyhole slots in the back of the title band, to hang the board on screws
keyholes = false;
// Distance between the two keyholes, centre to centre (mm)
keyhole_spacing = 100;
// Keyhole entry diameter: fits over the screw head (mm)
keyhole_head_d = 9;
// Keyhole slot width: fits the screw shank (mm)
keyhole_shank_d = 4.5;
// How far the slot runs up from the entry hole (mm)
keyhole_len = 10;
// Total keyhole depth into the back of the board (mm)
keyhole_depth = 4.5;
// Thickness of the lip the screw head hooks behind (mm)
keyhole_lip = 2.0;

/* [Mounting: adhesive strips] */
// Shallow pockets in the four back corners for removable picture-hanging strips
strips = false;
// Strip pocket length (mm)
strip_l = 46;
// Strip pocket width (mm)
strip_w = 16;
// Strip pocket depth (mm)
strip_depth = 0.8;

/* [Mounting: French cleat] */
// Angled groove across the back of the title band; the matching wall rail is added to the board STL
cleat = false;
// Groove length (mm)
cleat_len = 130;
// Groove width at the back face (mm)
cleat_w = 6;
// Groove depth into the board, at 45 degrees (mm)
cleat_depth = 4;
// Clearance between the groove and the wall rail (mm)
cleat_clr = 0.4;
// Wall rail backing plate thickness; also how far the board stands off the wall (mm)
cleat_rail_t = 4;
// Wall rail backing plate height below the lip, for the screws (mm)
cleat_rail_h = 16;
// Wall rail screw hole diameter (mm)
cleat_screw_d = 4.5;

/* [Mounting: stand] */
// Add a desk/shelf stand (printed beside the board in the board STL) that the board slots into
stand = false;
// Stand length (mm)
stand_len = 100;
// Stand base depth, front to back (mm)
stand_depth = 55;
// How far the board leans back from vertical (degrees)
stand_angle = 15;
// Height of the front lip in front of the board; keep below the lowest knob (mm)
stand_slot_depth = 8;
// Height of the back support behind the board (mm)
stand_back_h = 18;
// Clearance in the slot around the board thickness (mm)
stand_slot_clr = 0.5;
// Rounding on every outside edge of the stand (mm)
stand_round = 1.5;
// Fillet where the cradle blends into the base (mm)
stand_fillet = 5;
// Pockets underneath for bumper pads (bumper_d x bumper_h) so the stand doesn't scratch furniture
stand_pads = true;

/* [Mounting: cord holes] */
// Two holes near the top corners for a hanging cord or ribbon
cord_holes = false;
// Cord hole diameter (mm)
cord_hole_d = 4;
// Distance from the side edges to the holes (mm)
cord_hole_inset_x = 18;
// Distance from the top edge to the holes (mm)
cord_hole_inset_y = 10;

/* [Mounting: door hooks] */
// Add two over-door hanger arms (printed beside the board in the board STL). Each hooks over the
// top of a door, runs down behind the board and catches its bottom edge on a ledge; a clip at the
// top stops it tipping forward. Fit the board by lifting it up into the top clips, swinging the
// bottom in, then lowering it onto the ledges.
hooks = false;
// Door thickness; NZ interior doors are typically 35 mm (mm)
hook_door_t = 35;
// Extra room in the hook so it slides over the door without flexing (mm)
hook_tol = 2;
// Gap between the top of the door and the top of the board (mm)
hook_drop = 20;
// Thickness of the bridge over the top of the door; must fit the gap between door and frame (mm)
hook_top_t = 2.5;
// Thickness of the arm, ledge and lips; thicker is stronger (mm)
hook_wall = 4;
// How far the hook's tail reaches down the back of the door (mm)
hook_tail = 25;
// Width of each arm (mm)
hook_width = 20;
// Height of the lips in front of the board at the top and bottom (mm)
hook_lip = 6;
// Clearance around the board thickness in the ledge and top clip (mm)
hook_clr = 0.5;
// Ribs on the arm hold the board this far off it, so the sliders don't drag (mm)
hook_standoff = 1.5;
// 45-degree chamfer on the arm edges (mm)
hook_chamfer = 0.8;

/* [Mounting: bumper pads] */
// Pockets in the back for self-adhesive felt or silicone bumper pads. They stand proud so only the
// pads touch the wall or door: the sliders run in clear air and nothing hard rubs or marks the
// surface. "auto" adds them for keyholes or cord holes when nothing else holds the board off
// the surface (magnets, strips and the cleat already do).
bumpers = "auto"; // [auto, on, off]
// Bumper pad diameter (mm)
bumper_d = 8;
// Bumper pad thickness (mm)
bumper_h = 2;
// How far each pad stands proud of the back; the pocket depth is bumper_h minus this (mm)
bumper_proud = 1;
// Clearance around each pad in its pocket (mm)
bumper_clr = 0.2;
// Distance from the board edges to the corner pads (mm)
bumper_inset = 9;

/* [Slider (print-in-place)] */
// Gap between the moving slider and the board; raise if stuck, lower if loose (mm)
clr = 0.3;
// Length of the sliding carriage; longer = more grip on the print bed (mm)
car_len = 12;
// Carriage width where it sits on the print bed; wider = more grip on the print bed. Can't exceed
// the gap between the spring-arm slits: 2*(car_w/2 - arm_t - arm_slit) (mm)
car_b = 3.2;
// Carriage width at its widest point (mm)
car_w = 7;
// Height where the carriage stops widening; at least (car_w - car_b)/2 to keep the flare at 45 degrees (mm)
car_z1 = 2.0;
// Height where the carriage starts narrowing toward the neck; at least car_z1 + 2*nub (mm)
car_z2 = 3.8;
// 45-degree chamfer on the bottom edges at each end of the carriage, so nothing sharp touches the surface (mm)
car_end_chamfer = 0.6;
// Width of the neck that passes through the slot (mm)
neck_w = 3.4;
// Length of the neck along the slot; longer = stronger, up to car_len (mm)
neck_len = 10;
// Thickness of the click-stop spring arms; thicker = stiffer (mm)
arm_t = 1.2;
// Gap behind each spring arm; must be larger than nub - clr (mm)
arm_slit = 0.7;
// Where the spring arms join the carriage, from its centre (mm)
arm_root = -4;
// How far the click-stop nubs stick out; larger = firmer click (mm)
nub = 0.9;
// Radius of the click-stop nubs (mm)
nub_r = 1.2;
// Position of the nubs along the carriage (mm)
nub_x = 3.6;
// Extra gap at the carriage's first layer, against elephant's foot (mm)
foot_relief = 0.2;
// Breakaway tabs: tiny first-layer bridges joining each slider to the board while it prints, so the
// sliders can't be knocked loose. The first firm push on each knob snaps them; sand any stub smooth.
slider_tabs = false;
// Width of each breakaway tab (mm)
tab_w = 0.8;
// Thickness of each breakaway tab; at least one first layer (mm)
tab_h = 0.2;
// Number of tabs per side of each slider (1 or 2)
tabs_per_side = 1;

/* [Knob] */
// Knob diameter; must leave at least min_wall around the token recess (mm)
knob_d = 13;
// Your printer's extrusion line width; sets the minimum wall around the token recess (mm)
line_w = 0.42;
// Gap between the knob underside and the board face (mm)
knob_gap = 0.3;
// Height of the straight part of the knob above its 45-degree underside (mm)
knob_top_h = 3.4;

/* [Tokens] */
// Tokens, comma separated, one STL each: star, heart, paw, bone, moon, triangle, diamond, bolt, blank, empty, half, full, cross, tick, or text
tokens = "paw, bone, heart";
// How tokens are held in the knobs (applies to the board and token STLs)
retention = "twist"; // [twist, magnet]
// Token holding method for the slider test ("same" follows retention)
test_retention = "twist"; // [twist, magnet, same]
// Token face diameter; overhangs the knob for grip (mm)
token_face_d = 13;
// Height of the straight edge of the token face; taller gives more to grip. The default makes twist
// tokens' symbols start at the same height as the board text (plate_t), so one filament change does both (mm)
face_flat = 1.5;
// Number of grip flutes around the token edge (0 = smooth)
grip_count = 18;
// Depth of each grip flute (mm)
grip_depth = 0.6;
// Width of each grip flute (mm)
grip_w = 1.2;
// How far the token symbol stands out (mm)
symbol_h = 0.6;
// Size of the symbol on the token face (mm)
symbol_size = 8.5;
// Radial clearance of the token plug in the knob; raise if tight (mm)
fit = 0.15;

/* [Token magnets (retention = magnet)] */
// Diameter of the token recess in the knob top (mm)
m_recess_d = 9.4;
// Depth of the token recess in the knob top (mm)
m_recess_h = 2.0;
// Token/knob magnet pocket diameter: magnet + clearance (mm)
tmag_d = 4.2;
// Token/knob magnet pocket depth: magnet + clearance (mm)
tmag_h = 1.1;

/* [Token twist lock (retention = twist)] */
// Diameter of the knob opening the token plug fits through (mm)
tw_mouth_d = 8.0;
// Diameter across the token's two locking lugs (mm)
tw_lug_d = 9.2;
// Diameter of the channel the lugs turn in (mm)
tw_channel_d = 10.2;
// Thickness of the locking lugs (mm)
tw_lug_h = 1.4;
// Thickness of the knob lip the lugs lock under (mm)
tw_lip = 1.2;
// Angular width of each lug (degrees)
tw_lug_deg = 36;
// Angular width of the entry slots in the knob (degrees)
tw_slot_deg = 46;
// Clearance at the start of the turn (mm)
tw_loose = 0.4;
// Grip at the end of the turn; 0 = just touching, raise if tokens work loose, negative for more play (mm)
tw_squeeze = 0.0;
// Locking direction: -1 = clockwise, 1 = anticlockwise
tw_lock_dir = -1;
// Clearance under the lugs (mm)
tw_floor_gap = 0.3;
// Extra turn allowed past the locked position before the hard stop (degrees)
tw_turn_clr = 5;

/* [Token tray] */
// Tray outside width (mm)
tray_w = 55;
// Tray outside depth, back to front (mm)
tray_d = 34;
// Tray height at the back (mm)
tray_back_h = 36;
// Tray height at the front (mm)
tray_front_h = 30;
// Side and front wall thickness (mm)
tray_wall_t = 2.4;
// Floor thickness (mm)
tray_floor_t = 2.4;
// Back wall thickness; must fit the magnet pockets (mm)
tray_back_t = 5;
// Radius of the curved scoop inside the front (mm)
tray_scoop_r = 14;
// 45-degree chamfer on the bottom outside edge (mm)
tray_chamfer = 1.0;
// Radius of the outside vertical corners (mm)
tray_outer_r = 5;
// Radius of the inside corners and floor edges (mm)
tray_inner_r = 3;
// Rounding on the tops of the walls (mm)
tray_top_r = 1.2;
// Number of compartments (1 = no dividers)
tray_compartments = 1;
// Divider thickness (mm)
tray_divider_t = 1.6;

/* [Tray magnets] */
// Tray magnet pocket diameter: magnet + clearance (mm)
tray_mag_d = 10.2;
// Tray magnet pocket depth: magnet + clearance (mm)
tray_mag_h = 3.2;
// Number of magnet pockets across the back
tray_mag_cols = 2;
// Number of magnet pockets up the back
tray_mag_rows = 2;
// Distance from the tray sides to the outer pockets (mm)
tray_mag_inset_x = 14;
// Height of the lower row of pockets (mm)
tray_mag_low_z = 10;
// Height of the upper row of pockets (mm)
tray_mag_high_z = 26;

/* [Preview colours] */
// Show sample tokens in the assembled preview
show_tokens = true;
// Board colour in the preview, also used for the sliders below the knobs (any OpenSCAD colour name or "#rrggbb")
board_colour = "#d0d0d0";
// Colour of the knobs, from where the cone starts upwards
knob_colour = "#404040";
// Colour of the raised text and symbols on the board and the tokens
text_colour = "#404040";
// Token colours, comma separated, one per token in the same order (repeats if shorter)
token_colours = "MediumSeaGreen, Gold, Crimson, DodgerBlue, DarkOrchid, DarkOrange";
// Colour of the token tray in the preview
tray_colour = "SteelBlue";

/* [Hidden] */
$fn = 48;

// ================================================================ comma-separated text -> lists
// The Customizer can't edit lists of text, so the list settings are plain
// comma-separated strings.  Spaces around each item are ignored.  A real list
// (e.g. ["a","b"] passed with -D) is also accepted.
function _join(v, i=0) = i >= len(v) ? "" : str(v[i], _join(v, i + 1));
function _sub(s, a, b) = b <= a ? "" : _join([for (i=[a:b-1]) s[i]]);
function _trim(s) =
    let (n = len(s),
         f = [for (i=[0:max(n-1,0)]) if (n > 0 && s[i] != " ") i],
         a = len(f) ? f[0] : n,
         b = len(f) ? f[len(f)-1] + 1 : n)
    _sub(s, a, b);
function split_list(s) = is_list(s) ? s
    : let (cuts = concat([-1], [for (i=[0:max(len(s)-1,0)]) if (len(s) > 0 && s[i] == ",") i], [len(s)]))
      [for (k=[0:len(cuts)-2]) _trim(_sub(s, cuts[k] + 1, cuts[k+1]))];

L_rows    = split_list(row_labels);
L_cols    = split_list(col_labels);
L_keys    = split_list(key_symbols);
L_tokens  = split_list(tokens);
L_colours = split_list(token_colours);
steps     = len(L_keys);              // one click-stop per key symbol

// ================================================================ derived values
nrows  = len(L_rows);
ncols  = len(L_cols);
travel = step_pitch*(steps - 1);
function step_x(k) = -travel/2 + k*step_pitch;

run      = car_len + travel + 2*clr;                  // channel length
chan_hw  = car_w/2 + nub + clr;                       // channel half-width incl. notches
col_w_eff = max(col_w, run + 6, travel + token_face_d + 2);
// bumper pads: on when asked, or automatically when the board would otherwise sit flat against the surface
use_bumpers = bumpers == "on" ||
    (bumpers == "auto" && (keyholes || cord_holes) && !(board_magnets || strips || cleat));

// bottom margin grows if needed so the corner magnets clear the channels
bot_m = max(margin,
    board_magnets ? board_mag_inset + board_mag_d/2 + 0.8 - row_h/2 + chan_hw : 0,
    strips ? strip_w + 4 + 0.8 - row_h/2 + chan_hw : 0,        // room for the bottom strips
    use_bumpers ? bumper_inset + (bumper_d + 2*bumper_clr)/2 + 0.8 - row_h/2 + chan_hw : 0);
board_w  = 2*margin + row_label_w + ncols*col_w_eff;
board_h  = margin + bot_m + title_h + header_h + nrows*row_h;
grid_top = board_h - margin - title_h;

car_z3  = car_z2 + (car_w - neck_w)/2;
knob_z0 = plate_t + knob_gap;
knob_z1 = knob_z0 + (knob_d - neck_w)/2;
knob_zt = knob_z1 + knob_top_h;
twist   = retention == "twist";
test_twist = test_retention == "same" ? twist : test_retention == "twist";
token_seat_z = twist ? knob_zt - tw_lip - tw_lug_h : knob_zt - m_recess_h;

// preview colour for token number i (cycles through L_colours)
function token_colour(i) = L_colours[i % len(L_colours)];

function col_x(j) = margin + row_label_w + col_w_eff*(j + 0.5);
function row_y(i) = grid_top - header_h - row_h*(i + 0.5);

// ================================================================ checks
assert(steps >= 2, str("key_symbols needs at least 2 symbols (one per step), got ", steps));
assert(print_step >= 0 && print_step < steps, str("print_step must be 0 to ", steps - 1, " (one less than the number of key_symbols)"));
assert(step_pitch >= 2*(nub_r + clr) + 1.5, "step_pitch too small for the detent notches");
assert(row_h >= 2*chan_hw + 3, "row_h too small for the slider channels");
assert(!(keyholes && cleat), "keyholes and cleat both use the title band - choose one");
assert(!(strips && cleat), "strips and cleat both use the title band - choose one");
// keyholes must sit between the two top strips
assert(!(keyholes && strips) || keyhole_spacing/2 + keyhole_head_d/2 < board_w/2 - 16 - strip_l - 1,
       str("keyholes overlap the top adhesive strips - use keyhole_spacing below ", 2*(board_w/2 - 16 - strip_l - 1) - keyhole_head_d));
assert(plate_t - keyhole_depth >= 1.5 || !keyholes, "keyhole_depth leaves the board face too thin");
assert(plate_t - cleat_depth >= 1.5 || !cleat, "cleat_depth leaves the board face too thin");
min_wall = 3*line_w;   // three lines at your extrusion width
assert((knob_d - (twist ? tw_channel_d : m_recess_d))/2 >= min_wall,
       str("knob wall too thin: knob_d must be at least ", (twist ? tw_channel_d : m_recess_d) + 2*min_wall));
assert((knob_d - (test_twist ? tw_channel_d : m_recess_d))/2 >= min_wall,
       str("knob wall too thin for the slider test: knob_d must be at least ", (test_twist ? tw_channel_d : m_recess_d) + 2*min_wall));
assert(car_z1 >= (car_w - car_b)/2 - 0.001, str("car_z1 must be at least ", (car_w - car_b)/2, " to keep the carriage flare at 45 degrees"));
assert(!use_bumpers || bumper_h - bumper_proud >= 0.4, "bumper_proud leaves the bumper pockets too shallow");
assert(!(board_magnets && cord_holes) ||
       norm([board_mag_inset - cord_hole_inset_x, board_mag_inset - cord_hole_inset_y]) >= board_mag_d/2 + cord_hole_d/2 + 0.8,
       "cord holes clash with the top corner magnets - increase cord_hole_inset_x (about 18 clears them) or turn one off");
assert(!hooks || hook_drop >= hk_lift + hook_wall + 2,
       str("hook_drop must be at least ", hk_lift + hook_wall + 2, " to leave room for the top clip"));
assert(car_b/2 <= car_w/2 - arm_t - arm_slit + 0.001,
       str("car_b can't be wider than ", 2*(car_w/2 - arm_t - arm_slit), " - the spring-arm slits would cut into it"));
assert(neck_len <= car_len, "neck_len can't be longer than car_len");
assert(car_z2 - car_z1 >= 2*nub - 0.001, "car_z2 - car_z1 must be at least 2*nub for the 45-degree nub ends");
assert(arm_slit > nub - clr, "arm_slit must be larger than nub - clr");
assert(len(L_tokens) > 0, "define at least one token");

// ================================================================ symbols
module seg(a, b, w) hull() { translate(a) circle(d=w); translate(b) circle(d=w); }

module symbol2d(name, s) {
    lw = 1.4;   // line width for outlined symbols
    if (name == "empty")
        difference() { circle(d=s); circle(d=s - 2*lw*0.5); }
    else if (name == "half") {
        difference() { circle(d=s); circle(d=s - 2*lw*0.5); }
        intersection() { circle(d=s); translate([-s, -s]) square([s, 2*s]); }
    }
    else if (name == "full")
        circle(d=s);
    else if (name == "cross")
        { seg([-.4,-.4]*s, [.4,.4]*s, s*0.18); seg([-.4,.4]*s, [.4,-.4]*s, s*0.18); }
    else if (name == "tick")
        { seg([-.45,0]*s, [-.12,-.38]*s, s*0.18); seg([-.12,-.38]*s, [.45,.42]*s, s*0.18); }
    else if (name == "star")
        polygon([for (k=[0:9]) let (r = k % 2 ? s*0.21 : s*0.52, a = 90 + k*36) [r*cos(a), r*sin(a)]]);
    else if (name == "heart")
        translate([0, -s*0.06]) scale(s/11.5) translate([0,-4.6]) rotate(45) {
            square([6,6]); translate([3,6]) circle(3); translate([6,3]) circle(3);
        }
    else if (name == "paw")
        scale(s) {
            translate([0,-0.2]) scale([1,0.82]) circle(d=0.5);
            for (p = [[-0.37,0.08],[-0.14,0.32],[0.14,0.32],[0.37,0.08]])
                translate(p) scale([0.78,1]) circle(d=0.24);
        }
    else if (name == "bone")
        rotate(30) {
            translate([-s*0.32, -s*0.08]) square([s*0.64, s*0.16]);
            for (x=[-1,1], y=[-1,1]) translate([x*s*0.36, y*s*0.11]) circle(d=s*0.26);
        }
    else if (name == "moon")
        translate([s*0.08,0]) rotate(-20) difference() {
            circle(d=s*0.95); translate([s*0.27, s*0.12]) circle(d=s*0.8);
        }
    else if (name == "triangle")
        translate([0, -s*0.08]) rotate(90) circle(d=s*1.05, $fn=3);
    else if (name == "diamond")
        scale([0.75,1]) rotate(45) square(s*0.68, center=true);
    else if (name == "bolt")
        scale(s/10) polygon([[1.8,5],[-3.2,-0.6],[-0.4,-0.6],[-1.8,-5],[3.2,0.6],[0.4,0.6]]);
    else if (name == "blank" || name == "none" || name == "")
        ;
    else
        resize([0, s*(len(name) > 1 ? 0.55 : 0.78)], auto=true)
            text(name, size=10, font=font, halign="center", valign="center");
}

// ================================================================ 2D helpers
module rounded_rect(w, h, r) offset(r) offset(-r) square([w, h]);
module stadium2d(len, w) hull() for (s=[-1,1]) translate([s*(len - w)/2, 0]) circle(d=w);
module sector2d(r, deg) polygon([[0,0], for (a=[-deg/2 : deg/8 : deg/2]) r*[cos(a), sin(a)]]);
module along_x(len) rotate([90,0,90]) linear_extrude(len, center=true) children();

module chamfered_plate(w, h, r) hull() {
    linear_extrude(0.01) translate([back_chamfer, back_chamfer])
        rounded_rect(w - 2*back_chamfer, h - 2*back_chamfer, r - back_chamfer);
    translate([0,0,back_chamfer]) linear_extrude(plate_t - back_chamfer - front_chamfer) rounded_rect(w, h, r);
    translate([0,0,plate_t - 0.01]) linear_extrude(0.01) translate([front_chamfer, front_chamfer])
        rounded_rect(w - 2*front_chamfer, h - 2*front_chamfer, r - front_chamfer);
}

// ================================================================ knob recesses
// Lip thickness (at the mouth edge) along the turn: loose at the start, ramping to
// tw_lip + tw_squeeze when locked, then constant through the extra over-travel.
tw_phimax = 90 + tw_lug_deg/2;
tw_phiend = tw_phimax + tw_turn_clr;
function tw_lip_at(phi) = phi <= tw_lug_deg/2 ? tw_lip - tw_loose
    : phi >= tw_phimax ? tw_lip + tw_squeeze
    : tw_lip - tw_loose + (tw_loose + tw_squeeze)*(phi - tw_lug_deg/2)/(tw_phimax - tw_lug_deg/2);

module twist_recess(zt) {
    zf = zt - tw_lip - tw_lug_h - tw_floor_gap;
    translate([0,0,zf]) cylinder(d=tw_mouth_d, h=zt - zf + 0.01);
    n = 24;
    rm = tw_mouth_d/2;
    rc = tw_channel_d/2;
    for (b=[0,180]) {
        rotate(b) translate([0,0,zf]) linear_extrude(zt - zf + 0.01) sector2d(rc, tw_slot_deg);
        // channel: the lip underside slopes at 45 degrees (prints without sagging,
        // knob prints upright) and drops along the turn to pull the token snug
        for (i=[0:n-1]) hull() for (phi=[tw_phiend*i/n, tw_phiend*(i+1)/n])
            let (zm = zt - tw_lip_at(phi))           // ceiling height at the mouth edge
            rotate(b + tw_lock_dir*phi) rotate([90,0,0]) linear_extrude(0.01, center=true)
                polygon([[0, zf], [rc, zf], [rc, zm - (rc - rm)], [rm, zm], [0, zm]]);
    }
}

module magnet_recess(zt) {
    translate([0,0,zt - m_recess_h]) cylinder(d=m_recess_d, h=m_recess_h + 0.01);
    translate([0,0,zt - 0.3]) cylinder(d1=m_recess_d, d2=m_recess_d + 0.6, h=0.31);
    translate([0,0,zt - m_recess_h - tmag_h]) cylinder(d=tmag_d, h=tmag_h + 0.01);
}

// ================================================================ slider (moving part)
module car_profile() polygon([
    [-car_b/2, 0], [car_b/2, 0], [car_w/2, car_z1], [car_w/2, car_z2],
    [neck_w/2, car_z3], [-neck_w/2, car_z3], [-car_w/2, car_z2], [-car_w/2, car_z1]]);

// Click-stop nub: 45-degree top and bottom so neither the nub nor the notch
// it sits in has a flat overhang.  Profile in (r, z), centred on the nub axis.
module nub_profile() polygon([
    [0, car_z1], [nub_r - nub, car_z1], [nub_r, car_z1 + nub],
    [nub_r, car_z2 - nub], [nub_r - nub, car_z2], [0, car_z2]]);
module nub_shape() rotate_extrude($fn=32) nub_profile();
// notch = the same shape grown by clr (even gap all round)
module notch_shape() rotate_extrude($fn=32)
    intersection() { offset(r=clr, $fn=16) nub_profile(); translate([0, -50]) square(100); }

module slider(tw=twist) {
    color(board_colour) {    // carriage, nubs and neck print with the board
    difference() {
        intersection() {
            along_x(car_len) car_profile();
            // chamfer the bottom edges at both ends of the carriage
            hull() {
                translate([-(car_len/2 - car_end_chamfer), -car_w, 0]) cube([car_len - 2*car_end_chamfer, 2*car_w, 0.01]);
                translate([-car_len/2, -car_w, car_end_chamfer]) cube([car_len, 2*car_w, car_z3]);
            }
        }
        // bottom arm roots at -x, top arm is turned 180 degrees (roots at +x) to balance the carriage
        for (r=[0,180]) rotate(r) mirror([0,1,0]) translate([arm_root, car_w/2 - arm_t - arm_slit, -0.01])
            cube([car_len, arm_slit, car_z3 + 0.02]);
    }
    for (r=[0,180]) rotate(r) mirror([0,1,0]) intersection() {
        translate([nub_x, car_w/2 + nub - nub_r, 0]) nub_shape();
        translate([-car_len, car_w/2 - arm_t, 0]) cube([2*car_len, 5, car_z3]);
    }
    translate([0,0,car_z3 - 0.01]) linear_extrude(knob_z0 - car_z3 + 0.02) stadium2d(neck_len, neck_w);   // starts at the carriage top so it never fills the arm slits
    }
    color(knob_colour) difference() {    // the knob: from the start of the cone upwards
        union() {
            hull() {
                translate([0,0,knob_z0]) linear_extrude(0.01) stadium2d(neck_len, neck_w);
                translate([0,0,knob_z1]) cylinder(d=knob_d, h=0.01);
            }
            hull() {
                translate([0,0,knob_z1]) cylinder(d=knob_d, h=knob_top_h - 0.3);
                translate([0,0,knob_zt - 0.3]) cylinder(d=knob_d - 0.6, h=0.3);
            }
        }
        if (tw) twist_recess(knob_zt); else magnet_recess(knob_zt);
    }
}

// cuts in the board for one slider cell (centred on the cell)
module cell_cut() {
    along_x(run) offset(r=clr) car_profile();
    translate([0,0,-0.01]) along_x(run) translate([-(car_b/2 + clr + foot_relief), 0])
        square([car_b + 2*(clr + foot_relief), 0.4]);
    translate([0,0,car_z3 - 1]) linear_extrude(plate_t - car_z3 + 1.01)
        hull() for (s=[-1,1]) translate([s*travel/2, 0]) offset(r=clr) stadium2d(neck_len, neck_w);
    // notches for both arms (the top arm's nub sits at -nub_x, so its notches shift to match)
    for (k=[0:steps-1], r=[0,180]) rotate(r) mirror([0,1,0])
        translate([step_x(k) + nub_x, car_w/2 + nub - nub_r, 0]) notch_shape();
}

// ================================================================ board
module raised_features() {
    translate([board_w/2, board_h - margin - title_h/2])
        text(title, size=title_size, font=font, halign="center", valign="center");
    if (row_header != "")
        translate([margin + 4, grid_top - header_h/2])
            text(row_header, size=label_size, font=font, valign="center");
    for (j=[0:ncols-1]) {
        translate([col_x(j), grid_top - 5.5])
            text(L_cols[j], size=label_size, font=font, halign="center", valign="center");
        for (k=[0:steps-1]) translate([col_x(j) + step_x(k), grid_top - header_h + 5])
            symbol2d(L_keys[k], key_size);
    }
    for (i=[0:nrows-1]) translate([margin + 4, row_y(i)])
        text(L_rows[i], size=label_size, font=font, valign="center");
}

// ================================================================ mounting
// bumper pads: four corners plus the middle of the top and bottom edges
// (the top-corner pads move inward to clear the cord holes when those are on)
bumper_top_x = cord_holes
    ? max(bumper_inset, cord_hole_inset_x + cord_hole_d/2 + bumper_d/2 + bumper_clr + 1.5)
    : bumper_inset;
bumper_positions = [
    [bumper_inset, bumper_inset], [board_w - bumper_inset, bumper_inset],
    [bumper_top_x, board_h - bumper_inset], [board_w - bumper_top_x, board_h - bumper_inset],
    [board_w/2, bumper_d/2 + 1.5], [board_w/2, board_h - bumper_d/2 - 1.5]];
band_y0 = board_h - margin - title_h;      // bottom of the title band

// keyhole: entry hole at the bottom, slot running up; the screw head
// slides up behind a lip.  Opens on the back face (z=0).
module keyhole() {
    translate([0,0,-0.01]) cylinder(d=keyhole_head_d, h=keyhole_depth + 0.01);
    hull() for (y=[0, keyhole_len]) translate([0,y,-0.01]) cylinder(d=keyhole_shank_d, h=keyhole_lip + 0.02);
    hull() for (y=[0, keyhole_len]) translate([0,y,keyhole_lip]) cylinder(d=keyhole_head_d, h=keyhole_depth - keyhole_lip);
}
keyhole_y0 = band_y0 + 3 + keyhole_head_d/2;

// French cleat groove: opens on the back, slants up into the board at 45 degrees
cleat_y0 = band_y0 + 4;
module cleat_groove() {
    translate([board_w/2, 0, 0]) rotate([90,0,90]) linear_extrude(cleat_len, center=true)
        polygon([[cleat_y0, -0.01], [cleat_y0 + cleat_w, -0.01],
                 [cleat_y0 + cleat_w + cleat_depth, cleat_depth], [cleat_y0 + cleat_depth, cleat_depth]]);
}

module mount_cuts() {
    if (keyholes)
        for (s=[-1,1]) translate([board_w/2 + s*keyhole_spacing/2, keyhole_y0, 0]) keyhole();
    if (strips)
        for (y=[bot_m/2 - strip_w/2 + 0.5, board_h - margin - title_h/2 - strip_w/2], s=[0,1])
            translate([s == 0 ? 16 : board_w - 16 - strip_l, y, -0.01])
                cube([strip_l, strip_w, strip_depth + 0.01]);
    if (cleat) cleat_groove();
    if (use_bumpers)
        for (p=bumper_positions) translate([p[0], p[1], -0.01])
            cylinder(d=bumper_d + 2*bumper_clr, h=bumper_h - bumper_proud + 0.01);
    if (cord_holes)
        for (x=[cord_hole_inset_x, board_w - cord_hole_inset_x])
            translate([x, board_h - cord_hole_inset_y, -0.01]) cylinder(d=cord_hole_d, h=plate_t + 1);
}

// wall rail for the French cleat.  Printed as-is: backing plate on the bed
// (this face goes against the wall), lip rising at 45 degrees.
module cleat_rail() {
    d = cleat_depth - cleat_clr;
    difference() {
        rotate([90,0,90]) linear_extrude(cleat_len - 2) {
            translate([-cleat_rail_h, 0]) square([cleat_rail_h + cleat_w + d, cleat_rail_t]);
            polygon([[cleat_clr, cleat_rail_t - 0.01], [cleat_w - cleat_clr, cleat_rail_t - 0.01],
                      [cleat_w - cleat_clr + d, cleat_rail_t + d], [cleat_clr + d, cleat_rail_t + d]]);
        }
        // countersunk screw holes in the plate below the lip
        for (x=[(cleat_len - 2)*0.15, (cleat_len - 2)/2, (cleat_len - 2)*0.85])
            translate([x, -cleat_rail_h/2, 0]) {
                translate([0,0,-0.01]) cylinder(d=cleat_screw_d, h=cleat_rail_t + 0.02);
                translate([0,0,cleat_rail_t - cleat_screw_d*0.5]) cylinder(d1=cleat_screw_d, d2=cleat_screw_d*2, h=cleat_screw_d*0.5 + 0.01);
            }
    }
}

// desk/shelf stand: the board's bottom edge drops into a slot and leans back.
// A low base swells gently into a cradle with a short front lip and a taller
// back support; every edge is rounded and the cradle blends into the base with
// a fillet.  The base sits flat on the ground.  Printed as-is, base on the bed.
module xbar(x0, x1) rotate([90,0,90]) translate([0,0,x0]) linear_extrude(x1 - x0) children();  // (y,z) profile along x
module fillet2d(r)  offset(r=-r) offset(delta=r) children();     // rounds inside corners only
module round_out2d(r) offset(r=r) offset(delta=-r) children();  // rounds outside corners only

st_wall = 3.5;
st_base = 5;                                    // base thickness under the cradle
st_fy   = stand_depth*0.4;                      // where the board's front face meets the base
st_slot = plate_t + 2*stand_slot_clr;

module stand_profile() {
    module tilt() translate([st_fy, st_base]) rotate(-stand_angle) children();
    round_out2d(0.6) difference() {
        round_out2d(stand_round) fillet2d(stand_fillet) union() {
            // base: thin at the front and back edges, full thickness under the cradle
            polygon([[0, 0], [stand_depth, 0], [stand_depth, 3.2],
                     [st_fy + 20, st_base], [st_fy - 12, st_base], [0, 3.2]]);
            // front lip and back support, leaning with the board
            tilt() translate([-st_wall, -1]) square([st_wall, stand_slot_depth + 1]);
            tilt() translate([st_slot, -1]) square([st_wall, stand_back_h + 1]);
        }
        tilt() square([st_slot, stand_back_h + 20]);
    }
}

// extrude the profile along the stand with rounded ends
module stand_body() {
    n = 6;
    R = stand_round + 0.5;
    xbar(R, stand_len - R) stand_profile();
    for (k=[1:n]) let (d0 = R*(k-1)/n, d1 = R*k/n,
                       inset = R - sqrt(max(0, R*R - (R - d1)*(R - d1))))
        for (x=[[d0, d1], [stand_len - d1, stand_len - d0]])
            xbar(x[0], x[1] + 0.001) offset(r=-inset) stand_profile();
}

module stand() difference() {
    stand_body();
    if (stand_pads)
        for (x=[14, stand_len - 14], y=[9, stand_depth - 9])
            translate([x, y, -0.01]) cylinder(d=bumper_d + 2*bumper_clr, h=bumper_h - bumper_proud + 0.01);
}

// ---------------------------------------------------------------- over-door hanger arm
// Side profile in (z, y): z = 0 is the door's front face (+z towards the room), y up.
// Built from overlapping boxes, each with chamfered edges, extruded across the arm width.
// Printed lying on its side (as made here), so the layers run along the hook.
hk_lift = hook_lip + 1;                                        // lift needed to clear the bottom lip
hk_zb   = hook_wall + hook_standoff;                           // board's back face
hk_zf   = hk_zb + plate_t + hook_clr;                          // board's front face (+ clearance)
hk_yb   = hook_wall;                                           // board's bottom edge
hk_yt   = hk_yb + board_h;                                     // board's top edge (when seated)
hk_ydt  = hk_yt + hook_drop;                                   // underside of the bridge over the door
hk_gap  = hook_door_t + hook_tol;                              // inside of the hook

module zpiece(c, h) hull() {
    translate([0,0,c]) linear_extrude(h - 2*c) offset(delta=c, chamfer=true) offset(delta=-c) children();
    linear_extrude(h) offset(delta=-c) children();
}
module cbox(z0, y0, z1, y1) {
    ce = max(0.01, min(hook_chamfer, (z1 - z0)/2 - 0.2, (y1 - y0)/2 - 0.2, hook_width/2 - 0.2));
    zpiece(ce, hook_width) translate([z0, y0]) square([z1 - z0, y1 - y0]);
}

module hook_arm() {
    w = hook_wall;
    cbox(0, 0, w, hk_ydt + hook_top_t);                                     // arm down the door face
    cbox(-hk_gap - w, hk_ydt, w, hk_ydt + hook_top_t);                      // bridge over the door top
    cbox(-hk_gap - w, hk_ydt - hook_tail, -hk_gap, hk_ydt + hook_top_t);    // tail down the back of the door
    cbox(w - 1, hk_yb, hk_zb, hk_yb + 8);                                   // standoff rib, bottom
    cbox(w - 1, hk_yt - 8, hk_zb, hk_yt);                                   // standoff rib, top
    cbox(0, 0, hk_zf + w, hk_yb);                                           // ledge under the board
    cbox(hk_zf, 0, hk_zf + w, hk_yb + hook_lip);                            // front lip at the bottom
    cbox(w - 1, hk_yt + hk_lift, hk_zf + w, hk_yt + hk_lift + w);           // top clip bar
    cbox(hk_zf, hk_yt - hook_lip, hk_zf + w, hk_yt + hk_lift + w);          // front lip at the top
}
// both arms, laid long side along x
module hook_arms() for (i=[0,1]) translate([0, i*(hk_gap + hk_zf + 2*hook_wall + 10), 0])
    rotate(-90) translate([hk_gap + hook_wall, 0, 0]) hook_arm();

// Separate mounting parts, laid out beside the board in the board STL
// (cleat rail, stand and hanger arms below it).
module mount_extras() {
    rail_top = cleat_w + cleat_depth;
    y_rail  = -10 - rail_top;
    y_stand = (cleat ? y_rail - cleat_rail_h - 10 : -10) - stand_depth;
    if (cleat) translate([(board_w - cleat_len)/2, y_rail, 0]) cleat_rail();
    if (stand) translate([(board_w - stand_len)/2, y_stand, 0]) stand();
    y_hooks = (stand ? y_stand : cleat ? y_rail - cleat_rail_h : 0) - 10 - 2*(hk_gap + hk_zf + 2*hook_wall + 10);
    if (hooks) translate([0, y_hooks, 0]) hook_arms();
}

module board_fixed() {
    color(board_colour) difference() {
        chamfered_plate(board_w, board_h, corner_r);
        for (i=[0:nrows-1], j=[0:ncols-1]) translate([col_x(j), row_y(i), 0]) cell_cut();
        if (board_magnets)
            for (x=[board_mag_inset, board_w - board_mag_inset],
                 y=[board_mag_inset, board_h - board_mag_inset])
                translate([x, y, -0.01]) cylinder(d=board_mag_d, h=board_mag_h + 0.01);
        mount_cuts();
    }
    color(text_colour) translate([0,0,plate_t]) linear_extrude(relief) raised_features();
}

module board() {
    board_fixed();
    for (i=[0:nrows-1], j=[0:ncols-1])
        translate([col_x(j) + step_x(print_step), row_y(i), 0]) { slider(); breakaway_tabs(); }
}

// tiny first-layer bridges from the carriage's underside edge across the gap to the board
module breakaway_tabs() if (slider_tabs) color(board_colour) {
    reach = car_b/2 + clr + foot_relief;            // edge of the board's opening at the first layer
    xs = tabs_per_side >= 2 ? [-1, 1]*(car_len/2 - car_end_chamfer - 1.5) : [0];
    for (x=xs, sgn=[-1, 1])
        translate([x - tab_w/2, sgn > 0 ? car_b/2 - 0.3 : -reach - 0.6, 0])
            cube([tab_w, reach - car_b/2 + 0.9, tab_h]);
}

module slider_test() {
    tw = run + 10;
    th = 2*chan_hw + 8;
    color(board_colour) difference() {
        translate([-tw/2, -th/2, 0]) chamfered_plate(tw, th, 3);
        cell_cut();
    }
    translate([step_x(print_step), 0, 0]) { slider(test_twist); breakaway_tabs(); }
    // a test token next to the coupon
    translate([tw/2 + token_face_d/2 + 4, 0, 0]) token(L_tokens[0], test_twist, token_colour(0));
}

// ================================================================ tokens
function t_plug_d(tw) = (tw ? tw_mouth_d : m_recess_d) - 2*fit;
function t_plug_h(tw) = tw ? tw_lip + tw_lug_h - fit : m_recess_h - 0.1;
function t_cham_h(tw) = (token_face_d - t_plug_d(tw))/2;
function t_h(tw)      = t_plug_h(tw) + t_cham_h(tw) + face_flat + 0.4;   // height before the symbol

// Local coords: underside of the plug at z=0. Print as-is (plug down).
// tw = true for a twist-lock token, false for a magnet token.
module token(name="star", tw=twist, col=undef) {
    pd = t_plug_d(tw); ph = t_plug_h(tw); ch = t_cham_h(tw); th = t_h(tw);
    color(is_undef(col) ? token_colour(0) : col) difference() {
        union() {
            cylinder(d=pd, h=ph);
            translate([0,0,ph]) cylinder(d1=pd, d2=token_face_d, h=ch);
            translate([0,0,ph + ch]) cylinder(d=token_face_d, h=face_flat);
            translate([0,0,th - 0.4]) cylinder(d1=token_face_d, d2=token_face_d - 0.8, h=0.4);
            if (tw) intersection() {
                for (b=[0,180]) rotate(b) linear_extrude(tw_lug_h) sector2d(tw_lug_d/2, tw_lug_deg);
                // 45-degree top to match the knob's sloped lip
                cylinder(r1=tw_mouth_d/2 + tw_lug_h, r2=tw_mouth_d/2, h=tw_lug_h);
            }
        }
        if (!tw) translate([0,0,-0.01]) cylinder(d=tmag_d, h=tmag_h + 0.01);
        // vertical grip flutes around the edge (vertical cuts print cleanly)
        if (grip_count > 0) for (a=[0:grip_count-1]) rotate(a*360/grip_count)
            translate([token_face_d/2 + grip_w/2 - grip_depth, 0, ph]) scale([1, 1, 1])
                cylinder(d=grip_w, h=th, $fn=16);
    }
    color(text_colour) translate([0,0,t_h(tw) - 0.01]) linear_extrude(symbol_h + 0.01)
        rotate(tw ? -tw_lock_dir*90 : 0) symbol2d(name, symbol_size);
}

// ================================================================ tray
t_in_x0 = tray_wall_t;
t_in_x1 = tray_w - tray_wall_t;
t_in_y0 = tray_back_t;
t_in_y1 = tray_d - tray_wall_t;
t_big   = tray_back_h + 20;
t_slope = (tray_front_h - tray_back_h)/tray_d;

module rrect(x0, y0, x1, y1, r) translate([x0 + r, y0 + r]) offset(r) square([x1 - x0 - 2*r, y1 - y0 - 2*r]);
module tray_outer2d() rrect(0, 0, tray_w, tray_d, tray_outer_r);
module tray_inner2d() rrect(t_in_x0, t_in_y0, t_in_x1, t_in_y1, tray_inner_r);
module tray_shear() multmatrix([[1,0,0,0],[0,1,0,0],[0,t_slope,1,0],[0,0,0,1]]) children();

module tray_cavity() hull() for (x=[t_in_x0 + tray_inner_r, t_in_x1 - tray_inner_r]) {
    translate([x, t_in_y0 + tray_inner_r, tray_floor_t + tray_inner_r]) sphere(r=tray_inner_r);
    for (k=[0:12]) let (a = 90*k/12)
        translate([x, t_in_y1 - tray_scoop_r + (tray_scoop_r - tray_inner_r)*sin(a),
                      tray_floor_t + tray_scoop_r - (tray_scoop_r - tray_inner_r)*cos(a)])
            sphere(r=tray_inner_r);
    for (y=[t_in_y0 + tray_inner_r, t_in_y1 - tray_inner_r]) translate([x, y, t_big]) sphere(r=tray_inner_r);
}

module tray_mag_pocket() rotate([-90,0,0]) translate([0,0,-0.01]) linear_extrude(tray_mag_h + 0.01)
    rotate(180) hull() {
        circle(d=tray_mag_d);
        translate([0, tray_mag_d/2*sqrt(2)]) rotate(45) square(0.01, center=true);
    }

module tray() {
    steps_r = 10;
    difference() {
        intersection() {
            hull() {
                linear_extrude(0.01) offset(-tray_chamfer) tray_outer2d();
                translate([0,0,tray_chamfer]) linear_extrude(t_big) tray_outer2d();
            }
            tray_shear() {
                translate([0,0,-t_big]) linear_extrude(t_big + tray_back_h - tray_top_r) tray_outer2d();
                for (i=[1:steps_r]) {
                    a0 = 90*(i-1)/steps_r; a1 = 90*i/steps_r;
                    z0 = tray_back_h - tray_top_r + tray_top_r*sin(a0);
                    z1 = tray_back_h - tray_top_r + tray_top_r*sin(a1);
                    translate([0,0,z0 - 0.001]) linear_extrude(z1 - z0 + 0.002)
                        offset(r = -tray_top_r*(1 - cos(a1)))
                            difference() { tray_outer2d(); tray_inner2d(); }
                }
            }
        }
        tray_cavity();
        for (c=[0:tray_mag_cols-1], r=[0:tray_mag_rows-1])
            let (x = tray_mag_cols == 1 ? tray_w/2
                     : tray_mag_inset_x + c*(tray_w - 2*tray_mag_inset_x)/(tray_mag_cols - 1),
                 z = tray_mag_rows == 1 ? (tray_mag_low_z + tray_mag_high_z)/2
                     : tray_mag_low_z + r*(tray_mag_high_z - tray_mag_low_z)/(tray_mag_rows - 1))
            translate([x, 0, z]) tray_mag_pocket();
    }
    if (tray_compartments > 1)
        for (k=[1:tray_compartments-1])
            let (x = t_in_x0 + k*(t_in_x1 - t_in_x0)/tray_compartments)
            intersection() {
                tray_cavity();
                translate([x - tray_divider_t/2, 0, 0]) cube([tray_divider_t, tray_d, t_big]);
                tray_shear() translate([0,0,-t_big]) linear_extrude(t_big + tray_back_h - tray_top_r) tray_outer2d();
            }
}

// ================================================================ output
if (part == "board") {
    board_fixed();
    for (i=[0:nrows-1], j=[0:ncols-1])
        translate([col_x(j) + step_x(print_step), row_y(i), 0]) { slider(); breakaway_tabs(); }
    color(board_colour) mount_extras();
}
else if (part == "slider_test") slider_test();
else if (part == "token") token(L_tokens[token_index], twist, token_colour(token_index));
else if (part == "tray") color(tray_colour) tray();
else if (part == "info") {
    // machine-readable lines used by build_stls.py
    echo(str("RETENTION=", retention));
    echo(str("TEST_RETENTION=", test_twist ? "twist" : "magnet"));
    for (i=[0:len(L_tokens)-1]) echo(str("TOKEN=", i, "=", L_tokens[i]));
    // human-readable summary of the current settings
    mounts = [for (m=[["magnets", board_magnets], ["keyholes", keyholes], ["adhesive strips", strips],
                      ["French cleat + wall rail", cleat], ["cord holes", cord_holes],
                      ["stand", stand], ["door hooks", hooks], ["bumper pads", use_bumpers]]) if (m[1]) m[0]];
    echo(str("INFO: title            = \"", title, "\""));
    echo(str("INFO: board            = ", board_w, " x ", board_h, " mm, ", plate_t, " mm thick, ",
             knob_zt, " mm tall with knobs"));
    echo(str("INFO: rows (", nrows, ")         = ", L_rows));
    echo(str("INFO: columns (", ncols, ")      = ", L_cols, ", each ", col_w_eff, " mm wide"));
    echo(str("INFO: steps (", steps, ")        = ", L_keys, ", ", step_pitch, " mm apart, printed at step ", print_step));
    echo(str("INFO: sliders          = ", nrows*ncols, ", clearance ", clr, " mm, neck ", neck_w, " x ", neck_len, " mm"));
    echo(str("INFO: knob             = ", knob_d, " mm, wall ", (knob_d - (twist ? tw_channel_d : m_recess_d))/2, " mm (min ", min_wall, ")"));
    echo(str("INFO: token retention  = ", retention, " (slider test: ", test_twist ? "twist" : "magnet", ")"));
    echo(str("INFO: tokens (", len(L_tokens), ")       = ", L_tokens));
    echo(str("INFO: colour change    = board text starts at ", plate_t, " mm, token symbols at ", t_h(twist), " mm"));
    echo(str("INFO: mounting         = ", len(mounts) ? mounts : "none"));
    if (board_magnets) echo(str("INFO: board magnets    = ", board_mag_d, " x ", board_mag_h, " mm pockets"));
    if (use_bumpers) echo(str("INFO: bumper pads      = ", len(bumper_positions), " x ", bumper_d, " x ", bumper_h,
                              " mm pads, standing ", bumper_proud, " mm proud", bumpers == "auto" ? " (added automatically)" : ""));
    echo(str("INFO: slider underside = ", car_b, " x ", car_len, " mm, ", car_end_chamfer, " mm end chamfers"));
    echo(str("INFO: breakaway tabs   = ", slider_tabs ? str(2*tabs_per_side, " per slider, ", tab_w, " x ", tab_h, " mm") : "off"));
    if (hooks) echo(str("INFO: door hooks       = for a ", hook_door_t, " mm door (+", hook_tol, " mm), arms ",
                        round(hk_ydt + hook_top_t), " mm long, board top ", hook_drop, " mm below the door top"));
    if (cleat || stand || hooks)
        echo(str("INFO: board STL also contains: ", [for (m=[["cleat rail", cleat], ["stand", stand], ["2 hanger arms", hooks]]) if (m[1]) m[0]]));
    cube(1);   // something to export
}
else {
    board_fixed();
    for (i=[0:nrows-1], j=[0:ncols-1])
        let (k = (i*7 + j*3) % steps)
        translate([col_x(j) + step_x(k), row_y(i), 0]) {
            slider();
            if (show_tokens && k != print_step)
                translate([0,0,token_seat_z]) rotate(twist ? tw_lock_dir*90 : 0)
                    token(L_tokens[(i + j) % len(L_tokens)], twist, token_colour((i + j) % len(L_tokens)));
        }
}
