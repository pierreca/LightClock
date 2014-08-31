pcb_thickness = 1.75;
pcb_width = 36;
pcb_height = 25;

sensor_base_width = 23;
sensor_base_thickness = 3.2;
sensor_orb_radius = 11.4;

module pcb (x, y, z) {
	translate([x, y, z]) {
		difference() {
			color("teal") cube(size=[pcb_width, pcb_height, pcb_thickness]);		
			translate([2.5, 13, -0.5]) cylinder(h = pcb_thickness + 1, r = 1.15);
			translate([32.5, 13, -0.5]) cylinder(h = pcb_thickness + 1, r = 1.15);
		}
	}
}

module sensor (x, y, z) {
	translate([x, y, z]) {
		color("white") 
		union() {
			cube(size=[sensor_base_width, sensor_base_width, sensor_base_thickness]);
			translate([sensor_orb_radius, sensor_orb_radius, sensor_base_thickness])
			difference() {
				sphere(sensor_orb_radius); // for normal rendering
				//cylinder(h = 20, r = sensor_orb_radius); // helps for laser cutting
				translate([-(sensor_orb_radius + 0.5), -(sensor_orb_radius + 0.5), -(2*sensor_orb_radius + 1)]) cube(size=[2*sensor_orb_radius + 1, 2*sensor_orb_radius + 1, 2*sensor_orb_radius + 1]);
			}
		}		
	}
}

module jumper (x, y, z) {
	translate([x, y, z]) {	
		color("black") cube(size=[2, 6, 6]);
	}
}

module connector (x, y, z) {
	translate([x, y, z]) {	
		color("black") cube(size=[7.5, 8.5, 2]);
	}
}


module pir_sensor (x, y, z) {
	translate([x, y, z]) {
		pcb(0,0,0);
		sensor(6, 0.8, pcb_thickness);	
		jumper(1, 17, -6);	
		connector(14,-6.6,-2);
	}
}

pir_sensor(0,0,0);

