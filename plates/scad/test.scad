use <wings.scad>;

$vpd = 305;
$vpr = [0, 0, 0];
$vpt = [60, 40, 0];

laser_margin = 0.20;
m14_hole_R = 1.40 + laser_margin;
m14_hole_r = m14_hole_R / 2;

tile_size = 17.82;
tile_space = 1.23;
tile_corner = 1.78;

staggered_tile_num = 3;

module c(hole_r, width, height) {
  difference() {
    offset(-1) offset(1) square([tile_size, height]);
    #for (right = [0, 1], top = [0, 1]) {
      translate(hole_coords(right, top, width=width, height=height)) {
        hole(hole_r);
      }
    }
  }
}

for (i=[0:6]) {
  tile_space = 1.20 + i*0.01;
  staggered_height = staggered_tile_num * tile_size + (staggered_tile_num - 1) * tile_space;
  translate([i*(tile_size+1), 0]) c(hole_r=m14_hole_r, width=tile_size, height=staggered_height);
}


translate([0, 70]) {
  for (i=[0:6]) {
    m14_hole_R = 1.40 + laser_margin + i*0.1 - 0.1;
    m14_hole_r = m14_hole_R / 2;
    hole_r = m14_hole_r;

    staggered_height = staggered_tile_num * tile_size + (staggered_tile_num - 1) * tile_space;
    translate([i*(tile_size+1), 0]) c(hole_r=hole_r, width=tile_size, height=staggered_height);
  }
}
