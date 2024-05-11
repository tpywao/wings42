use <wings.scad>;

$fn = 30;
$vpd = 305;
$vpr = [0, 0, 0];
// $vpt = [90, 118, 0];
$vpt = [60, 40, 0];

module wing_rotated() {
  rotate(9) {
    %wing();
    bottom(dxf=true);
  }
  translate([69, 4]) rotate(-90) cover();
}

translate([21, 150]) {
  wing_rotated();
  translate([114, -60]) rotate(180) {
    wing_rotated();
  }
}

// tile_size = 17.85;
// tile_space_base = 1.10;
// for (i=[0:5], j=[0:1]) {
//   s = tile_space_base + 0.02 * (i + j * 5);
//   h = tile_size * 3 + s * 2;
//   translate([i * (tile_size + 2), j * tile_size * 4]) square([tile_size, h]);
// }

