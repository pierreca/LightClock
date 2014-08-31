// LightClock project main file
//
// Pierre Cauchois (pierreca)
// 5/18/2014

// TODO:
// - Ring holders for 12 and 24 LEDs rings
// - "Margin" for the LCD screen is already taken care of, but not for the screw holes

use <Hardware.scad>;
use <Arduino.scad>;
use <ParallaxPIRSensor.scad>;
use <WaterproofPushButton.scad>;
include <NeoPixels.scad>;

$fa=0.1;

// all units in mm
clock_radius = 85;
screwhole_radius = 3;
acrylic_plate_height = 3;

// Positions
right_eye_height = 25;
left_eye_height = 20;
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
		neopixels_ring_24(-eye_separation / 2, right_eye_height, 0);
		neopixels_ring_12(eye_separation / 2, left_eye_height, 0);
		chronodot(-55, 0, -20);
		arduino_lcd_shield(arduino_x, arduino_y, arduino_z);
		pir_sensor(-eye_separation / 2 - 18, right_eye_height - 17, -1);
		waterproof_pushbutton(eye_separation / 2, left_eye_height, -13, 11);
		translate([55,-30,-13]) rotate([0,180,0]) waterproof_pushbutton(0,0,0,4);
	}
}

module mounting_hardware(x, y, z) {
	translate([x, y, z]) {
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
		spacer(-55, -12, -30);
		screw(-55, -12, -35.5);

		// 60 LEDs ring holders
		short_screw(0, 69, -6); //top
		short_spacer(0, 69, 0);

		short_screw(0, -69, -6); // bottom
		short_spacer(0, -69, 0);

		short_screw(-69, 0, -6); // left
		short_spacer(-69, 0, 0);

		short_screw(69, 0, -6); // right
		short_spacer(69, 0, 0);

		// 24 LEDs ring holders
		short_screw(-38, 44, -6); //top left
		short_spacer(-38, 44, 0);

		short_screw(-15, 44, -6); // top right
		short_spacer(-15, 44, 0);

		short_screw(-53, 0, -6); // bottom left
		short_spacer(-53, 0, 0);

		short_screw(0, 0, -6); // bottom right
		short_spacer(0, 0, 0);

		// 12 LEDs ring holders
		short_screw(17, 40, -6); //top left
		short_spacer(17, 40, 0);

		short_screw(36, 40, -6); // top right
		short_spacer(36, 40, 0);

		short_screw(17, 0, -6); // bottom left
		short_spacer(17, 0, 0);

		short_screw(36, 0, -6); // bottom right
		short_spacer(36, 0, 0);

		// main screws
		rotate([0,180,0]){
			long_screw(27,43,-3);
			big_spacer(27,43,4);
			long_screw(-27,43,-3);
			big_spacer(-27,43,4);
			long_screw(-10,-67,-3);
			big_spacer(-10,-67,4);
		}
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
			cylinder(h = acrylic_plate_height, r = clock_radius);
			translate([0, 0, -0.5]) cylinder(h = acrylic_plate_height + 1, r = clock_radius - 10);
		}
		
		translate([-68,35,0]) cube(size=[136,15,acrylic_plate_height]);
		translate([-25,62,0]) cube(size=[50,18,acrylic_plate_height]);
		translate([-25,-80,0]) cube(size=[50,18,acrylic_plate_height]);
		translate([12,5,0]) cube(size=[30,30,acrylic_plate_height]);
		difference() {
			translate([-80,-5,0]) cube(size=[160,10,acrylic_plate_height]);
			translate([-32,-6,0]) cube(size=[10,12, acrylic_plate_height]);
		}
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

// general view
color("black") face_plate(0, 0, 4);
color("black") back_plate(0, 0, -33);
components(0, 0, 0);
mounting_hardware(0, 0, 0);
color("red") ring_mounting(0,0,0);


// face plate laser cut
//projection() difference() {
//	face_plate(0, 0, 4);
//	components(0, 0, 0);
//}

// side ring laser cut
//projection() ring_side_plate(0, 0, 0);

// Rings back plate laser cut
//projection() difference() {
//	rings_back_plate(0,0,-3);
//	waterproof_pushbutton(eye_separation / 2, left_eye_height, -13, 11);
//	mounting_hardware(0,0,0);
//}

// Back plate laser cut
//projection() difference() {
//	back_plate(0,0,-33);
//	mounting_hardware(0,0,0);
//}