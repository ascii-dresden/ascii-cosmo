// a lib to create lego compatibile gears. Requires gears library - // https://github.com/chrisspen/gears which does the heavy lifting.

// modules:

// lego_gear(s, flat_surface=true, central_axle=true, solid=false, stud_hole_tolerance=0.00, axle_hole_tolerance=0.05)

// parameters:
// s - size in lego brick length. Spurs count is s*16.
// standard sizes are 0.5 (8 spurs), 1 (16 spurs), 1.5 (24 spurs), 2.5 (40 spurs). Other down to 0.0625 (1 spur) are possible. There is no restriction on that parameter. Be wise. 8 spur gear is the minimum for the axle hole to make sense. Smaller are possible - not sure if usable though.
// flat surface - if set to true will create big flat space on both sides of the gear so it prints better - there will be less support required.
// central axle - create a hole for the central axle. If set to false there will be none so you can create a custom one - to interface with non-lego stuff
// solid - if set to true - create no additional spur or axle holes off the center. Implies "flat_surface".
// stud_hole_tolerance - offset from 4.8/6.2mm standard. Positive values give bigger holes.
// axle_hole_tolerance - offset from 4.8 standard. Default is 0.05 (4.75mm). Positive values give bigger holes.


// lego_axle(m=1, hole=false, tolerance=0.05)

// m - size in lego bricks (8mm) total length will be m*8-0.15mm
// hole - make the axle to be used to make holes in other objects with it. Basically tolerance make the axle bigger if set to true. If set to flase the tolerance makes the axle smaller
// tolerance - offset to apply to cross section dimension. Default is 0.05 giving 4.75 mm axles and 4.85mm holes


// non-lego:
// rounded_square(size, r=0.2)

// size - like for the square module
// r - radius of the rounding circle


// example:
// for (s = [0.5:1:2.5]) translate([s*s*8,0,0]) rotate([0,0,22.5*(s-0.5)]) lego_gear(s);
// for (s = [1:1:2]) translate([-s*s*8-2,0,0]) rotate([0,0,22.5*s/2]) lego_gear(s, flat_surface=false);

use <gears.scad>; // https://github.com/chrisspen/gears
$fn=48;

module rounded_square(size, r=0.2) {
    $fn=24;
    if (is_num(size))
        translate([r, r, 0])
            minkowski() {
                circle(r);
                square([size-(2*r), size-(2*r)]);
        };
    if (is_list(size))
        translate([r, r, 0])
            minkowski() {
                circle(r);
                square([size[0]-(2*r), size[1]-(2*r)]);
        };
    }

module lego_axle(m=1, hole=false, tolerance=0.05) {
    module 2d_axle() {
        difference() {
            circle((4.8)/2);
            translate([.9, .9, 0]) rounded_square(4);
            translate([-4.9, .9, 0]) rounded_square(4);
            translate([.9, -4.9, 0]) rounded_square(4);
            translate([-4.9, -4.9, 0]) rounded_square(4);
        }
    }
        linear_extrude(m*8-0.15)
            if (hole) offset(r=tolerance) 2d_axle();
            else offset(r=-tolerance) 2d_axle();
        }

module lego_gear(s, flat_surface=true, central_axle=true, solid=false, stud_hole_tolerance=0.00, axle_hole_tolerance=0.05) {
    echo("Spurs", 16*s);
    difference() {
        // bumps
        union () {
            translate([0,0, 1.93]) spur_gear(1, 16*s, 4, 0, pressure_angle=20, helix_angle=0, optimized=false);
            if (flat_surface || solid) cylinder(7.75, d=s*16-2.15);
            else {
                // around studs
                for (x = [round(-s)+0.5:1:round(s)-0.5]) {
                    for (y = [round(-s)+0.5:1:round(s)-0.5]){
                        if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2) {
                            translate([x*8, y*8, 0]) cylinder(7.75, d=7.6);
                            }
                        }
                    }
                // around axles
                for (x = [round(-s)+1:1:round(s)-1]) {
                    for (y = [round(-s)+1:1:round(s)-1]){
                        if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2) {
                            translate([x*8, y*8, 0]) cylinder(7.75, d=5.85);
                            }
                        }
                    }
                }

            }
        if (central_axle) translate([0,0,-1])lego_axle(2, hole=true, tolerance=axle_hole_tolerance);
        if (!solid) {
            // stud holes
            for (x = [round(-s)+0.5:1:round(s)-0.5]) {
                for (y = [round(-s)+0.5:1:round(s)-0.5]) {
                    if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2) {
                        translate([x*8, y*8, -1]) cylinder(10, d=4.8 + stud_hole_tolerance);
                        translate([x*8, y*8, 6.95]) cylinder(10, d=6.2 + stud_hole_tolerance);
                        translate([x*8, y*8, -9.2]) cylinder(10, d=6.2 + stud_hole_tolerance);
                        }
                    }
                }
            // axle holes
            for (x = [round(-s)+1:1:round(s)-1]) {
                for (y = [round(-s)+1:1:round(s)-1]){
                    if (sqrt(pow(x*8,2)+pow(y*8,2))+3.8<=(s*16-3.15)/2){
                        if  ((x!=0) || (y!=0)) translate([x*8, y*8, -1]) lego_axle(2, hole=true, tolerance=axle_hole_tolerance);
                        if ((s>=1) && ((x!=0) || (y!=0) || central_axle)) {
                            if ((x+y)%2==0) translate([x*8-4,y*8-0.4,-1]) cube([8,0.8,10]);
                            else translate([x*8-0.4,y*8-4,-1]) cube([0.8,8,10]);
                            }
                        }
                    }
                }
            }
        }
    }
