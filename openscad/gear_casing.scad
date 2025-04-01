include <BOSL2/std.scad>
include <gears/lego_gears.scad>
include <roundedcube.scad>

use <geneva_drive.scad>

$radius = 2.55;

module top_plate() {
    cube([8,96,8]);
    right(64) cube([8,96,8]);

    cube([72,8,8]);
    back(88) cube([72,8,8]);

    right(32) cube([8,96,8]);
    back(24) cube([72,8,8]);
    back(56) cube([72,8,8]);
}

module profile_adapter() {
    up(3) rotate([0, 90, 180]) linear_extrude(height = 16, center=true) union() {
        back(2) polygon([[-6,0], [-6,1], [-3,4], [3,4], [6,1], [6,0]]);
        back(1) square([6, 6], center=true);
    }
}

module top_profile_adapter() {
    right(8) profile_adapter();
    right(64) profile_adapter();

    back(96) right(8) rotate([0,0,180]) profile_adapter();
    back(96) right(64) rotate([0,0,180]) profile_adapter();
}

module top_holes() {
    right(32) back(24) cylinder(12, r=$radius);
    right(32) back(56) cylinder(12, r=$radius);

    right(8) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(24) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(8) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(24) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    back(24) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    back(56) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);

    right(56) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(40) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(56) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(40) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(64) back(24) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    right(64) back(56) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
}

module top() {
    up(32) difference() {
        union() {
            top_plate();
            top_profile_adapter();
        }
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
    right(32) back(24) cylinder(12, r=$radius);
    right(32) back(56) cylinder(12, r=$radius);

    right(8) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(24) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(8) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(24) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    back(24) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    back(56) left(12) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);


    right(56) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(40) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(56) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(40) back(88) lego_axle(m=1.5, hole=true, tolerance=0.17);
    right(64) back(24) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
    right(64) back(56) left(4) up(6) rotate([0, 90, 0]) lego_axle(m=2, hole=true, tolerance=0.18);
}

module bottom_stopper() {
    right(16) back(24) down(16) cube([14,8,24]);
    right(42) back(24) down(16) cube([14,8,24]);
    right(16) back(24) down(16) cube([40,8,7.9]);
}

module bottom_gearbox() {
    right(16) back(56) down(16) cube([8,8,24]);
    right(48) back(56) down(16) cube([8,8,24]);
    right(16) back(56) down(16) cube([40,8,7.9]);


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

module sensor_casing(height) {
    up(height / 2) right(4.5) back(4) difference() {
        union()  {
            cube([9, 8, height], center=true);
        }

        cube([6.4 + 0.2, 4.9 + 0.15, height * 1.2], center=true);
    }
}

// $fn = 360;
union() {
    difference() {
        union() {
            top();
            vertical();
            bottom();
        }

        union() {
            color("red") up(7.9) right(8) back(8) cube([56,80,8]);
            color("red") up(24.1) right(8) back(8) cube([56,80,8]);
            color("red") left(7.95) fwd(100) down(50) cube([8, 300, 200]);
            color("red") right(71.95) fwd(100) down(50) cube([8, 300, 200]);
        }
    }

    right(40) back(64) sensor_casing(12);
    right(46) back(16) sensor_casing(20);
}
