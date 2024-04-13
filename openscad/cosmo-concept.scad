include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <gears/lego_gears.scad>

n1 = 20; // prism gear count
n2 = 20; // inter gear count

circ_pitch = 9; //all meshing gears need the same `circ_pitch` (and the same `pressure_angle`)

thickness    = 8;
hole         = 3;

d12 = gear_dist(circ_pitch=circ_pitch,teeth1=n1,teeth2=n2);
// prismr = d12 * 1.14;
prism_radius = d12;
prism_height = 500;
prism_extend = 1.14;
prism_edge_inner = prism_radius * sqrt(3);
prism_edge_outer = prism_edge_inner * prism_extend;
prism_edge_height = prism_radius * (prism_extend - 1) / 2;

a1 =  $t * 360 / n1;
a2 = -$t * 360 / n2 + 180/n2;

c_gear = "#BF80FF";
c_gear_inter = "#B3FF66";
c_prism = "#aaa";
c_prism_r = "#E60000";
c_prism_y = "#E6E600";
c_prism_g = "#00B300";
c_strips = "#fff";
c_box = [255,0,0,1];
c_box_transparent = [255,0,0,0];

half_count = 3;

module prism_raw() {
    // color(c_gear) back(offset * d12) rotate([0,0,$t*360]) up(-prism_height / 2)  zrot(a1) spur_gear(circ_pitch,n1,thickness,hole);

    color(c_prism) up(-prism_height / 2 - 8) cylinder(h=16,r=prism_radius / 3,center=true);

    up(-prism_height / 2 - 24) translate([8,0,0])  lego_axle(m=4);
    up(-prism_height / 2 - 24) translate([0,8,0])  lego_axle(m=4);
    up(-prism_height / 2 - 24) translate([-8,0,0])  lego_axle(m=4);
    up(-prism_height / 2 - 24) translate([0,-8,0])  lego_axle(m=4);
    up(-prism_height / 2 - 40)  lego_axle(m=6);

    color(c_gear) up(-prism_height / 2 - 24)  zrot(a1) spur_gear(circ_pitch,n1,thickness,hole);


    color(c_prism) up(prism_height / 2 + 8) cylinder(h=16,r=prism_radius / 3,center=true);

    up(prism_height / 2)  lego_axle(m=4);


    color(c_prism) cylinder(h=prism_height,r=prism_radius,center=true,$fn=3);

    color(c_prism_r) up(-prism_height / 2) linear_extrude(height=prism_height)
        rotate([0,0,90]) translate([0, prism_radius / 2 + prism_edge_height / 2,0])
        trapezoid(h=prism_edge_height,w1=prism_edge_inner,w2=prism_edge_outer);

    color(c_prism_y) up(-prism_height / 2) linear_extrude(height=prism_height)
        rotate([0,0,210]) translate([0, prism_radius / 2 + prism_edge_height / 2,0])
        trapezoid(h=prism_edge_height,w1=prism_edge_inner,w2=prism_edge_outer);

    color(c_prism_g) up(-prism_height / 2) linear_extrude(height=prism_height)
        rotate([0,0,330]) translate([0, prism_radius / 2 + prism_edge_height / 2,0])
        trapezoid(h=prism_edge_height,w1=prism_edge_inner,w2=prism_edge_outer);
}

module prism(index) {
    offset=2*index;

    back(offset * d12) rotate([0,0,animate_rotation($t)]) prism_raw();
}

module prism_inter_raw() {
    up(-prism_height / 2 - 40)  lego_axle(m=3);

    color(c_gear_inter) up(-prism_height / 2 - 24)
        zrot(a2) spur_gear(circ_pitch,n2,thickness,hole);
}

module prism_inter(index) {
    offset=2*index;

    back(offset * d12 + d12) rotate([0,0,-animate_rotation($t)]) prism_inter_raw();
}

module strips() {
    color(c_strips) up(prism_height / 2 + 26)  cube([12, d12 * half_count * 5, 12], center=true);
    color(c_strips) up(-prism_height / 2 - 38)  cube([12, d12 * half_count * 5, 12], center=true);
}

module box() {
    up(prism_height / 2 + 26 + 12)  cube([prism_radius * 3, d12 * half_count * 5, 12], center=true);
    up(-prism_height / 2 - 38 - 12)  cube([prism_radius * 3, d12 * half_count * 5, 12], center=true);

    up(-6) back(d12 * half_count * 2.5) cube([prism_radius * 3, 12, prism_height + 100], center=true);
    up(-6) back(-d12 * half_count * 2.5) cube([prism_radius * 3, 12, prism_height + 100], center=true);

    up(-6) left(-prism_radius * 1.5) cube([12, d12 * half_count * 5 + 12, prism_height + 100], center=true);

    difference() {
        up(-6) left(prism_radius * 1.5) cube([12, d12 * half_count * 5 + 12, prism_height + 100], center=true);
        left(prism_radius * 1.5) cube([24, d12 * half_count * 4.8, prism_height], center=true);
    }
}

function animate_rotation(t) = lookup(t, [
    [0.0, 0],
    [0.4, 360],
    [0.6, 360],
    [1.0, 720],
]);

function animate_box_color(t) = lookup(t, [
    [0.0, 1],
    [0.4, 1],
    [0.6, 0],
    [1.0, 0],
]);

loc_vpt = [
    [-160, 0, 20],
    [-160, 0, 20],
    [-56,252,-205],
    [-56,252,-205]
];
function animate_vpt(t,i) = lookup(t, [
    [0.0, loc_vpt[0][i]],
    [0.4, loc_vpt[1][i]],
    [0.6, loc_vpt[2][i]],
    [1.0, loc_vpt[3][i]],
]);
loc_vpr = [
    [90, 0, 270],
    [90, 0, 270],
    [140, 0, 270],
    [140, 0, 270]
];
function animate_vpr(t,i) = lookup(t, [
    [0.0, loc_vpr[0][i]],
    [0.45, loc_vpr[1][i]],
    [0.6, loc_vpr[2][i]],
    [1.0, loc_vpr[3][i]],
]);
function animate_vpd(t) = lookup(t, [
    [0.0, 2500],
    [0.4, 2500],
    [0.6, 750],
    [1.0, 750],
]);

$vpt=[animate_vpt($t,0), animate_vpt($t,1), animate_vpt($t,2)];
$vpr=[animate_vpr($t,0), animate_vpr($t,1), animate_vpr($t,2)];
$vpd=animate_vpd($t);

for ( i = [-half_count:1:half_count]) prism(i);
for ( i = [-half_count:1:half_count - 1]) prism_inter(i);

strips();
color([0.7,0.35,0,animate_box_color($t)]) box();
