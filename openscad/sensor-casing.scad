include <BOSL2/std.scad>
include <gears/lego_gears.scad>
include <roundedcube.scad>

module block() {
    tolerance = 0.1;
    difference() {
        union()  {
            roundedcube_simple([24,8,4], center=true, radius=0.1);
            roundedcube_simple([9, 8, 20], center=true, radius=0.1);
        }

        cube([6.4 + tolerance, 4.9 + tolerance, 24], center=true);
    }
}

module block_with_axle() {
    difference() {
        block();

        left(-8) up(-4.5) lego_axle(m=2, hole=true, tolerance=0.18);
        left(8) up(-4.5) lego_axle(m=2, hole=true, tolerance=0.18);
    }
}

$fn = 360;
block_with_axle();
