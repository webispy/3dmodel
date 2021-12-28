include <key_definitions.scad>
use <key_support.scad>

$fn = 30;

KEYS_LEFT_1 = [
    [U1, U1, U1, U1, U1, U1, U1],
    [U15, U1, U1, U1, U1, U1],
    [U175, U1, U1, U1, U1, U1],
    [U225, U1, U1, U1, U1, U1],
    [U125, U125, U125, U125, U2]
];

KEYS_LEFT_old = [
    [U1, U1, U1, U1, U1, U1, U1],   /*   Esc 1 2 3 4 5 6 */
    [U125, U1, U1, U1, U1, U1],     /*   Tab  Q W E R T */
    [U175, U1, U1, U1, U1, U1],     /*   Ctrl  A S D F G */
    [U125, U1, U1, U1, U1, U1, U1], /*  Shift Caps Z X C V B */
    [U1, U125, U125, U1, U1, U15]   /*    Fn Opt Alt ? ? Space */
];

KEYS_LEFT_0124 = [
    [U1, U1, U1, U1, U1, U1, U1],   /* 7:  Esc 1 2 3 4 5 6 */
    [U15, U1, U1, U1, U1, U1],      /* 6:  Tab Q W E R T */
    [U175, U1, U1, U1, U1, U1],     /* 6:  Ctrl A S D F G */
    [-9, U175, U1, U1, U1, U1, U1], /* 6:  Shift Z X C V B */
    [U1, U125, U125, U1, U1, U175]  /* 6:  Fn Opt Alt Ml Mr Space */
];

KEYS = KEYS_LEFT_0124;

border = 5;
width = 136.5 + (border * 2);

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
