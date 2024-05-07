/****************************************************************************
 * GoPro magnetic mount                                                     *
 * Copyright (c) Michal A. Valasek, 2022                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

/* [Magnet] */
magnet_diameter = 20.5;
magnet_distance_from_side = 5;
magnet_height = 5;
magnet_sides = 64;

/* [Base] */
base_size = [70, 40];
base_radius = 10;
base_bottom = .6;
base_top = 1;

/* [Hidden] */
base_height = base_bottom + magnet_height + base_top;
$fn = 64;

difference() {
    // Base
    union() {
        linear_extrude(height = base_height) r_square(base_size, base_radius, center = true);
        // cylinder(d = base_diameter, h = base_height);
        gopro_mount_f(base_height = base_height, center = true);
    }

    // Magnet hole
    magnet_offset = (base_size[0] - magnet_diameter) / 2 - magnet_distance_from_side;
    translate([+magnet_offset, 0, base_bottom]) cylinder(d = magnet_diameter, h = magnet_height);
    translate([-magnet_offset, 0, base_bottom]) cylinder(d = magnet_diameter, h = magnet_height);
}
