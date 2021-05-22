/****************************************************************************
 * Universal parametric mount for tripods                                   *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

base_size_bottom = 42;
base_radius_bottom = 5;
base_size_top = 33;
base_radius_top = 3;
base_height = 9.6;

$fn = 32;
$fudge = 1;

difference() {
    union() {
        hull() {
            linear_extrude($fudge) r_square([base_size_bottom, base_size_bottom], base_radius_bottom, center = true);
            translate([0, 0, base_height - $fudge]) linear_extrude($fudge) r_square([base_size_top, base_size_top], base_radius_top, center = true);
        }
        gopro_mount_f(base_height = base_height, base_width = base_size_top, center = true);
    }

    translate([0, 0, $fudge]) rotate([0, 180, 0]) linear_extrude(2 * $fudge) {
        translate([0, +1]) text(text = "RIDER.CZ", font = "Arial:bold", size = 5, halign = "center", valign = "bottom");
        translate([0, -1])text(text = "2021", font = "Arial:bold", size = 5, halign = "center", valign = "top");
    }
}

