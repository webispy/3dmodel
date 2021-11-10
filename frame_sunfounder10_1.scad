// Higher definition curves
//$fs = 0.01;
//$fn = 60;
$fn = 30;

use <sunfounder10_1.scad>

// ----------------------------------------------------------------

FrameWidth = 270;
FrameHeight = 180;
FrameDepth = 14;

FrameShortWidth = 37;

holeVerticalMargin = 10;
holeHorizontalMargin = 5;
holeDistance = 20;

holeHeight = FrameHeight - holeVerticalMargin * 2;
holeWidth = FrameWidth - holeHorizontalMargin * 2;

echo("holeHeight = ", holeHeight);
echo("holeWidth = ", holeWidth);
echo("holeDistance = ", holeDistance);

module ScrewHole() {
    color("red") {
        for (y = [0:holeDistance:holeHeight]) {
            for (x = [0, 20, 120, 140, 160, 180, 220, 240, 260]) {
                translate([-FrameWidth / 2 + holeHorizontalMargin + x,
                           -FrameHeight / 2 + holeVerticalMargin + y,
                           FrameDepth - 5])
                    cylinder(5, r=1.25);
            }
        }

        for (x = [0:holeDistance:holeWidth]) {
            for (y = [0, 20, 40, 160]) {
                translate([-FrameWidth / 2 + holeHorizontalMargin + x,
                           -FrameHeight / 2 + holeVerticalMargin + y,
                           FrameDepth - 5])
                    cylinder(5, r=1.25);
            }
        }
    }
}

module FrameShortLeft() {
    Debug = 0;

    if (Debug) {
        sunfounder_10_1();
        color(alpha=0.7)
            translate([-FrameWidth / 2, -FrameHeight / 2, 0])
                cube([FrameShortWidth, FrameHeight, FrameDepth]);
        ScrewHole();
    } else {
        difference() {
            translate([-FrameWidth / 2, -FrameHeight / 2, 0])
                cube([FrameShortWidth, FrameHeight, FrameDepth]);

            sunfounder_10_1();
            ScrewHole();
        }
    }
}

module FrameShortRight() {
    Debug = 0;

    if (Debug) {
        sunfounder_10_1();
        color(alpha=0.7)
            translate([FrameWidth / 2 - FrameShortWidth, -FrameHeight / 2, 0])
                cube([FrameShortWidth, FrameHeight, FrameDepth]);
        ScrewHole();
    } else {
        difference() {
            translate([FrameWidth / 2 - FrameShortWidth, -FrameHeight / 2, 0])
                cube([FrameShortWidth, FrameHeight, FrameDepth]);

            sunfounder_10_1();
            ScrewHole();
        }
    }
}

module FrameAll() {
    Debug = 0;
    TestPrint = 0;

    if (Debug) {
        sunfounder_10_1();
        color(alpha=0.7)
            translate([-FrameWidth / 2, -FrameHeight / 2, 0])
                cube([FrameWidth, FrameHeight, FrameDepth]);
        ScrewHole();
    } else {
        difference() {
            translate([-FrameWidth / 2, -FrameHeight / 2, 0])
                cube([FrameWidth, FrameHeight, FrameDepth]);

            sunfounder_10_1();
            ScrewHole();

            if (TestPrint) {
                translate([-FrameWidth / 2, -FrameHeight / 2, 0]) {
                    cube([FrameWidth, 140, FrameDepth]);
                    cube([20, FrameHeight, FrameDepth]);
                }
                translate([FrameWidth / 2 - 20, -FrameHeight / 2, 0])
                    cube([20, FrameHeight, FrameDepth]);
                translate([-(FrameWidth - 60) / 2, FrameHeight / 2 - 20, 0])
                    cube([FrameWidth - 100, 20, FrameDepth]);
            }
        }
    }
}

// ----------------------------------------------------------------

echo(version=version());

FLAG_LEFTSIDE = 0;
FLAG_RIGHTSIDE = 0;
FLAG_ALL = 1;

if (FLAG_LEFTSIDE) {
    FrameShortLeft();
}

if (FLAG_RIGHTSIDE) {
    FrameShortRight();
}

if (FLAG_ALL) {
    FrameAll();
}
