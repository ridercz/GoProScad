/****************************************************************************
 * Universal parametric mount for M6 screw                                  *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

base_width = 40;
base_depth = 34;
base_height = 6;
base_radius = 3;
screw_hole_offset = 25;
screw_hole_diameter = 6.5;
screw_head_diameter = 11;
screw_head_sides = 6;
screw_head_height = 4;

$fn = 32;
$fudge = 1;

// GoPro mount
translate([7.5, 0]) rotate(180) gopro_mount_f(base_height = base_height, base_width = 15, center = true);

// Base plate
difference() {
     linear_extrude(base_height) translate([0, -base_depth / 2]) r_square([base_width, base_depth], base_radius);
    translate([screw_hole_offset, 0, -$fudge]) cylinder(d = screw_hole_diameter, h = base_height + 2 * $fudge);
    translate([screw_hole_offset, 0, base_height - screw_head_height]) cylinder(d = screw_head_diameter, h = base_height, $fn = screw_head_sides);
}

