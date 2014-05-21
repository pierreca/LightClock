// NeoPixels Rings for the LightClock project
//
// Pierre Cauchois (pierreca)
// 5/18/2014

// LED Rings
ring_height = 3;

ring60_inner_radius = 72.5;
ring60_outer_radius = 78.5;

ring24_inner_radius = 26;
ring24_outer_radius = 32.5;

ring12_inner_radius = 12;
ring12_outer_radius = 18.5;

module led_ring(inner_radius, outer_radius) {
	difference() {
		cylinder(h=ring_height, r=outer_radius);
		translate([0,0,-0.5]) cylinder(h=ring_height + 1, r=inner_radius);
	}
}

module neopixels_ring_12(x, y, z) {
	translate([x, y, z]) {
		led_ring(ring12_inner_radius, ring12_outer_radius);
	}
}

module neopixels_ring_24(x, y, z) {
	translate([x, y, z]) {
		led_ring(ring24_inner_radius, ring24_outer_radius);
	}
}

module neopixels_ring_60(x, y, z) {
	translate([x, y, z]) {
		led_ring(ring60_inner_radius, ring60_outer_radius);
	}
}

//neopixels_ring_12(0, 0, 0);
//neopixels_ring_24(0, 0, 0);
//neopixels_ring_60(0, 0, 0);