/****************************************************************************
 * Altair's GoPro mounts library for OpenSCAD   version: 1.2.0 (2021-05-22) *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

// These values are fixed and defined by GoPro mount standard
__gopro_outer_diameter = 15;            // Outer diameter of the legs
__gopro_leg_width = 3;                  // Width of the legs
__gopro_slit_width = 3.5;               // Width of the slits, including tolerance
__gopro_hole_diameter = 5;              // M5
__gopro_hole_tolerance = .5;            // Print tolerance for hole
__gopro_screw_extension_length = 18;    // Length of the part of screw that sticks out
__gopro_screw_head_diameter = 9.5;      // M5
__gopro_screw_hex_head_height = 3.5;    // M5
__gopro_wall_shaft = 1.67;              // Thickness of wall in the narrow part
__gopro_wall_head = 3;                  // Thickness of wall in the wide part
__gopro_knurl_diameter = 4;             // Diameter of knurls
__gopro_knurl_offset = -1;              // Center distance offset of knurls

module gopro_mount_f(base_height = 3, base_width = 24, leg_height = 17, nut_diameter = 11.5, nut_sides = 4, nut_depth = 3, center = false, $fudge = 1) {
    // Check arguments
    assert(base_height > 0, "Parameter base_height must be greater than zero.");
    assert(base_width >= 15, "Parameter base_width must be at least 15.");
    assert(leg_height >= 15, "Parameter leg_height must be at least 15.");
    assert(nut_sides == 4 || nut_sides == 6, "Parameter nut_sides must be either 4 or 6.");

    // Computed values
    hole_offset = leg_height - __gopro_outer_diameter / 2 + base_height;
    base_depth = __gopro_slit_width * 2 + __gopro_leg_width * 3 + nut_depth;
    center_offset_y = __gopro_leg_width * 1.5 + __gopro_slit_width;

    // Model itself
    translate(center ? [0, -center_offset_y] : [0, 0]) difference() {
        // Outer shape
        hull() {
            translate([-base_width / 2, 0]) cube([base_width, base_depth, base_height]);
            translate([0, 0, hole_offset]) rotate([-90, 0, 0]) cylinder(d = __gopro_outer_diameter, h = base_depth, $fn = 64);
        }

        // Leg slits
        for(y_offset = [__gopro_leg_width, 2 * __gopro_leg_width + __gopro_slit_width]) translate([-base_width / 2 - $fudge, y_offset, base_height]) cube([base_width + 2 * $fudge, __gopro_slit_width, leg_height]);

        // Screw + nut hole
        translate([0, -$fudge, hole_offset]) rotate([-90, 0,0]) {
            cylinder(d = __gopro_hole_diameter + __gopro_hole_tolerance, h = base_depth + 2 * $fudge, $fn = 32);
            if(nut_depth > 0) translate([0, 0, base_depth + $fudge - nut_depth]) cylinder(d = nut_diameter, h = nut_depth + $fudge, $fn = nut_sides);
        }
    }
}

module gopro_mount_m(base_height = 3, base_width = 20, leg_height = 17, center = false) {
    assert(base_height > 0, "Parameter base_height must be greater than zero.");
    assert(base_width >= 15, "Parameter base_width must be at least 15.");
    assert(leg_height >= 15, "Parameter leg_height must be at least 15.");

    // Computed values
    base_depth = __gopro_leg_width * 2 + __gopro_slit_width;
    hole_offset = [base_height + leg_height - __gopro_outer_diameter / 2, base_width / 2];

    // Model itself
    translate(center ? [0, -base_depth / 2] : [0, 0]) {
        translate([-base_width / 2, 0]) cube([base_width, __gopro_leg_width * 2 + __gopro_slit_width, base_height]);
        translate([0, __gopro_leg_width + __gopro_slit_width / 2]) rotate(90) translate([base_depth / 2, -hole_offset[1]]) rotate([0, -90, 0]) for(z_offset = [0, __gopro_leg_width + __gopro_slit_width]) translate([0, 0, z_offset]) linear_extrude(__gopro_leg_width) difference() {
            hull() {
                square([base_height, base_width]);
                translate(hole_offset) circle(d = __gopro_outer_diameter, $fn = 64);
            }
            translate(hole_offset) circle(d = __gopro_hole_diameter + __gopro_hole_tolerance, $fn = 32);
        }
    }
}

module gopro_screw_handle(screw_length = 50, total_length = 0, hex_head = true, $fudge = 1) {
    assert(screw_length > __gopro_screw_extension_length + 3, "Parameter screw_length is too short.");

    // Computed values
    screw_inner_length = screw_length - __gopro_screw_extension_length;
    screw_hole_diameter = __gopro_hole_diameter + (hex_head ? __gopro_hole_tolerance : 0);
    real_total_length = total_length > 0 ? total_length : screw_inner_length + 3 * __gopro_screw_hex_head_height;
    handle_length = real_total_length - screw_inner_length;

    difference() {
        union() {
            // Base shape
            hull() {
                cylinder(d = screw_hole_diameter + 2 * __gopro_wall_shaft, h = real_total_length, $fn = 32);
                cylinder(d = __gopro_screw_head_diameter + 2 * __gopro_wall_head, h = handle_length, $fn = 6);
            }

            // Knurls
            for(a = [0 : 60 : 359]) rotate(a) translate([__gopro_screw_head_diameter / 2 + __gopro_wall_head + __gopro_knurl_offset, 0]) {
                cylinder(d = __gopro_knurl_diameter, h = handle_length * .75, $fn = 24);
                translate([0, 0, handle_length * .75]) cylinder(d1 = __gopro_knurl_diameter, d2 = 0, h = handle_length * .25, $fn = 16);
            }
        }

        // Screw hole
        translate([0, 0, -$fudge]) cylinder(d = screw_hole_diameter, h = real_total_length + 2 * $fudge, $fn = 32);
	    translate([0, 0, -$fudge]) cylinder(d = __gopro_screw_head_diameter, h = handle_length + $fudge, $fn = hex_head ? 6 : 32);
    }
}