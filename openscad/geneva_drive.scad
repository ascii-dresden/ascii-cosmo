include <BOSL2/std.scad>
include <gears/lego_gears.scad>

// drive_wheel_radius = 24;

// driven_wheel_radius = 16;
// driven_wheel_shaft_radius = 4;

// helper_radius = drive_wheel_radius + driven_wheel_radius - driven_wheel_shaft_radius;

driven_slot_quantity = 3;
target_center_distance = 72;

drive_pin_diameter = 8;
allowed_clearance = 0.2;

drive_crank_radius = target_center_distance * sin(180 / driven_slot_quantity);

center_distance = drive_crank_radius / sin(180 / driven_slot_quantity);
driven_wheel_radius = sqrt((center_distance * center_distance) - (drive_crank_radius * drive_crank_radius));

slot_center_length = (drive_crank_radius + driven_wheel_radius) - center_distance;

stop_arc_radius = drive_crank_radius - ( drive_pin_diameter * 1.5 );
stop_disk_radius = stop_arc_radius - allowed_clearance;

echo(center_distance=center_distance);
echo(driven_wheel_radius=driven_wheel_radius);
echo(slot_center_length=slot_center_length);
echo(stop_arc_radius=stop_arc_radius);
echo(stop_disk_radius=stop_disk_radius);

module drive_wheel() {
    difference() {
        cylinder(h = 16, r = stop_disk_radius - allowed_clearance);

        left(center_distance) up(-0.5) cylinder(h = 17, r = driven_wheel_radius);
    };

    left(drive_crank_radius) cylinder(h = 16, r = drive_pin_diameter / 2 - allowed_clearance);

        cylinder(h = 8 - allowed_clearance, r = drive_crank_radius + drive_pin_diameter / 2);
}

module driven_wheel() {
    up(8) difference() {
        cylinder(h = 8, r = driven_wheel_radius - allowed_clearance);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0,0,r])
            right(driven_wheel_radius - slot_center_length / 2) up(4)
            cube([slot_center_length, drive_pin_diameter, 9], center=true);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0,0,r])
            right(driven_wheel_radius - slot_center_length) up(-0.5)
            cylinder(h = 9, r = drive_pin_diameter / 2);

        for (r = [0:360/driven_slot_quantity:360]) rotate([0, 0, r])
            rotate([0,0,360 / driven_slot_quantity / 2])
            right(center_distance)  up(-0.5)
            cylinder(h = 9, r = stop_disk_radius);
    };

    cylinder(h = 16, r = 5);
}

module drive_wheel_with_axle() {
    difference() {
        drive_wheel();

        up(-0.5) lego_axle(m=3);
    }
}

module driven_wheel_with_axle() {
    difference() {
        driven_wheel();

        up(-0.5) lego_axle(m=3, hole=true);
    }
}

color("#ff8888") drive_wheel_with_axle();
color("#33ff33") left(center_distance) driven_wheel_with_axle();

// drive_wheel_with_axle();
// left(drive_crank_radius + driven_wheel_radius) up(16) rotate([0, 180, 0]) driven_wheel_with_axle();
