$fs = $preview ? 2 : 0.2;
$fa = $preview ? 12 : 2;

eps = 0.05;
tolerance = 0.2;

tube_size = 20;
tube_thickness = 1.5;

base_thickness = 8;

end_width = 20;
end_shell = 2;

pad_diameter = 28;
pad_thickness = 3;
pad_shell = 1;


translate([0, 0, end_width / 2])
rotate([0, 90, 0])
difference() {
  pad_pos_y = -(pad_diameter / 2 - end_width / 2 + pad_shell);

  hull() {
    cube([end_width, tube_size + 2*end_shell, tube_size], center=true);
    cube([end_width, tube_size, tube_size + 2*end_shell], center=true);

    translate([-end_shell, 0, 0])
    cube([end_width, tube_size, tube_size], center=true);

    translate([pad_pos_y , 0, tube_size / 2 + end_shell])
    cylinder(pad_thickness, d=pad_diameter + 2*pad_shell);

    translate([end_width / 2, 0, tube_size / 2 + end_shell + pad_thickness - 1])
    cube([1, tube_size + 2 * end_shell, 1], center=true);
  }

  // tube
  translate([1, 0, 0])
  cube([end_width - 1, tube_size + 2*tolerance, tube_size + 2*tolerance], center=true);

  // pad cutout
  translate([pad_pos_y, 0, tube_size / 2 + end_shell + pad_thickness - 0.5 + eps])
  cylinder(0.5, d1=pad_diameter, d2=pad_diameter + 1);
}
