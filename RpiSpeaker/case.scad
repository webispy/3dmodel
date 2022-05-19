use <../externals/openscad-rpi-library/misc_boards.scad>

fn = 128;

// Raspberry Pi 4
rpi_w  = 56;
rpi_h = 85;

rpi_x = -rpi_w/2 + 15;
rpi_y = -rpi_h/2;

// Mono Speaker
spk_w = 30;
spk_h = 70;
spk_d = 17;

spk_x = -spk_w/2 - 32;
spk_y = -spk_h/2;

// Circle style case
circle_r = 65;

screwHoleHeight = 3;

bottom_base_depth = 1;
bottom_border_depth = 7;

top_base_depth = 1;
top_border_depth = 25;

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

module bottom_base_screw() {
    linear_extrude(height=screwHoleHeight) {

        // Hole for support
        translate([circle_r/1.25, 0]) difference() {
            circle(r=(5 / 2), $fn=16);
            circle(r=(2.5 / 2), $fn=16);
        }
        translate([-circle_r/1.25, 0]) difference() {
            circle(r=(5 / 2), $fn=16);
            circle(r=(2.5 / 2), $fn=16);
        }
        translate([0, circle_r/1.25]) difference() {
            circle(r=(5 / 2), $fn=16);
            circle(r=(2.5 / 2), $fn=16);
        }
        translate([0, -circle_r/1.25]) difference() {
            circle(r=(5 / 2), $fn=16);
            circle(r=(2.5 / 2), $fn=16);
        }
    }
}


module rpi_screw() {
    x0 = 3.5; y0 = 3.5;
    x = 49; y = 58;

    translate([x0, y0, 0]) {
        linear_extrude(height=screwHoleHeight) {
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


module spk_screw() {
    x0 = 3; y0 = 3;
    x = spk_w - 6; y = spk_h - 6;

    translate([x0, y0, 0]) {
        linear_extrude(height=screwHoleHeight) {
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

module bottom_base_panel() {
    linear_extrude(height=bottom_base_depth) {
        difference() {
            circle(r=circle_r, $fn =fn);

            // Hole in rpi
            translate([rpi_x + rpi_w/2, rpi_y + rpi_h/2])
                circle(r=20, $fn =fn);

            // Hole in spk
            translate([spk_x + spk_w/2, spk_y + spk_h/2])
                circle(r=10, $fn =fn);

            // Hole for support
            translate([circle_r/1.25, 0])
                circle(r=2.5/2, $fn =fn);
            translate([-circle_r/1.25, 0])
                circle(r=2.5/2, $fn =fn);
            translate([0, circle_r/1.25])
                circle(r=2.5/2, $fn =fn);
            translate([0, -circle_r/1.25])
                circle(r=2.5/2, $fn =fn);
        }
    }

    // Border - inside
    linear_extrude(height=screwHoleHeight) {
        difference() {
            circle(r=circle_r - 3, $fn =fn);
            circle(r=circle_r - 5, $fn =fn);
        }
    }

    // Border - outside
    difference() {
        linear_extrude(height=bottom_border_depth) {
            difference() {
                circle(r=circle_r - 2, $fn =fn);
                circle(r=circle_r - 4, $fn =fn);
            }
        }

        linear_extrude(height=2) {
            difference() {
                circle(r=circle_r - 2, $fn =fn);
                circle(r=circle_r - 3, $fn =fn);
            }
        }

        // Hole for USB-A * 4 + LAN
        translate([rpi_x, 0, 0])
            cube([rpi_w, rpi_h, bottom_border_depth]);

        // Hole for USB-C + HDMI
        translate([rpi_x + 55, rpi_y - 10, 0])
            cube([30, 45, bottom_border_depth]);
    }

    // Line guard - USB-A * 4 + LAN
    translate([rpi_x - 2 , rpi_y + rpi_h + 2, 0])
        cube([2, 15.5, bottom_border_depth]);

    // Line guard - USB-C + HDMI
    translate([rpi_x + rpi_w + 1, rpi_y + 35, 0])
        cube([17, 2, bottom_border_depth]);
}

module top_base_panel() {
    linear_extrude(height=top_base_depth) {
        difference() {
            circle(r=circle_r, $fn =fn);
            circle(r=circle_r-20, $fn =fn);
            arc(circle_r - 10, [-10, 10], 2, fn=fn);
            arc(circle_r - 10, [80, 100], 2, fn=fn);
            arc(circle_r - 10, [170, 190], 2, fn=fn);
            arc(circle_r - 10, [260, 280], 2, fn=fn);
        }
    }

    angles1 = [190, 190+35];
    angles2 = [85, 85+45];

    translate([0,0,top_border_depth-1.8]) {
        linear_extrude(1.8) arc(circle_r - 3, angles1, 3, fn=fn);
        linear_extrude(1.8) arc(circle_r - 3, angles2, 3, fn=fn);
    }

    // Border - outside
    difference() {
        linear_extrude(height=top_border_depth) {
            difference() {
                circle(r=circle_r, $fn =fn);
                circle(r=circle_r - 1.9, $fn =fn);
            }
        }

        // Hole for USB-A * 4 + LAN
        rotate([0,180,180]) translate([rpi_x, 0, -top_border_depth])
            cube([rpi_w, rpi_h, top_border_depth-5]);

        // Hole for USB-C + HDMI
        rotate([0,180,180]) translate([rpi_x + 55, rpi_y - 10, -top_border_depth])
            cube([30, 45, top_border_depth-10]);
    }


}

// -------------------------

module caseBottom() {
    bottom_base_panel();

    translate([0,0,bottom_base_depth]) {
        bottom_base_screw();

        translate([rpi_x, rpi_y, 0]) {
            rpi_screw();

            if (WITH_BOARD) {
                translate([0, 0, screwHoleHeight]) color([.5,.5,.5,.5])
                    board_raspberrypi_4_model_b();
            }
        }

        translate([spk_x, spk_y, 0]) {
            spk_screw();

            if (WITH_BOARD) {
                translate([0, 0, screwHoleHeight]) color([.5,.5,.5,.1])
                    cube([spk_w,spk_h,spk_d]);
            }
        }
    }
}

module caseTop() {
    top_base_panel();
}

USE_BOTTOM = 1;
USE_TOP = 0;
WITH_BOARD = 1;

if (USE_BOTTOM)
    translate([0,0,0]) color([.5,.8,.5,.8])
        caseBottom();

if (USE_TOP) {
    rotate([0,180,0])
    translate([0,0,-26]) color([.8,.5,.5,.9])
        caseTop();
}

//    translate([0,140,0]) color([.8,.5,.5,1])
//        caseTop();
