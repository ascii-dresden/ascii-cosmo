include <BOSL2/std.scad>
include <gears/lego_gears.scad>
include <geneva_drive.scad>

prism_radius = 40;
prism_height = 8 * 31;
prism_axle_offset = 8 * 2;
prism_size = 1.99;

angle = 16.785;

prism_factor = (20 / (prism_size * prism_radius * sin(angle))) * prism_size;

prism_edge_inner = prism_radius * prism_factor;
prism_edge_outer = prism_radius * prism_size;
prism_edge_height = (prism_size - prism_factor) * prism_radius * sin(angle);
prism_edge_offset = prism_factor * prism_radius * sin(angle);

echo(prism_height=prism_height);
echo(prism_edge_outer=prism_edge_outer);

c_prism_r = "#E60000";
c_prism_y = "#E6E600";
c_prism_g = "#00B300";
c_sign = "#000000";

c_outer_part = "#623412";
c_inner_part = "#dddddd";
c_axle = "#555555";

ENABLE_INNER = false;
ENABLE_ZIPPER = false;
ENABLE_SIGN_INSET = false;
ENABLE_SIGN = true;
ENABLE_GEARS = false;

module outer_part_1() {
    offset = 5.1;
    rotate([90,0,0]) difference() {
        cylinder(h = 12, r = 3.8);
        down(0.1) lego_axle(m=3, hole=true);
        translate([offset, offset, -1]) cylinder(h = 14, r = 3.8);
        translate([-offset, offset, -1]) cylinder(h = 14, r = 3.8);
        translate([offset, -offset, -1]) cylinder(h = 14, r = 3.8);
        translate([-offset, -offset, -1]) cylinder(h = 14, r = 3.8);
    };
}

module outer_part() {
    color(c_outer_part) render() difference() {
        union() {
            rotate([0,0,90])  outer_part_1();
            rotate([0,0,210])  outer_part_1();
            rotate([0,0,330])  outer_part_1();
            down(4) cylinder(h = 8, r = 3.8);
        };

        down(5) cylinder(h = 10, r = 2.5);
    }
}

module inner_part() {
    color(c_inner_part) render() difference() {
        union() {
            rotate([0,0,90]) rotate([90,0,0]) lego_axle(m=1.5);
            rotate([0,0,90]) rotate([90,0,0]) cylinder(h = 4, r = 3.8);
            rotate([0,0,210]) rotate([90,0,0]) lego_axle(m=1.5);
            rotate([0,0,210]) rotate([90,0,0]) cylinder(h = 4, r = 3.8);
            rotate([0,0,330]) rotate([90,0,0]) lego_axle(m=1.5);
            rotate([0,0,330]) rotate([90,0,0]) cylinder(h = 4, r = 3.8);
            down(4) cylinder(h = 8, r = 3.8);
        };

        down(5) lego_axle(m=2);
    }
}

module cross_part() {
    inner_part();

    rotate([0, 0, 0]) translate([16,0,0]) rotate([0, 0, 60])  outer_part();
    rotate([0, 0, 120]) translate([16,0,0]) rotate([0, 0, 60])  outer_part();
    rotate([0, 0, 240]) translate([16,0,0]) rotate([0, 0, 60])  outer_part();
}

module sign(c) {
    if (c == c_prism_r) {
        import("panel-closed.svg", center=true);
    }

    if (c == c_prism_y) {
        right(43.8) import("panel-middle.svg", center=true);
    }

    if (c == c_prism_g) {
        fwd(0.8) right(20.3) import("panel-opened.svg", center=true);
    }
}

module sign_offset(c, row, col) {
    scale = 0.72;

    offset_x = col * -prism_edge_outer;
    offset_y = (row + 0.5) * -prism_height + prism_height / 2;

    translate([offset_x, 0, offset_y])  translate([0, prism_edge_offset + prism_edge_height - 0.05, 0]) rotate([90, 0, 0]) scale([-scale, scale, -scale]) linear_extrude(height=prism_edge_height * 2 * 3) sign(c);
}

module prism_side(c, row, col) {
    prism_side_clearance = 0.1;
    axle_offset = (prism_height / 2) - 4 - prism_axle_offset;
    scale = 0.09;

    if (ENABLE_SIGN_INSET) {
        color(c) render() difference() {
            up(-prism_height / 2) linear_extrude(height=prism_height)
                translate([0, prism_edge_offset + prism_edge_height / 2, 0])
                trapezoid(h=prism_edge_height,w1=prism_edge_inner - prism_side_clearance, w2=prism_edge_outer - prism_side_clearance);

            sign_offset(c, row, col);
        };
    } else {
        color(c) up(-prism_height / 2) linear_extrude(height=prism_height)
            translate([0, prism_edge_offset + prism_edge_height / 2, 0])
            trapezoid(h=prism_edge_height,w1=prism_edge_inner - prism_side_clearance, w2=prism_edge_outer - prism_side_clearance);
    }

    if (ENABLE_SIGN) {
        color(c_sign) back(1) render() intersection() {
            up(-prism_height / 2) linear_extrude(height=prism_height)
                    translate([0, prism_edge_offset + prism_edge_height / 2, 0])
                    trapezoid(h=prism_edge_height, w1=prism_edge_inner - prism_side_clearance, w2=prism_edge_outer - prism_side_clearance);

            sign_offset(c, row, col);
        };
    }

    color(c) rotate([90,0,0]) translate([14, axle_offset, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);
    color(c) rotate([90,0,0]) translate([-14, axle_offset, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);

    color(c) rotate([90,0,0]) translate([-14, 0, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);
    color(c) rotate([90,0,0]) translate([14, 0, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);

    color(c) rotate([90,0,0]) translate([-14, -axle_offset, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);
    color(c) rotate([90,0,0]) translate([14, -axle_offset, -prism_edge_offset]) lego_axle(m=0.7, tolerance=0.04);
}


module tooth(c, heigth, width, offset) {
    cube_size = 8;
    default_factor = prism_edge_height / cube_size / 2 * heigth;
    factor = default_factor * (1 - offset);

    factor_offset = cube_size * (default_factor - factor);

    color(c) translate([0, prism_edge_offset+ prism_edge_height / 2 - factor_offset, prism_height / 2]) scale([1 * width, factor, 1]) translate([0, -cube_size / 2, 0]) cube(cube_size, center=true);
}

module prism_side_with_zipper(c, row, col, top_zipper, botton_zipper) {
    offset_width = 0.005;
    offset_depth = 0.02;
    offset_height = 0.02;

    if (ENABLE_ZIPPER) {
        difference() {
            union() {
                difference() {
                    prism_side(c, row, col);

                    if (top_zipper) {
                        translate([0, prism_edge_offset+ prism_edge_height / 2, prism_height / 2]) cube([prism_edge_outer * 1.1, prism_edge_height * 1.5, offset_height * 2], center=true);
                    }
                    if (botton_zipper) {
                        translate([0, -prism_edge_offset - prism_edge_height / 2, prism_height / 2]) cube([prism_edge_outer * 1.1, prism_edge_height * 1.5, offset_height * 2], center=true);
                    }
                }

                if (top_zipper) {
                    translate([4, 0, -offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([-12, 0, -offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([20, 0, -offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([-28, 0, -offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                }

                if (botton_zipper) {
                    translate([-4, 0, -prism_height + offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([12, 0, -prism_height + offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([-20, 0, -prism_height + offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                    translate([28, 0, -prism_height + offset_height]) tooth(c, 1, 1 - offset_width, offset_depth);
                }
            }

            if (top_zipper) {
                translate([-4, 0, 0]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([12, 0, 0]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([-20, 0, 0]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([28, 0, 0]) tooth(c, 1.2, 1 + offset_width, 0);
            }

            if (botton_zipper) {
                translate([4, 0, -prism_height]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([-12, 0, -prism_height]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([20, 0, -prism_height]) tooth(c, 1.2, 1 + offset_width, 0);
                translate([-28, 0, -prism_height]) tooth(c, 1.2, 1 + offset_width, 0);
            }
        }
    } else {
        prism_side(c, row, col);
    }
}

module prism_raw(row, col, top_zipper, botton_zipper) {
    rotate([0,0,90]) prism_side_with_zipper(c_prism_r, row, col, top_zipper, botton_zipper);
    rotate([0,0,210]) prism_side_with_zipper(c_prism_y, row, col, top_zipper, botton_zipper);
    rotate([0,0,330]) prism_side_with_zipper(c_prism_g, row, col, top_zipper, botton_zipper);

    if (ENABLE_INNER) {
        union() {
            up (16) cross_part();
            up (-16) cross_part();
        }
        down(prism_height / 2 + 24) color(c_axle) lego_axle(m=14);
    }
}

module prism(row, col) {
    if (row == 0) {
        prism_raw(row, col, true, false);
    } else {
        up(prism_height) prism_raw(row, col, false, true);
    }
}

// rot = $t * 2160;

rot = 2 * 720;
// rot = 1 * 720;
// rot = 2 * 720;

module geneva() {
    color("#ff8888") rotate([0, 0, rot])
        drive_wheel_with_axle();
    color("#33ff33") left(center_distance)
        rotate([0, 0, -geneva_rotate(rot)])
        driven_wheel_with_axle();
}

module column(col) {
    offset=2*col;

    for ( row = [0:1:0]) back(offset * prism_radius)
        rotate([0, 0, -geneva_rotate(rot)])
        prism(row, col);

    if (ENABLE_GEARS) {
        back(offset * prism_radius) down(prism_height / 2 + 24) back(center_distance) rotate([0,0,90]) geneva();
    }
}

// for ( col = [-2:1:2]) column(col);

// prism(0, 0);

// $fn = 360;
// prism_side_with_zipper(c_prism_g, 0, -2, false, false);
// up(prism_height) prism_side_with_zipper(c_prism_g, 1, 0, false, true);

// for ( col = [-2:1:2])
//     up(prism_height)
//     right(2 * col * prism_radius)
//     prism_side_with_zipper(c_prism_r, 0, col, false, false);

// for ( col = [-2:1:2])
//     right(2 * col * prism_radius)
//     prism_side_with_zipper(c_prism_y, 0, col, false, false);

// for ( col = [-2:1:2])
//     down(prism_height)
//     right(2 * col * prism_radius)
//     prism_side_with_zipper(c_prism_g, 0, col, false, false);

// $vpt = [0, 0, 0];
// $vpr = [90, 0, 180];
// $vpd = 1800;
