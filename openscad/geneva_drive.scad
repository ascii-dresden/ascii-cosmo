include <BOSL2/std.scad>
include <gears/lego_gears.scad>

driven_slot_quantity = 6;
target_center_distance = 4 * 8;
drive_pin_diameter = 3.05;

allowed_clearance = 0.2;
rotational_clearance = 0.6;
slot_rounding_radius = 3;
slot_rounding_offset = 0.2;

drive_crank_radius = target_center_distance * sin(180 / driven_slot_quantity);

center_distance = drive_crank_radius / sin(180 / driven_slot_quantity);
driven_wheel_radius = sqrt((center_distance * center_distance) - (drive_crank_radius * drive_crank_radius));

slot_center_length = (drive_crank_radius + driven_wheel_radius) - center_distance;

stop_arc_radius = drive_crank_radius - ( drive_pin_diameter * 1.5 );
stop_disk_radius = stop_arc_radius - allowed_clearance;

// echo(center_distance=center_distance);
// echo(driven_wheel_radius=driven_wheel_radius);
// echo(drive_pin_diameter=drive_pin_diameter);
// echo(slot_center_length=slot_center_length);
// echo(stop_arc_radius=stop_arc_radius);
// echo(stop_disk_radius=stop_disk_radius);

module drive_wheel() {
    difference() {
        cylinder(h = 16 - allowed_clearance, r = stop_disk_radius - allowed_clearance / 2);

        right(center_distance) up(-0.5) cylinder(h = 17, r = driven_wheel_radius);
    };

    // right(drive_crank_radius) cylinder(h = 16, r = drive_pin_diameter / 2 - allowed_clearance);

    difference() {
        cylinder(h = 8 - allowed_clearance, r = drive_crank_radius + drive_pin_diameter / 2 + 4);

        right(drive_crank_radius) down(0.5)
            cylinder(h = 16, r = drive_pin_diameter / 2 + 0.06);
    };
}

module driven_wheel() {
    offset = 180 / driven_slot_quantity;
    pin_with_clearance = drive_pin_diameter + 0.05;

    up(8) difference() {
        cylinder(h = 8, r = driven_wheel_radius - allowed_clearance - rotational_clearance);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0,0,r + offset])
            right(driven_wheel_radius - slot_center_length / 2) up(4)
            rotate([0,90,0]) linear_extrude(height = slot_center_length, scale=1.0, center = true) square(size = [9, pin_with_clearance], center = true);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0,0,r + offset])
            right(driven_wheel_radius - slot_center_length) up(-0.5)
            cylinder(h = 9, r = pin_with_clearance / 2);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0, 0, r + offset])
            rotate([0,0,360 / driven_slot_quantity / 2])
            right(center_distance)  up(-0.5)
            cylinder(h = 9, r = stop_disk_radius);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0,0,r + offset])
            driven_wheel_rounding(pin_with_clearance);
    };

    cylinder(h = 16, r = 5);

    // up(20) right(driven_wheel_radius) cylinder(h = 9, r = drive_pin_diameter);
}

// $fn = 360;

module driven_wheel_rounding(pin_with_clearance) {
    offset_length = driven_wheel_radius - allowed_clearance - rotational_clearance;
    offset_side = pin_with_clearance / 2 + slot_rounding_radius / 2;

    angle = atan(offset_side / offset_length);
    offset_height = (1 - cos(angle)) * offset_length;

    right(offset_length - slot_rounding_radius - offset_height - slot_rounding_offset)
        difference() {
            right(slot_rounding_radius) up(4)
                cube([slot_rounding_radius * 2,offset_side * 2 + slot_rounding_radius,9], center=true);

                up(-1) back(offset_side + slot_rounding_radius / 2)
                    cylinder(h = 10, r = slot_rounding_radius);

                up(-1) fwd(offset_side + slot_rounding_radius / 2)
                    cylinder(h = 10, r = slot_rounding_radius);
        };
}

module drive_wheel_with_axle() {
    difference() {
        drive_wheel();

        up(-0.5) lego_axle(m=3, hole=true, tolerance=0.18);
    }
}

module driven_wheel_with_axle() {
    difference() {
        driven_wheel();

        up(-0.5) lego_axle(m=3, hole=true, tolerance=0.18);
    }
}

geneva_rotate_offset_angle = acos(drive_crank_radius / center_distance);
geneva_rotate_start_angle = 180 - geneva_rotate_offset_angle;
geneva_rotate_end_angle = 180 + geneva_rotate_offset_angle;

function geneva_rotate(gamma) =
    let(gamma_1=gamma % 360)
    let(offset_factor=floor(gamma / 360))
    let(a=center_distance)
    let(b=drive_crank_radius)
    offset_factor * (360 / driven_slot_quantity) +
    (gamma_1 < geneva_rotate_start_angle
        ? 0
        : gamma_1 > geneva_rotate_end_angle
            ? 360 / driven_slot_quantity
            : (let(c=sqrt((a*a + b*b) - (2*a*b * cos(gamma_1 - 180))))
                asin(sin(gamma_1 - 180) * b / c)) + (180 / driven_slot_quantity));

module sample() {
    rot = $t * 1080;

    color("#ff8888") rotate([0, 0, rot])  drive_wheel_with_axle();
    color("#33ff33") left(center_distance)
        rotate([0, 0, -geneva_rotate(rot)])
        driven_wheel_with_axle();
}

module print() {
    $fn = 360;
    drive_wheel_with_axle();
    left(drive_crank_radius + driven_wheel_radius + 10) up(16)
        rotate([0, 180, 0])
        driven_wheel_with_axle();
}

sample();
// print();
