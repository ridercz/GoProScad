/****************************************************************************
 * GoPro to cold shoe adapter                                               *
 * Copyright (c) Michal A. Valasek, 2022                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>;         // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

/* [Cold Shoe Options] */
cold_shoe_hole_size = 20;
cold_shoe_hole_height = 3;
cold_shoe_hole_neck_width = 14;
cold_shoe_hole_neck_height = 2;

/* [Holder] */
holder_corner_radius = 3;
holder_padding = 5;
holder_base_height = 3;

/* [Hidden] */
$fn = 16;
holder_size = cold_shoe_hole_size + 2 * holder_padding;
holder_height = holder_base_height + cold_shoe_hole_height + cold_shoe_hole_neck_height;

difference() {
    // Holder outer shape
    linear_extrude(holder_height) r_square([holder_size, holder_size], holder_corner_radius, center = true);
    
    // Neck hole
    translate([-cold_shoe_hole_neck_width / 2, -holder_size / 2 - holder_padding, holder_base_height]) cube([cold_shoe_hole_neck_width, holder_size, holder_height]);

    // Shoe hole
    translate([-cold_shoe_hole_size / 2, -holder_size / 2 - holder_padding, holder_base_height]) cube([cold_shoe_hole_size, holder_size, cold_shoe_hole_height]);
}

translate([0, 0, holder_base_height]) rotate([0, 180, 90]) gopro_mount_m(base_height = holder_base_height, base_width = holder_size, center = true);