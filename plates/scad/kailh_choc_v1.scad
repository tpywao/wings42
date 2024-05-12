// ref. http://www.kailh.com/en/Products/Ks/CS/320.html

$fn = 30;
$vpd = 305;
$vpt = [40, 30, 0];
// $vpr = [0, 0, 0];
$vpr = [90, 0, 0];

width = 11.00;  // 大まかな値
height = 5.00;  // 大まかな値
thickness = 3.00;
top_width = 13.60;
top_height = 13.80;
top_thickness = 2.00;

rim_size = 15.00;
rim_thickness = 0.80;

bottom_size = 13.80;
bottom_thickness = 2.20;

slot_thickness = 1.30;

latch_width = 14.50 - bottom_size;
latch_height = 10.0; // 大まかな値
latch_thickness = 0.9;

leg_length = 3.00;
leg_r = 3.20 / 2;


module leg() {
  color("brown", 0.8) {
    cylinder(leg_length, r=leg_r);
  }
}

module bottom_housing() {
  color("brown", 0.8) {
    rotate([0, 180]) translate([0, 0, -bottom_thickness]) {
      linear_extrude(height=bottom_thickness) {
        offset(1) offset(-1) {
          square(size=[bottom_size, bottom_size], center=true);
        }
      }
    }
  }
  // latch
  color("white", 1) linear_extrude(height=latch_thickness) {
    square(size=[latch_width+bottom_size, latch_height], center=true);
  }
}

module rim() {
  color("brown", 0.8) {
    linear_extrude(height=rim_thickness) {
      offset(1) offset(-1) {
        square(size=[rim_size, rim_size], center=true);
      }
    }
  }
}

module top_housing() {
  color("gray", 0.5) {
    linear_extrude(height=top_thickness) {
      offset(1) offset(-1) {
        square(size=[top_width, top_height], center=true);
      }
    }
    // stem
    translate([0, 0, top_thickness]) {
      #linear_extrude(height=thickness) {
        square(size=[width, height], center=true);
      }
    }
  }
}

module switch() {
  leg();
  translate([0, 0, leg_length]) {
    bottom_housing();
    translate([0, 0, bottom_thickness]) {
      rim();
      translate([0, 0, rim_thickness]) {
        top_housing();
      }
    }
  }
}

function switch_top_width() = top_width;
function switch_top_height() = top_height;
function switch_bottom_height() = bottom_size;
function switch_bottom_width() = bottom_size;
function switch_slot_thickness() = slot_thickness;
function switch_latch_thickness() = latch_thickness;
function switch_bottom_thickness() = bottom_thickness;
function switch_leg_length() = leg_length;
function switch_rim_size() = rim_size;


switch();
