include <key_definitions.scad>
use <key_support.scad>

$fn = 30;

KEYS = [
    [U1]
];

border = 5;
width = 19 + (border * 2);

DrawTopPlate = 1;
DrawKeyboardBody = 0;
DrawBottomPlate = 0;
DrawProto = 0;

if (DrawTopPlate) {
    translate([0, 0, 50])
            KeyboardTopPlate(border, width, KEYS);
}

if (DrawKeyboardBody) {
    translate([0, 0, 20])
            KeyboardBody(border, width, KEYS);
}

if (DrawBottomPlate) {
    translate([0, 0, -getBottomPlateDepth()])
            KeyboardBottomPlate(border, width, KEYS);
}

if (DrawProto) {
    translate([0, 0, 5])
            KeyboardProto(border, width, KEYS);
}
