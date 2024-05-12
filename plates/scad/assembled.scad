include <wings.scad>;

// $vpd = 305;
// $vpt = [60, 40, 0];
// $vpr = [0, 0, 0];
$vpd = 41;
$vpt = [31, 28, 1];
$vpr = [73, 0, 213];

A5 = [148, 210];
A4 = [210, 297];

module print_frame(width=A5.x, height=A5.y , margin=2) {
  difference() {
    square([width, height]);
    translate([margin, margin]) square([width-2*margin, height-2*margin]);
  }
}

module screw(diameter=2, length=5) {
  #cylinder(r=diameter/2, h=length);
}

module m14_5() {
  screw(1.4, 5);
}

module spacer(length=5, r=1) {
  #cylinder(r=r, h=length);
}


bottom();
translate([0, 0, bottom_plate_thickness]) {
  color("crimson", 1) {
    // frame();
  }
  translate([0, 0, 5 + switch_latch_thickness()]) {
    translate([0, 0, - pcb_thickness - switch_slot_thickness()]) {
      pcb(switch=true);
      translate([0, 0, pcb_thickness - 5]) screw(1.4, 5);

      translate([0, 0, pcb_thickness + switch_latch_thickness()]) {
        mount();
      }
    }
  }
}
