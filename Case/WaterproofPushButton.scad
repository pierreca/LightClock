body_height=20.5;
body_radius=7.5;

head_height=1.8;
head_r1=8.75;
head_r2=6.75;

inner_body_radius = 5.5;
inner_body_height = 9;

long_connector_height = 6.5;
short_connector_height = 5.5;
connector_width=1.8;
connector_thickness=0.5;

bolt_outer_radius = 10.2;
bolt_inner_radius = 7.5;
bolt_height = 3;

module bolt(x, y, z) {
	translate([x, y, z]) color("silver") {
		difference() {
			cylinder(h = bolt_height, r = bolt_outer_radius, $fn=6);
			translate([0,0,-0.5]) cylinder(h = bolt_height + 1, r = bolt_inner_radius);
		}
	}
}

module connectors(x, y, z) {
	translate([x, y, z]) color("silver"){
		cube(size=[connector_thickness, connector_width, long_connector_height]);
		translate([8.5,0,0]) cube(size=[connector_thickness, connector_width, long_connector_height]);
		translate([2,2.5,1]) cube(size=[connector_thickness, connector_width, short_connector_height]);
		translate([4.25,2.5,1]) cube(size=[connector_thickness, connector_width, short_connector_height]);
		translate([6.5,2.5,1]) cube(size=[connector_thickness, connector_width, short_connector_height]);
	}
}

module waterproof_pushbutton(x, y, z, bolt_spacing) {
	translate([x, y, z]) {
		color("silver") {
			cylinder(h = body_height, r = body_radius);
			translate([0, 0, body_height]) cylinder(h = head_height, r1 = head_r1, r2 = head_r2);
		}
		color("gray") {
			translate([0,0,-inner_body_height]) cylinder(h = inner_body_height, r = inner_body_radius);
		}

		connectors(-4.5,-0.9, -inner_body_height - long_connector_height);
		bolt(0,0, body_height - 3 - bolt_spacing);
	}
}

waterproof_pushbutton(0,0,0, 5);