include <key_definitions.scad>
use <key_support.scad>

$fn = 30;

KEYS = [
    [U1, U1],
    [U15, U1],
];

border = 5;
width = 47 + (border * 2);

DrawTopPlate = 0;
DrawKeyboardBody = 1;
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

if (DrawKeyboardBody) {
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
