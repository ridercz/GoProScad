/**********************************************************************************************************************
 * Horizontal phone boom holder for Vanguard tripod                                                 V2.1 (2024-05-05) *
 * ------------------------------------------------------------------------------------------------------------------ *
 * Copyright (c) Michal Altair Valášek, 2024                                                                          *
 *               www.rider.cz | www.altair.blog                                                                       *
 * ------------------------------------------------------------------------------------------------------------------ *
 * Licensed under terms of the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.       *
 * https://creativecommons.org/licenses/by-nc-sa/4.0/                                                                 *
 *********************************************************************************************************************/

include <../GoPro.scad>;    // https://github.com/ridercz/GoProScad
include <A2D.scad>; // https://github.com/ridercz/A2D
assert(a2d_required([1, 6, 2]), "Please upgrade A2D library to version 1.6.2 or higher.");

/* Customizable parameters *******************************************************************************************/

/* [Phone platform] */
// Phone size [x, y, z], including the case
phone_size = [80, 170, 8];
// Phone corner radius, including the case
phone_corner_radius = 10;
// Platform wall thickness
platform_wall = 3;
// Platform ledge width - the part of the phone that is not covered by the platform
platform_ledge_width = 5;
// Platform base height
platform_base_height = 1;
// Holder height
holder_height = 20;

/* [Spirit level] */
// Spirit level hole diameter; set 0 to disable
spirit_level_diameter = 14;
// Spirit level inner hole diameter; set 0 to disable
spirit_level_inner_diameter = 3;
// Spirit level hole depth; set 0 to disable
spirit_level_height = 8;

/* [Power connector cutout] */
// Cutout width; set 0 to disable
pwr_connector_cutout_size = 10;
// Offset from the center of the platform
pwr_connector_cutout_offset = 0;
// Position of the power connector cutout
pwr_connector_side = -1; // [-1:Left, 1:Right]

/* [Communication connector cutout] */
// Cutout width; set 0 to disable
com_connector_cutout_size = 10;
// Offset from the center of the platform
com_connector_cutout_offset = 20;
// Communication connector cutout position
com_connector_side = -1; // [-1:Left, 1:Right]

/* [Screws] */
// Screw rod diameter
screw_diameter = 10.5;
// Circumscribed diameter of the nut
nut_diameter = 20;
// Number of sides of the nut
nut_sides = 6;
// Nut height
nut_height = 5;

/* [Hidden] */
$fudge = 1;
$fn = 32;
total_platform_width = phone_size.y + 2 * platform_wall;
total_platform_depth = phone_size.x + 2 * platform_wall;
spirit_level_square = max(spirit_level_diameter + 2 * platform_wall, holder_height);

/* Model *************************************************************************************************************/

translate(v = [0, -spirit_level_square + platform_wall, holder_height / 2]) rotate([90, 90, 0]) gopro_mount_m(base_width = holder_height, base_height = platform_wall, center = true);
difference() {
    // Outer shell
    hull() {
        // Phone holder itself
        translate(v = [-phone_size.y / 2 - platform_wall, 0]) linear_extrude(height = phone_size.z + platform_base_height) r_square([total_platform_width, total_platform_depth], radius = phone_corner_radius + platform_wall);
        // Mounting bracket
        translate(v = [-spirit_level_square / 2, -spirit_level_square + platform_wall])  cube([spirit_level_square, spirit_level_square, holder_height]);
    }

    // Phone hole
    translate(v = [-phone_size.y / 2, platform_wall, platform_base_height]) linear_extrude(height = holder_height) r_square([phone_size.y, phone_size.x], radius = phone_corner_radius);

    // Ledge hole
    translate(v = [-phone_size.y / 2 + platform_ledge_width, platform_wall + platform_ledge_width, -$fudge]) linear_extrude(height = holder_height) r_square([phone_size.y - 2 * platform_ledge_width, phone_size.x - 2 * platform_ledge_width], radius = phone_corner_radius);

    // Power connector cutout
    if(pwr_connector_cutout_size > 0) mirror([pwr_connector_side == -1 ? 1 : 0, 0, 0]) translate(v = [0, (total_platform_depth - pwr_connector_cutout_size) / 2 + pwr_connector_cutout_offset, platform_base_height]) cube([total_platform_width, pwr_connector_cutout_size, holder_height]);

    // Communication connector cutout
    if(com_connector_cutout_size > 0) mirror([com_connector_side == -1 ? 1 : 0, 0, 0]) translate(v = [0, (total_platform_depth - com_connector_cutout_size) / 2 + com_connector_cutout_offset, platform_base_height]) cube([total_platform_width, com_connector_cutout_size, holder_height]);

    // Spirit level hole
    if(spirit_level_height > 0 && spirit_level_diameter > 0) {
        translate(v = [0, -spirit_level_diameter / 2, holder_height - spirit_level_height]) cylinder(d = spirit_level_diameter, h = spirit_level_height + $fudge);
        if(spirit_level_inner_diameter > 0) translate(v = [0, -spirit_level_diameter / 2, -$fudge]) cylinder(d = spirit_level_inner_diameter, h = holder_height + 2 * $fudge);
    }

}
