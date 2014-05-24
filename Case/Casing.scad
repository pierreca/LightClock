// LightClock project main file
//
// Pierre Cauchois (pierreca)
// 5/18/2014

// TODO:
// - Ring holders for 12 and 24 LEDs rings
// - "Margin" for the LCD screen is already taken care of, but not for the screw holes

use <Hardware.scad>;
use <Arduino.scad>;
include <NeoPixels.scad>;

$fa=0.1;

// all units in mm
clock_radius = 85;
screwhole_radius = 3;
acrylic_plate_height = 3;

// Positions
left_eye_height = 25;
right_eye_height = 20;
eye_separation = 53;

arduino_x = -40.5;
arduino_y = -60;
arduino_z = -20;

module chronodot(x, y, z) {
	translate([x, y, z]) {
		difference() {
			color("darkblue") cylinder(h=1.75, r=15);
			translate([0, -12, 0]) cylinder(h=2, r=1.5);
		}
		color("silver") translate([0, 5, 1.75]) cylinder(h=4, r=8.5); 
	}
}

module components(x, y, z) {
	translate([x, y, z]) {
		neopixels_ring_60(0, 0, 0);

		// left eye
		neopixels_ring_24(eye_separation / 2, left_eye_height, 0);

		// right eye
		neopixels_ring_12(-eye_separation / 2, right_eye_height, 0);

		// chronodot
		chronodot(eye_separation / 2, left_eye_height + 10, -20);
		
		// arduino + lcd shield
		arduino_lcd_shield(arduino_x, arduino_y, arduino_z);
	}
}

module mounting_hardware(x, y, z) {
	translate([x, y, z]) {
		// Large screws
		rotate([180, 0, 0]) {
			long_screw(eye_separation / 2, -(left_eye_height - 13), -12);
			long_screw(-eye_separation / 2, -(right_eye_height - 8), -12);
			big_spacer(eye_separation / 2, -(left_eye_height - 13), 5);
			big_spacer(-eye_separation / 2, -(right_eye_height - 8), 5);
		}

		// Arduino mounting spacers and screws
		spacer(-25, -9, -30);
		screw(-25, -9, -35.5);

		spacer(-27, -57.5, -30);
		screw(-27, -57.5, -35.5);

		spacer(25.5, -52.5, -30);
		screw(25.5, -52.5, -35.5);

		spacer(25.5, -25, -30);
		screw(25.5, -25, -35.5);

		// Chronodot spacer and screw
		spacer(eye_separation / 2, left_eye_height - 2, -30);
		screw(eye_separation / 2, left_eye_height - 2, -35.5);
	}
}

module ring_holder (x, y, z) {
	translate([x, y, z]) {
		difference() {
			cube(size=[20, acrylic_plate_height, 37]);
			translate([5, 0, 33]) cube(size=[9, acrylic_plate_height + 1, 4]);
			translate([10.5, -0.5, -1]) cube(size=[11, acrylic_plate_height + 1, acrylic_plate_height + 1]);
		}
	}
}

module rings_back_plate(x, y, z) {
	translate([x, y, z]) {
		difference() {
			hull() {
				translate([eye_separation / 2, left_eye_height, 0]) 
					cylinder(r = ring24_outer_radius + 2, h = acrylic_plate_height);
	
				translate([-eye_separation / 2, right_eye_height, 0]) 
					cylinder(r = ring12_outer_radius + 2, h = acrylic_plate_height);
			}

			translate([0,-10,-0.5]) cube(size=[60, 5, acrylic_plate_height + 1]);
			translate([eye_separation / 2, (left_eye_height - 13), -0.5]) 
				cylinder(r = 2.5, h = acrylic_plate_height + 1);
			translate([-eye_separation / 2, (right_eye_height - 8), -0.5]) 
				cylinder(r = 2.5, h = acrylic_plate_height + 1);

		}
		difference() {
			cylinder(h = acrylic_plate_height, r = clock_radius);
			translate([0, 0, -0.5]) cylinder(h = acrylic_plate_height + 1, r = clock_radius - 13);
		}
		translate([50,20,0]) cube(size=[20, 20, acrylic_plate_height]);
		translate([-70,20,0]) cube(size=[40, 20, acrylic_plate_height]);
		translate([-10,40,0]) cube(size=[20, 40, acrylic_plate_height]);
		//eyes_plate_holder(0, 10, -36 + 2 * acrylic_plate_height);
	}
}

module ring_side_plate(x, y, z) {
	translate([x, y, z]) {
		difference() {
			cylinder(h = acrylic_plate_height, r = clock_radius);
			translate([0, 0, -0.5]) cylinder(h = acrylic_plate_height + 1, r = 80);
		}
	}
}

module face_plate (x, y, z) {
 	translate([x, y, z])
		cylinder(r = clock_radius, h = acrylic_plate_height);
}

module back_plate (x, y, z) {
 	translate([x, y, z]) {
		cylinder(r = clock_radius, h = acrylic_plate_height);
	}
}

module ring_mounting(x, y, z) {
	translate([x, y, z]) {
		rings_back_plate(0, 0, -3);
		ring_side_plate(0,0,0);
	}
}

//projection()
//difference() {
//	color("black") face_plate(0, 0, 0);
//	components(0, 0, -4);
//}

//projection()
//difference() {
	color("black") face_plate(0, 0, 4);
	color("black") back_plate(0, 0, -33);
	components(0, 0, 0);
	mounting_hardware(0, 0, 0);
	color("red") ring_mounting(0,0,0);
//}
