$fs = $preview ? 2 : 0.2;
$fa = $preview ? 12 : 2;

eps = 0.05;
tolerance = 0.2;

base_thickness = 8;
base_diameter = 118;
base_cut = 8;

tube_width = 20.8;
holders_thickness = tube_width + 8;

cover_shell = 1;
cover_height = base_thickness + holders_thickness + cover_shell;
cover_diameter = base_diameter + 2 * cover_shell + 2 * tolerance;

screw_length = 30;
screw_head_diameter = 6;
screw_diameter = 3.2;
screw_pillar_extra_length = 5;

module cover() {
  difference() {
    cylinder(cover_height, d = cover_diameter);

    translate([0, 0, -eps])
    cylinder(cover_height - cover_shell + eps, d = cover_diameter - 2 * cover_shell);

    // base cut
    translate([0, 0, -eps])
    for (x = [-base_diameter / 2 - 30 + base_cut, base_diameter / 2 - base_cut]) {
      translate([x, -base_diameter / 2, 0])
      cube([30, base_diameter, cover_height + 2*eps]);
    }

    // screw hole
    for (v = [60, 120, 240, 300]) {
      rotate([0, 0, v])
      translate([48, 0, -eps])
      cylinder(cover_height + 2, d=screw_head_diameter);
    }
  }

  // cover fastening
  for (v = [60, 120, 240, 300]) {
    rotate([0, 0, v])
    translate([48, 0, screw_length - screw_pillar_extra_length])
    difference() {
      // pillar
      cylinder(cover_height - screw_length + screw_pillar_extra_length, d=screw_head_diameter + 2);

      // screw head cutout
      translate([0, 0, screw_pillar_extra_length + 1])
      difference() {
        cylinder(cover_height - screw_length, d=screw_head_diameter);

        // cutout to create bridging for support-free print
        for (y = [screw_head_diameter / 5, -screw_head_diameter - screw_head_diameter / 5]) {
          translate([-screw_head_diameter / 2, y, -eps])
          cube([screw_head_diameter, screw_head_diameter, 0.2 + eps]);
        }
      }

      // screw cutout
      translate([0, 0, -1])
      cylinder(cover_height - screw_length, d=screw_diameter);
    }
  }
}

mirror([0, 0, 1])
cover();
