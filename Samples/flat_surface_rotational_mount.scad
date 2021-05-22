/****************************************************************************
 * GoPro rotational mount for flat surfaces                                 *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

/* [General] */
compose = false;

/* [Base] */
base_height = 6;
base_size = 50;
base_radius = 6;
base_circle_height = 10;
base_circle_diameter = 33;
base_circle_lip = 3;

/* [Screws] */
screw_diameter = 3.5;
screw_head_diameter = 7;

/* [Hidden] */
tolerance = .5;
$fn = 64;
$fudge = 1;

if(compose) {
    color("#c00") translate([0, 0, base_height]) mirror([0, 0, 1]) part_base();
    color("#03c") part_mount();
} else {
    translate([-base_size / 2, 0]) part_mount();
    translate([+base_size / 2, 0]) part_base();
}

module part_base() {
    difference() {
        // Basic shape
        linear_extrude(base_height) difference() {
            r_square([base_size, base_size], base_radius, center = true);
            circle(d = base_circle_diameter + tolerance);
        }

        // Lip hole
        translate([0, 0, base_height / 2 - tolerance]) cylinder(d = base_circle_diameter + 2 * base_circle_lip + tolerance, h = base_height);

        // Mount hole
        for(pos = square_points([base_size - base_radius * 2, base_size - base_radius * 2], center = true)) {
            translate([pos[0], pos[1], -$fudge]) cylinder(d = screw_diameter, h = base_height + 2 * $fudge);
            translate([pos[0], pos[1], -base_height / 2]) cylinder(d = screw_head_diameter, h = base_height);
        }
    }
}

module part_mount() {
    // GoPro mount
    gopro_mount_f(base_height = base_circle_height, center = true);

    // Add base circle
    cylinder(d = base_circle_diameter, h = base_circle_height, $fn = 128);

    // Add lip
    cylinder(d = base_circle_diameter + 2 * base_circle_lip, h = base_height / 2, $fn = 128);
}