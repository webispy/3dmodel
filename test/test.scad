include <../externals/NopSCADlib/core.scad>
include <../externals/NopSCADlib/vitamins/pcbs.scad>

use <../externals/NopSCADlib/utils/layout.scad>

margin = 10;

// RPI3 and RPI4 (rotated)
rotate(90) pcb(RPI3);
translate([pcb_width(RPI3) + margin, 0, 0])
    rotate(90) pcb(RPI4);

// RPI3 and RPI4
translate([0, pcb_length(RPI3) + margin, 0]) {
    pcb(RPI3);
    translate([pcb_length(RPI3) + margin, 0, 0])
        pcb(RPI4);
}
