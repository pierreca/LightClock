// Screws and Spacers for the LightClock project
//
// Pierre Cauchois (pierreca)
// 5/18/2014

module spacer(x,y,z) {
	spacer_generic(x, y, z, 10);
}

module short_spacer(x, y, z) {
	spacer_generic(x, y, z, 3);
}

module spacer_generic(x, y, z, length) {
	color("black")
	translate([x,y,z]) {
		difference() {
			cylinder(h = length, r = 3.5);
			cylinder(h = length, r = 1.5);
		}
	}
}

module big_spacer(x,y,z) {
	color("silver")
	translate([x,y,z]) {
		difference() {
			cylinder(h = 20, r = 4.5);
			cylinder(h = 20, r = 2);
		}
	}
}

module screw (x,y,z) {
	screw_generic(x, y, z, 20);
}

module long_screw (x,y,z) {
	color("silver")
	translate([x,y,z]) {
		difference() {
			union () {
				cylinder(h = 50, r = 2);
				cylinder(h = 2.5, r = 3.5);
			}
			translate([-4, -0.5, -0.5]) cube(size=[8, 1, 1]);
		}
	}
}

module short_screw (x,y,z) {
	screw_generic(x, y, z, 8);
}

module screw_generic (x,y,z,length) {
	color("silver")
	translate([x,y,z]) {
		difference() {
			union() {
				cylinder(h = length, r = 1.5);
				cylinder(h = 2, r = 2.5);
			}
			translate([-3, -0.5, -0.5]) cube(size=[6, 1, 1]);
		}
	}
}

screw(10,0,0);
spacer(10,0,3);

long_screw(0,0,0);
big_spacer(0,0,4);

short_screw(20, 0, 0);
short_spacer(20, 0, 3);