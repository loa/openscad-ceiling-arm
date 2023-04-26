$fs = $preview ? 2 : 0.2;
$fa = $preview ? 12 : 2;

eps = 0.05;

tube_width = 20.8;
tube_angle = 16;

base_thickness = 8;
base_diameter = 118;
base_cut = 8;

holders_thickness = tube_width + 8;
holders_top_width = 16;
holders_bottom_width = holders_top_width + holders_thickness;

module main() {
  difference() {
    union() {
      // base plate
      translate([-base_diameter/2 - eps, -base_diameter/2 - eps, 0])
      cube([base_diameter + 2*eps, base_diameter + 2*eps, base_thickness]);

      for (i = [0, 1]) {
        mirror([i, 0, 0])
        translate([-base_diameter / 2 + base_cut - 4, -base_diameter / 2, base_thickness - eps])
        hull() {
          cube([holders_bottom_width, base_diameter, eps]);

          translate([0, 0, holders_thickness])
            cube([holders_top_width, base_diameter, eps]);
        }
      }
    }

    // outer cutter
    union() {
      block_size = base_diameter + 20;

      difference() {
        translate([-block_size/2, -block_size/2, -block_size/2])
        cube(block_size);

        translate([0, 0, -block_size/2 - eps])
        cylinder(block_size + 2*eps, d = base_diameter);
      }

      translate([0, 0, -block_size/2])
      for (x = [-base_diameter / 2 - eps, base_diameter / 2 - base_cut + eps]) {
        translate([x, -base_diameter / 2, -eps])
        cube([base_cut, base_diameter, block_size]);
      }

      side_cutter_width = base_diameter / 2 - holders_thickness;
      for (y = [-base_diameter / 2, base_diameter / 2 - (side_cutter_width)]) {
        translate([-base_diameter / 2, y, base_thickness])
        cube([base_diameter, side_cutter_width, block_size]);
      }
    }

    // tube cutter
    for (v = [(tube_angle / 2), -(tube_angle / 2)]) {
      rotate([0, 0, v])
      translate([-base_diameter, -tube_width / 2, base_thickness])
      cube([2*base_diameter, tube_width, tube_width]);
    }

    // screw cutter
    screw_diameter = 4.2;
    screw_spacing = 72;
    screw_spacer_diameter = 12;

    for (y = [-screw_spacing / 2, screw_spacing / 2]) {
      translate([0, y, -eps])
      hull() {
        translate([0, -2, 0])
        cylinder(30, d=screw_diameter);

        translate([0, 2, 0])
        cylinder(30, d=screw_diameter);
      }

      translate([0, y, base_thickness - 1])
      hull() {
        for (i = [-2, 2]) {
          translate([0, i, 0])
          cylinder(1.1, d1=screw_spacer_diameter, d2=screw_spacer_diameter + 3);
        }
      }
    }

    // cable hole
    translate([14, screw_spacing / 2, 0])
    union() {
      translate([0, 0, -eps])
      cylinder(1, d1=8, d2=6);

      cylinder(base_thickness, d=6);

      translate([0, 0, base_thickness - 1 + eps])
      cylinder(1, d1=6, d2=8);
    }

    // cover fastening
    for (v = [60, 120, 240, 300]) {
      rotate([0, 0, v])
      translate([48, 0, -eps])
      union() {
        cylinder(base_thickness + 2 * eps, d=3.2);

        rotate([0, 0, 30])
        cylinder(base_thickness - 1, d=6.5, $fn=6);
      }
    }
  }
}

// rotate for printing
translate([0, 0, base_diameter / 2 - base_cut])
rotate([0, 90, 0])
main();

