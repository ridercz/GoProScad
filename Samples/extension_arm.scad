/****************************************************************************
 * GoPro mount extension arm                                                *
 * Copyright (c) Michal A. Valasek, 2021                                    *
 * ------------------------------------------------------------------------ *
 * www.rider.cz | www.altair.blog | github.com/ridercz/GoProScad            *
 ****************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad

length = 250;

/* [Hidden] */
$fudge = 1;

mounts();
hull() intersection() {
    // This is kind of ugly hack and does not help performance very much.
    // But this is simple model, so screw performance :)
    mounts();
    rotate([0, 90, 0]) linear_extrude(length) square(30, center = true);
}

module mounts() {
    translate([$fudge, 0, 0]) rotate([0, -90, 0]) gopro_mount_m($fudge = $fudge, center = true);
    translate([length - $fudge, 0]) rotate([0, +90, 0]) gopro_mount_f($fudge = $fudge, center = true);
}
