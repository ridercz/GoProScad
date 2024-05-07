/****************************************************************************
 * Microphone boom screw (3/8", 5/8") top GoPro mount adaptor               *
 * Copyright (c) Michal A. Valasek, 2024                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

/* [Mounting screw] */
screw_hole = 15.5; // [16:5/8 in, 9.5:3/8 in]
screw_depth = 10;

/* [Construction] */
outer_diameter = 22;
wall = 3;

/* [Hidden] */
$fudge = 1;
$fn = 32;

difference() {
    hull() {
        cylinder(d = outer_diameter, h = screw_depth + wall, $fn = 8);
        translate(v = [-outer_diameter / 2, -outer_diameter / 2, screw_depth]) cube([outer_diameter, outer_diameter, wall]);
    }
    translate(v = [0, 0, -$fudge]) cylinder(d = screw_hole, h = screw_depth + $fudge);
}
translate(v = [0, 0, screw_depth]) gopro_mount_f(base_width = outer_diameter, base_height = wall, center = true);
