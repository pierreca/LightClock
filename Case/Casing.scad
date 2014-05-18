
$fa=0.1;

// all units in mm
clock_radius = 85;
screwhole_radius = 2;

// Arduino Components
lcd_screen_width=71;
lcd_screen_height=26;

chronodot_outer_radius = 15;
chronodot_height = 7;

// LED Rings
ring_height = 3;

ring60_inner_radius = 72.5;
ring60_outer_radius = 78.5;

ring24_inner_radius = 26;
ring24_outer_radius = 32.5;

ring12_inner_radius = 12;
ring12_outer_radius = 18.5;

// Positions

left_eye_height = 25;
right_eye_height = 20;
eye_separation = 53;

arduino_x = -40;
arduino_y = -5;
arduino_z = -20;

buttons_x = lcd_screen_x - 4;
buttons_y = lcd_screen_y - 32;

module led_ring(inner_radius, outer_radius) {
	difference() {
		cylinder(h=ring_height, r=outer_radius);
		cylinder(h=ring_height, r=inner_radius);
	}
}

module button(x, y) {
	translate([x,y,0]) {
		cube(size=[6,6,6]);
	}
}

module buttons(x, y) {
	translate([x,y,0]) {
		color("blue") {
			button(x, y + 4);
			button(x + 8, y);
			button(x + 8, y + 7);
			button(x + 16, y + 4);
			button(x + 24, y + 7);
			button(x + 72.5, y);
		}
	}
}

module arduino_lcd_shield (x, y, z) {
	translate([x, y - 54, z]) {
		color("blue") cube(size=[69, 54, 13]);
		color("silver") {
			translate([13.5,2.5,-20]) cylinder(h=20, r=screwhole_radius);
			translate([66,7.5,-20]) cylinder(h=20, r=screwhole_radius);
			translate([66,35,-20]) cylinder(h=20, r=screwhole_radius);
			translate([15,51,-20]) cylinder(h=20, r=screwhole_radius);
		}
		translate([0, 0, 13]) {
			// base PCB
			color("teal") cube(size=[81, 54, 1.6]);
			// buttons
			translate([0, 0, 1.6])
			color("grey") buttons(0, 0);
			// screen PCB
			translate([0, 15, 6.6]){
				color("teal") cube(size=[81, 36, 1.6]);
				// screen
				translate([4, 4.5, 1.6])
					color("magenta")cube(size=[lcd_screen_width, lcd_screen_height, 15]);
			}
		}
	}
}

module left_eye (x, y, z) {
 	translate([x, y, z]) {
		led_ring(ring24_inner_radius, ring24_outer_radius);

		translate([0, -13, -35])
			color("silver") cylinder(h=50, r=screwhole_radius);
		
		color("darkblue")
			translate([0, 10, -5])
				cylinder(h=chronodot_height, r=chronodot_outer_radius);

		color("silver") 
			translate([-12.5,10,-40]) cylinder(h=40, r=screwhole_radius);
	}
}

module right_eye (x, y, z) {
 	translate([x, y, z]) {
		led_ring(ring12_inner_radius, ring12_outer_radius);
		translate([0, -8, -35])
			color("silver") cylinder(h=50, r=screwhole_radius);
	}
}

module face(x, y, z) {
	translate([x, y, z]) {
		led_ring(ring60_inner_radius, ring60_outer_radius);
		
		left_eye(eye_separation / 2, left_eye_height, 0);
		right_eye(-eye_separation / 2, right_eye_height, 0);
		
		arduino_lcd_shield(arduino_x, arduino_y, arduino_z);
	}
}


module face_plate (x, y, z) {
 	translate([x, y, z]) {
		cylinder(r = clock_radius, h = 6.35);
	}
}

module back_plate (x, y, z) {
 	translate([x, y, z]) {
		cylinder(r = clock_radius, h = 6.35);
	}
}

//projection()
//difference() {
//	color("black") face_plate(0, 0, 0);
//	face(0, 0, -4);
//}

projection()
difference() {
	color("black") back_plate(0, 0, -35);
	face(0, 0, -4);
}
