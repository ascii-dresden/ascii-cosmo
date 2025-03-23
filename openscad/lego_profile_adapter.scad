include <BOSL2/std.scad>

left(20) difference() {
    linear_extrude(height = 16, center=true) union() {
        back(2) polygon([[-6,0], [-6,1], [-3,4], [3,4], [6,1], [6,0]]);
        back(1) square([6, 6], center=true);
        left(8) fwd(8) square([16, 8]);
    };

    left(4) down(4.5) fwd(8)
        rotate([90, 0, 0]) linear_extrude(height = 1, center=true) text("1");
}

difference() {
    linear_extrude(height = 16, center=true) union() {
        back(2.1) polygon([[-5.9,0], [-5.9,0.9], [-2.9,3.9], [2.9,3.9], [5.9,0.9], [5.9,0]]);
        back(1) square([5.9, 6], center=true);
        left(8) fwd(8) square([16, 8]);
    };

    left(4) down(4.5) fwd(8)
        rotate([90, 0, 0]) linear_extrude(height = 1, center=true) text("2");
}

right(20) difference() {
    linear_extrude(height = 16, center=true) union() {
        back(2.2) polygon([[-5.8,0], [-5.8,0.8], [-2.8,3.8], [2.8,3.8], [5.8,0.8], [5.8,0]]);
        back(1) square([5.8, 6], center=true);
        left(8) fwd(8) square([16, 8]);
    };

    left(4) down(4.5) fwd(8)
        rotate([90, 0, 0]) linear_extrude(height = 1, center=true) text("3");
}