// https://stackoverflow.com/questions/33146741/way-to-round-edges-of-objects-openscad/33289349#33289349
module roundedCube(xx, yy, height, radius) {
    difference() {
        cube([xx,yy,height]);

        difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([xx,0,0]) rotate(90) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([xx,yy,0]) rotate(180) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([0,yy,0]) rotate(270) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }
    }
}

// https://danielupshaw.com/openscad-rounded-corners/
module roundedCube2(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate =
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}