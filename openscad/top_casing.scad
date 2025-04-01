include <BOSL2/std.scad>
include <gears/lego_gears.scad>
include <roundedcube.scad>

use <geneva_drive.scad>

$radius = 2.55;

module top_plate() {
    cube([72,8,16]);
    back(88) cube([72,8,16]);

    right(32) cube([8,96,16]);
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
    right(32) back(24) cylinder(24, r=$radius);

    right(8) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(24) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(8) back(88) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(24) back(88) lego_axle(m=2.5, hole=true, tolerance=0.17);

    right(56) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(40) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(56) back(88) lego_axle(m=2.5, hole=true, tolerance=0.17);
    right(40) back(88) lego_axle(m=2.5, hole=true, tolerance=0.17);
}


// $fn = 360;
difference() {
    union() {
        top_plate();
        up(5) top_profile_adapter();
    }

    down(2) right(4) back(4) top_holes();

    union() {
        color("red") left(7.95) fwd(100) down(50) cube([8, 300, 200]);
        color("red") right(71.95) fwd(100) down(50) cube([8, 300, 200]);
    }
}
