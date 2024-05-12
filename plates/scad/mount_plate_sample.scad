include <wings.scad>;
include <dmm_make.scad>;

$fn = 30;
// $vpd = 305;
// $vpt = [80, 50, 0];
$vpr = [0, 0, 0];
$vpd = 200;
$vpt = [15, 30, 9];

printer_pitch = MJF_PA11_pitch;
sample_margin_size = 3;
sample_tile_size = tile_size + sample_margin_size;
sample_staggered_height = staggered_tile_num * sample_tile_size + (staggered_tile_num - 1) * tile_space;


module print_num(num, plate_thickness) {
  char_size = 3.5;
  font = "Menlo:style=Bold";
  translate([(sample_tile_size-char_size)/2, MJF_min_width, plate_thickness - MJF_min_depth]) {
    linear_extrude(height=MJF_min_depth) {
      text(str(num), char_size, font);
    }
  }
}

module sample_2d() {
  difference() {
    square([sample_tile_size, sample_staggered_height]);
  }
}

module switches() {
  translate([sample_tile_size/2 - 0.1, sample_tile_size/2 - 0.1, - switch_leg_length() - switch_latch_thickness()]) {
    for (i=[0:2]) {
      translate([0, (tile_size+tile_space)*i]) {
        switch();
      }
    }
  }
}

module sample(num, plate_thickness, rim_thickness, rim_z, hole_height, hole_width, rim_hole_height, rim_hole_width, pit_thickness=0.9, pit_width=3.0) {
  *color("blue", 0.8) {
    difference() {
      linear_extrude(height=plate_thickness) {
        difference() {
          sample_2d();
          translate([sample_margin_size/2, sample_margin_size/2*3]) {
            staggerd_switch_holes(height=rim_hole_height, width=hole_width, unmount_pit=true, pit_thickness=pit_thickness, pit_width=pit_width);
          }
        }
      }
      print_num(num, plate_thickness);
    }
  }

  translate([0, 0, rim_z]) {
    color("purple", 0.8) {
      linear_extrude(height=rim_thickness) {
        translate([sample_margin_size/2, sample_margin_size/2*3]) {
          difference() {
            staggerd_switch_holes(height=rim_hole_height, width=hole_width);
            staggerd_switch_holes(height=hole_height, width=rim_hole_width);
          }
        }
      }
    }
  }
  *translate([printer_pitch/2*3, sample_margin_size/2*2+printer_pitch, rim_z]) {
    %switches();
  }
}

// before
// list = [
//   // plate_thickness, rim_thickness, rim_z, hole_height, hole_width, rim_hole_height, rim_hole_width
//   [mount_plate_thickness,   mount_plate_thickness, 0, switch_rim_size(), switch_rim_size(), switch_bottom_height(), switch_bottom_width()],
//   [switch_slot_thickness(), switch_slot_thickness(), 0, switch_rim_size(), switch_rim_size(), switch_bottom_height(), switch_bottom_width()],
//   [switch_slot_thickness(), mount_plate_thickness, 0, switch_rim_size(), switch_rim_size(), switch_bottom_height(), switch_bottom_width()],
//   [switch_slot_thickness() + 0.2, switch_slot_thickness() - printer_pitch, printer_pitch * 2, switch_rim_size() + printer_pitch, switch_rim_size() + printer_pitch, switch_bottom_height(), switch_bottom_width()],
//   [switch_slot_thickness() + 0.2, mount_plate_thickness, 0, switch_rim_size() + printer_pitch, switch_rim_size() + printer_pitch, switch_bottom_height(), switch_bottom_width()],
// ];

// v2
plate_thickness = switch_slot_thickness() + printer_pitch * 3;
rim_thickness = switch_slot_thickness() - 0.1;
rim_z = plate_thickness - rim_thickness;
// list = [
//   // plate_thickness, rim_thickness, rim_z, hole_height, hole_width, rim_hole_height, rim_hole_width
//   [plate_thickness, rim_thickness, rim_z, switch_rim_size() + printer_pitch, switch_rim_size() + printer_pitch, switch_bottom_height(), switch_bottom_width()],
//   [plate_thickness, rim_thickness+0.1, rim_z-0.1, switch_rim_size() + printer_pitch, switch_rim_size() + printer_pitch, switch_bottom_height(), switch_bottom_width()],
// ];

// for (i=[0:len(list)-1]) {
//   plate_thickness = list[i][0];
//   rim_thickness = list[i][1];
//   rim_z = list[i][2];
//   hole_height = list[i][3];
//   hole_width = list[i][4];
//   rim_hole_height = list[i][5];
//   rim_hole_width = list[i][6];
//   translate([(tile_size+5)*i, 0, 0]) {
//     sample(i+1, plate_thickness, rim_thickness, rim_z, hole_height, hole_width, rim_hole_height, rim_hole_width);
//   }
// }

// v3
hole_height = switch_rim_size() + printer_pitch;
hole_width  = switch_rim_size() + printer_pitch;
rim_hole_height = switch_bottom_height();
rim_hole_width = switch_bottom_width();
list = [
  // pit_thickness, pit_width
  // [0.9, 3.0],
  [1.2, 3.0],
];

for (i=[0:len(list)-1]) {
  pit_thickness = list[i][0];
  pit_width = list[i][1];
  translate([(tile_size+5)*i, 0, 0]) {
    sample(i+1, plate_thickness, rim_thickness, rim_z, hole_height, hole_width, rim_hole_height, rim_hole_width, pit_thickness, pit_width);
  }
}

// translate([-25, 0, 0]) {
//   color("purple", 0.6) import("stl/mount_plate_sample_v3.stl");
// }

translate([printer_pitch/2*3, sample_margin_size/2*2+printer_pitch, rim_z]) {
  translate([-20, 0, 0]) {
    staggerd_switch_holes(hole_height, hole_width, unmount_pit=true);
  }

  translate([-40, 0, 0]) {
    staggerd_switch_holes(hole_height, hole_width, unmount_pit=true);
  }
}
