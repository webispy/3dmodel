use <../externals/openscad-rpi-library/misc_boards.scad>
use <common.scad>

fn = 128;

// Raspberry Pi 4
rpi_x = -rpiWidth()/2;
rpi_y = -rpiHeight()/2;

// Mono Speaker
spk_w = spkWidth();
spk_h = spkHeight();
spk_d = spkDepth();

spk_x = -spk_w/2;
spk_y = -spk_h/2;

// Circle style case
circle_r = 55;
bottom_circle_r = circle_r - 10;
circle_border = 2;

screwHoleHeight = 3;

bottom_base_depth = 1;
bottom_border_depth = 10;
middle_border_depth = 37;

middle_panel_z = bottom_base_depth + screwHoleHeight + spk_d;
middle_panel_depth = 1;

top_base_depth = 1;
top_inner_border_depth = 5;
top_border_power_corner_depth = 10;
top_border_lan_corner_depth = 3;

depth = bottom_border_depth + middle_border_depth + top_base_depth;


module middle_panel_support() {
    x1 = -spk_w/2 - 22;
    x2 = spk_w/2 + 2;
    y1 = -spk_h/3;
    y2 = spk_h/3;
    d = middle_panel_z - middle_panel_depth;

    translate([x1,y1,0]) {
        cube([20, 4, d]);
        translate([17, -4, 0])
            cube([3, 4, d]);
        translate([2, 1, d])
            cube([16, 2, 2]);
    }

    translate([x1,y2,0]) {
        cube([20, 4, d]);
        translate([17, 4, 0])
            cube([3, 4, d]);
        translate([2, 1, d])
            cube([16, 2, 2]);
    }

    translate([x2,y1,0]) {
        cube([20, 4, d]);
        translate([0, -4, 0])
            cube([3, 4, d]);
        translate([2, 1, d])
            cube([16, 2, 2]);
    }

    translate([x2,y2,0]) {
        cube([20, 4, d]);
        translate([0, 4, 0])
            cube([3, 4, d]);
        translate([2, 1, d])
            cube([16, 2, 2]);
    }
}

module middle_panel() {
    x1 = -spk_w/2 - 22;
    x2 = spk_w/2 + 2;
    y1 = -spk_h/3;
    y2 = spk_h/3;
    margin = 0.2;

    difference() {
        cylinder(h = bottom_base_depth, r = circle_r - circle_border - margin, $fn=fn);

        translate([x1,y1,0])
            translate([2 - margin, 1 - margin, 0])
                cube([16 + margin*2, 2 + margin*2, 2]);

        translate([x1,y2,0])
            translate([2 - margin, 1 - margin, 0])
                cube([16 + margin*2, 2 + margin*2, 2]);

        translate([x2,y1,0])
            translate([2 - margin, 1 - margin, 0])
                cube([16 + margin*2, 2 + margin*2, 2]);

        translate([x2,y2,0])
            translate([2 - margin, 1 - margin, 0])
                cube([16 + margin*2, 2 + margin*2, 2]);

        translate([spk_x - 1, spk_y - 1, 0])
            cube([spk_w + 2, spk_h + 2, 2]);

        // Spk cable hole
        translate([-5/2,-circle_r,0])
            cube([5,5,2]);
    }
}

module holl_around_circle(radius, h=10, hole_r=1, start_angle=0, angle_incr=10) {
    for(angle = [start_angle:angle_incr:start_angle + 360]) {
        translate([radius * sin(angle), radius * cos(angle), 0])
            rotate([angle - 90, 90, 0])
                cylinder(h=h, r=hole_r);
    }
}

module bottom_base_panel() {
    /* Bottom area */
    difference() {
        cylinder(h = bottom_border_depth,
            r1 = bottom_circle_r,
            r2 = circle_r, $fn=fn);

        cylinder(h = bottom_border_depth,
            r1 = bottom_circle_r - circle_border,
            r2 = circle_r - circle_border, $fn=fn);

        if (WITH_BOTTOM_HOLE) {
            translate([0,0,4])
                holl_around_circle(bottom_circle_r);
            translate([0,0,7])
                holl_around_circle(bottom_circle_r, start_angle=10/2);
        }
    }

    cylinder(h = bottom_base_depth, r = bottom_circle_r, $fn=fn);

    /* Middle area */
    cut_y = middle_panel_z - bottom_border_depth + middle_panel_depth;
    translate([0,0,bottom_border_depth])
        difference() {
            cylinder(h = middle_border_depth, r = circle_r, $fn=fn);

            // Top panel support
            rounded_cylinder(h=middle_border_depth - top_inner_border_depth,
                r = circle_r - circle_border, fn=fn);

            // Center hole for Top panel support
            translate([0,0,middle_border_depth - top_inner_border_depth])
                cylinder(h = top_inner_border_depth + 1,
                    r = circle_r - circle_border, $fn=fn);

            // Upper hole
            translate([0,0,0])
                cylinder(h = middle_border_depth + 1,
                    r = circle_r - circle_border - 2, $fn=fn);

            translate([0,0,cut_y]) {
                // Border hole for USB-A * 4 + LAN
                linear_extrude(height=middle_border_depth)
                    arc(circle_r - circle_border-2,
                        [90 - 35, 90 + 35], circle_border + 3, fn=fn);

                // Border hole for USB-C + HDMI
                linear_extrude(height=middle_border_depth)
                    arc(circle_r - circle_border-2,
                        [300, 360], circle_border + 3, fn=fn);
            }
        }
}

// -------------------------

module rpiPanel() {
    color([.5,.5,.5,.8])
        middle_panel();

    translate([rpi_x, rpi_y, middle_panel_depth]) color([.5,.5,.5,1]) {
        rpi_screw(screwHoleHeight);

        if (WITH_BOARD) {
            translate([0, 0, screwHoleHeight]) color([.5,.5,.5,1])
            board_raspberrypi_4_model_b();
        }
    }
}

module caseBottom() {
    bottom_base_panel();

    translate([0,0,bottom_base_depth]) {
        translate([spk_x, spk_y, 0]) {
            spk_screw(screwHoleHeight);

            if (WITH_BOARD) {
                translate([0, 0, screwHoleHeight]) color([.6,.5,.5,1])
                    cube([spk_w,spk_h,spk_d]);
            }
        }

        middle_panel_support();
    }

    if (WITH_RPI_PANEL) {
        translate([0,0,middle_panel_z])
            rpiPanel();
    }

    if (WITH_TOP_PANEL)
        translate([0,0,depth]) color([.5,.3,.7,.5])
            caseTop();

}

module caseTop() {
    margin = 0.2;
    r = circle_r - circle_border - margin;
    hole_pos = circle_r/3 * 2;

    // Inner border
    translate([0,0,-top_base_depth - top_inner_border_depth])
        difference() {
            cylinder(h = top_inner_border_depth, r = r, $fn=fn);
            cylinder(h = top_inner_border_depth, r = r - circle_border, $fn=fn);

            linear_extrude(height=top_inner_border_depth - top_border_lan_corner_depth)
                arc(r - circle_border, [55, 125], circle_border + margin, fn=fn);
        }

    // Top plate
    translate([0,0, -top_base_depth])
        difference() {
            cylinder(h = top_base_depth, r = circle_r, $fn=fn);

            translate([hole_pos,0,0])
                cylinder(r=1, h=top_base_depth, $fn=fn);
            translate([-hole_pos,0,0])
                cylinder(r=1, h=top_base_depth, $fn=fn);
            translate([0,hole_pos,0])
                cylinder(r=1, h=top_base_depth, $fn=fn);
            translate([0,-hole_pos,0])
                cylinder(r=1, h=top_base_depth, $fn=fn);
        }

    // Outside border - Border hole for USB-C + HDMI
    translate([0,0,-top_base_depth - top_border_power_corner_depth])
        linear_extrude(height=top_border_power_corner_depth)
            arc(circle_r - circle_border,
                [300 + margin, 360 - margin], circle_border , fn=fn);

    // Outside border - Border hole for USB-A * 4 + LAN
    translate([0,0,-top_base_depth - top_border_lan_corner_depth])
        linear_extrude(height=top_border_lan_corner_depth)
            arc(circle_r - circle_border - margin,
                [55 + margin, 125 - margin], circle_border + margin, fn=fn);
}

WITH_BOARD = 1;

USE_BOTTOM = 1;
WITH_BOTTOM_HOLE = 0;
WITH_RPI_PANEL = 1;
WITH_TOP_PANEL = 1;

USE_RPI_PANEL = 0;
USE_TOP = 1;

if (USE_BOTTOM)
    translate([0,0,0])
        caseBottom();

if (USE_RPI_PANEL)
    translate([140,0,0])
        rpiPanel();

if (USE_TOP)
    translate([0,140,0]) rotate([0,180,0])
        caseTop();
