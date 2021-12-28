include <key_definitions.scad>
use <key_support.scad>

$fn = 30;


KEYS_RIGHT_1 = [
    [-15,   U1, U1, U1, U1, U1, U1, U15],    /* 7 8 9 0 - + bs */
    [ -4.5, U1, U1, U1, U1, U1, U1, U1, U1], /* Y U I O P [ ] \ */
    [-10.5, U1, U1, U1, U1, U1, U1, U175],   /* H J K L ; ' Enter */
    [U1, U1, U1, U1, U1, U1, U1, U125],      /* B N M < > / ↑ Shift */
    [U175, U125, U125, U1, U1, U1, U1 ]      /* Space Alt Ctrl Fn ← ↓ → */
];

KEYS_RIGHT_2 = [
    [-14.5,  U1, U1, U1, U1, U1, U1,  U15],        /* 7:  7 8 9 0 - + bs */
    [ -4.5, U1, U1, U1, U1, U1, U1, U1, U1],       /* 8: Y U I O P [ ] \ */
    [-10,    U1, U1, U1, U1, U1, U1, U175],        /* 7:  H J K L ; ' Enter */
    [      U1, U1, U1, U1, U1, U1, U15, U1],       /* 8: B N M < > / Shift ↑ */
    [U175, U125, U125, -15.5, U1, -9, U1, U1, U1 ] /* 7: Space Alt Ctrl Fn ← ↓ → */
];

KEYS = KEYS_RIGHT_2;

border = 5;

width = 180 + (border * 2);
height = getKeyboardHeight(border, KEYS);

DrawTopPlate = 1;
DrawKeyboard = 0;
DrawBottomPlate = 0;
DrawProto = 0;

if (DrawTopPlate) {
    translate([0, 0, 50])
        difference() {
            KeyboardTopPlate(border, width, KEYS);
            screwHole(border, width, KEYS,
                holeDepth = getTopPlateDepth(), cornerDepth = 3);
        }
}

if (DrawKeyboard) {
    translate([0, 0, 20])
        difference() {
            KeyboardBody(border, width, KEYS);
            screwHole(border, width, KEYS);
        }
}

if (DrawBottomPlate) {
    translate([0, 0, -getBottomPlateDepth()])
        difference() {
            KeyboardBottomPlate(border, width, KEYS);
            screwHole(border, width, KEYS,
                holeDepth = getBottomPlateDepth(),
                cornerDepth = getBottomPlateDepth()/2,
                screwPositionTop = false);
        }
}

if (DrawProto) {
    translate([0, 0, 5])
        difference() {
            KeyboardProto(border, width, KEYS);
            screwHole(border, width, KEYS);
        }
}
