include <BOSL2/std.scad>
include <gears/lego_gears.scad>

use <geneva_drive.scad>

$radius = 2.5;

module top_plate() {
    cube([8,96,8]);
    right(64) cube([8,96,8]);

    cube([72,8,8]);
    back(88) cube([72,8,8]);

    right(32) cube([8,96,8]);
    back(24) cube([72,8,8]);
    back(56) cube([72,8,8]);
}

module top_holes() {
    right(32) back(24) cylinder(12, r=$radius);
    right(32) back(56) cylinder(12, r=$radius);

    right(8) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(24) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(8) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(24) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    back(24) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    back(56) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);


    right(56) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(40) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(56) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(40) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(64) back(24) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    right(64) back(56) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
}

module top() {
    up(32) difference() {
        top_plate();
        down(2) right(4) back(4) top_holes();
    }
}

module bottom_plate() {
    cube([8,96,8]);
    right(64) cube([8,96,8]);

    cube([72,8,8]);
    back(88) cube([72,8,8]);

    right(32) cube([8,96,8]);
    back(24) cube([72,8,8]);
    back(56) cube([72,8,8]);
}

module bottom_holes() {
    $radius = 2.5;

    right(32) back(24) cylinder(12, r=$radius);
    right(32) back(56) cylinder(12, r=$radius);

    right(8) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(24) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(8) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(24) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    back(24) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    back(56) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);


    right(56) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(40) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(56) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(40) back(88) lego_axle(m=1.5, hole=true, tolerance=0.18);
    right(64) back(24) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    right(64) back(56) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
}

module bottom_stopper() {
    right(16) back(24) down(16) cube([16,8,24]);
    right(40) back(24) down(16) cube([16,8,24]);
    right(16) back(24) down(16) cube([40,8,8]);
}

module bottom_gearbox() {
    right(16) back(56) down(16) cube([8,8,24]);
    right(48) back(56) down(16) cube([8,8,24]);
    right(16) back(56) down(16) cube([40,8,8]);


    back(40) cube([72,8,8]);

    right(16) back(40) down(12) cube([8,24,20]);
    right(48) back(40) down(12) cube([8,24,20]);
}

module bottom_gearbox_holes() {
   right(16) back(48) rotate([0, 90, 0]) cylinder(h = 12, r = $radius);
   right(48) back(48) rotate([0, 90, 0]) cylinder(h = 12, r = $radius);
   right(26) back(48) rotate([0, 90, 0]) cylinder(h = 24, r = 7);

    down(14) right(38) back(56) cylinder(12, r=$radius);
    down(13) right(38) back(56) cylinder(2, r=3.5);
}

module bottom() {
    difference() {
        union() {
            bottom_plate();

            bottom_stopper();
            bottom_gearbox();
        }

        down(2) right(4) back(4) bottom_holes();
        down(4) left(2) back(4) bottom_gearbox_holes();
    }
    

}

module vertical() {
    right(0) back(0) cube([8,8,40]);
    right(64) back(0) cube([8,8,40]);
    right(0) back(88) cube([8,8,40]);
    right(64) back(88) cube([8,8,40]);
}

module hole_test() {
    difference() {
        left(8) cube([88, 8, 8],center=true);
        left(48) down(6) cylinder(h = 12, r = 2.2);
        left(40) down(6) cylinder(h = 12, r = 2.25);
        left(32) down(6) cylinder(h = 12, r = 2.3);
        left(24) down(6) cylinder(h = 12, r = 2.35);
        left(16) down(6) cylinder(h = 12, r = 2.4);
        left(8) down(6) cylinder(h = 12, r = 2.45);
        down(6) cylinder(h = 12, r = 2.5);
        right(8) down(6) cylinder(h = 12, r = 2.55);
        right(16) down(6) cylinder(h = 12, r = 2.6);
        right(24) down(6) cylinder(h = 12, r = 2.65);
        right(32) down(6) cylinder(h = 12, r = 2.7);
    }
}

$fn = 360;
// top();
// vertical();
// bottom();

hole_test();

// up(12) right(32) back(56) right(4) back(4)rotate([0, 0, 90]) sample();