// Arduino Components for the LightClock project
//
// Pierre Cauchois (pierreca)
// 5/18/2014

pcb_thickness = 1.75;

module button(x, y) {
	translate([x,y,0]) {
		color("silver") cube(size=[6, 6, 3.5]);
		color("black") translate([3, 3, 0]) cylinder(h=5, r=1.5);
	}
}

module buttons(x, y, z) {
	translate([x, y, z]) {
		button(x, y + 4);
		button(x + 8, y);
		button(x + 8, y + 7);
		button(x + 16, y + 4);
		button(x + 24, y + 7);
		button(x + 72.5, y);
	}
}

module lcd_16x2(x, y, z) {
	translate([x, y, z]) {
		color("darkgrey") difference () {
			cube(size=[73, 28, 9]);
			translate([3.5, 5, 8.6]) cube(size=[66, 18, 0.5]);
		}
		color("darkgreen") translate([3.5, 5, 8.4]) cube(size=[66, 18, 0.5]);
	}
}

module pcb(width_x, height_y) {
	color("teal") cube(size=[width_x, height_y, pcb_thickness]);
}

module arduino (x, y, z) {
	translate([x, y, z]) {
		difference() {
			pcb(68.5, 53); 	// Arduino PCB (w/ screw holes)
			translate([13.5,2.5,0]) cylinder(h=2, r=1.5);
			translate([66,7.5,0]) cylinder(h=2, r=1.5);
			translate([66,35,0]) cylinder(h=2, r=1.5);
			translate([15,51,0]) cylinder(h=2, r=1.5);
		}
		color("silver") translate([-6, 32, pcb_thickness]) cube (size=[16, 12, 11]); // USB port
		color("black") translate([-2, 1, pcb_thickness]) cube (size=[13.5, 8.5, 11]); // Power jack
		color("black") translate([26, 1, pcb_thickness]) cube (size=[21, 2.5, 8.5]); // Header
		color("black") translate([49, 1, pcb_thickness]) cube (size=[16, 2.5, 8.5]); // Header
		color("black") translate([17, 49.5, pcb_thickness]) cube (size=[26, 2.5, 8.5]); // Header
		color("black") translate([44, 49.5, pcb_thickness]) cube (size=[21, 2.5, 8.5]); // Header
	}
}

module adafruit_lcd_shield_base(x, y, z) {
	translate([x, y, z]) {
		pcb(81, 54); // base PCB
		buttons(0, 0, pcb_thickness); // buttons
	}

}

module adafruit_lcd_shield_screen() {
	pcb(81, 36); // screen PCB
	lcd_16x2(3, 3.5, 1.6); // LCD
}

module adafruit_lcd_shield_default(x, y, z) {
	translate([x, y, z]) {
		adafruit_lcd_shield_base(0, 0, 0);

		translate([0, 13.5, 3.8]) { 
			adafruit_lcd_shield_screen();
		}
	}
}

module adafruit_lcd_shield_stackable(x, y, z) {
	translate([x, y, z]) {
		adafruit_lcd_shield_base(0, 0, 0);
		color("black") translate([26, 1, pcb_thickness]) cube (size=[21, 2.5, 8.5]); // Header
		color("black") translate([49, 1, pcb_thickness]) cube (size=[16, 2.5, 8.5]); // Header
		color("black") translate([17, 49.5, pcb_thickness]) cube (size=[26, 2.5, 8.5]); // Header
		color("black") translate([44, 49.5, pcb_thickness]) cube (size=[21, 2.5, 8.5]); // Header
		rotate ([3,0,0]) translate([0, 13.5, 3]) { 
			adafruit_lcd_shield_screen();
		}
	}
}

module arduino_lcd_shield(x, y, z) {
	arduino(x, y, z);
	adafruit_lcd_shield_default(x, y, z + 13);
}

//arduino_lcd_shield(0, 0, 0);
adafruit_lcd_shield_default(0, 0, 0);