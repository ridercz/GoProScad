/****************************************************************************
 * Universal parametric holder for cell phones                              *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad

/* [Phone size] */
phone_width = 79; // [50:150]
phone_depth = 9; // [5:20]
// set to true for phones with round sides 
use_radius = true;

/* [Holder options] */
holder_depth = 20; // [15:30]
holder_grip = 0; // [0:10]
holder_extra_length = 2; // [0:200]

/* [Signature] */
sig_text = "RIDER.CZ 2021";
sig_size = 6;
sig_extr = 1;

/* [Hidden] */
holder_height = 9.5; // defined by width of GoPro mount
holder_wall = (holder_depth - phone_depth) / 2;
holder_width = phone_width + 2 * holder_wall;
$fudge = 1;
$fn = 32;

// Phone holder
difference() {
    linear_extrude(holder_height) difference() {
        // Outer shape
        hull() {
            translate([-holder_depth / 2, 0]) square([holder_depth, $fudge]);
            radius_offset = holder_depth / 2 - holder_wall;
            translate([+radius_offset, holder_width - holder_wall]) circle(r = holder_wall);
            translate([-radius_offset, holder_width - holder_wall]) circle(r = holder_wall);
        }

        // Phone hole
        if(use_radius) {
            // Round hole
            hull() {
                translate([0, holder_wall + phone_depth / 2]) circle(d = phone_depth);
                translate([0, holder_width - holder_wall - phone_depth / 2]) circle(d = phone_depth);
            }
        } else {
            // Square hole
            translate([-phone_depth / 2, phone_depth / 2]) square([phone_depth, phone_width]);
        }
        translate([0, holder_wall + phone_depth / 2 + holder_grip]) square([holder_depth, phone_width - phone_depth - 2 * holder_grip]);
    }

    // Signature
    if(sig_text != "") translate([-holder_depth / 2 + sig_extr, holder_width / 2 - holder_depth / 4, holder_height / 2]) rotate([90, 0, -90]) linear_extrude(sig_extr + $fudge) text(text = sig_text, font = "Arial:bold", size = sig_size, halign = "center", valign = "center");
}

// Extra arm
if(holder_extra_length > 0) translate([-holder_depth / 2, -holder_extra_length]) linear_extrude(holder_height) {
    square([holder_depth, holder_extra_length], 3);
}

// GoPro mount
translate([0, -holder_extra_length]) rotate([90, 0, 0]) gopro_mount_m(base_height = $fudge, base_width = holder_depth);