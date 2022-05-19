
function rpiWidth() = 56;
function rpiHeight() = 85;

function spkWidth() = 30;
function spkHeight() = 70;
function spkDepth() = 17;

module rpi_screw(height) {
    x0 = 3.5; y0 = 3.5;
    x = 49; y = 58;

    translate([x0, y0, 0]) {
        linear_extrude(height=height) {
            difference() {
                translate([0, 0]) circle(r=(5 / 2), $fn=16);
                translate([0, 0]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([x, 0]) circle(r=(5 / 2), $fn=16);
                translate([x, 0]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([0, y]) circle(r=(5 / 2), $fn=16);
                translate([0, y]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([x, y]) circle(r=(5 / 2), $fn=16);
                translate([x, y]) circle(r=(2.5 / 2), $fn=16);
            }
        }
    }
}

module spk_screw(height) {
    x0 = 3; y0 = 3;
    x = spkWidth() - 6; y = spkHeight() - 6;

    translate([x0, y0, 0]) {
        linear_extrude(height=height) {
            difference() {
                translate([0, 0]) circle(r=(5 / 2), $fn=16);
                translate([0, 0]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([x, 0]) circle(r=(5 / 2), $fn=16);
                translate([x, 0]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([0, y]) circle(r=(5 / 2), $fn=16);
                translate([0, y]) circle(r=(2.5 / 2), $fn=16);
            }
            difference() {
                translate([x, y]) circle(r=(5 / 2), $fn=16);
                translate([x, y]) circle(r=(2.5 / 2), $fn=16);
            }
        }
    }
}

module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360])
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24) {
    difference() {
        sector(radius + width, angles, fn);
        sector(radius, angles, fn);
    }
}

module rounded_cylinder(r, h, border_r=2, fn = 24)
{
    rotate_extrude($fn=fn)
        hull() {
            translate([0, 0, 0])
                square([r,border_r]);

            translate([0, h - border_r, 0])
                square([r - border_r, border_r]);

            translate([r - border_r, h - border_r, 0])
                circle(border_r);
        }
}
