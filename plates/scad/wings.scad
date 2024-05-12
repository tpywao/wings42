use <kailh_choc_v1.scad>;
use <kailh_choc_v1_socket.scad>;
include <dmm_make.scad>;

$fn = 30;
$vpd = 305;
$vpt = [80, 60, 0];
$vpr = [0, 0, 0];

laser_margin = 0.20;
printer_margin = 0.20;
printer_pitch = MJF_PA11_pitch;

m14_hole_R = 1.40 + laser_margin;
m14_hole_r = m14_hole_R / 2;
m2_hole_R = 2.00 + printer_margin;
m2_hole_r = m2_hole_R / 2;

tile_size = 17.82;
tile_space = 1.22;
tile_corner = 1.77;

staggered_tile_num = 3;
staggered_height = staggered_tile_num * tile_size + (staggered_tile_num - 1) * tile_space;

gasket_R = 1.10;
// ガスケットの縮み幅
gasket_shrinkage = gasket_R / 2;

frame_width = m2_hole_R + 2 + gasket_R;
margin = frame_width + 0.50;
round_off = 5;
cover_round_off = 1;

pcb_thickness = 1.60;
// ボトムプレートはアクリル2mmで作った
bottom_plate_thickness = 2.00;
mount_plate_thickness = switch_slot_thickness() + printer_pitch * 3;
mount_rim_thickness = switch_slot_thickness() - printer_pitch;
mount_rim_z = mount_plate_thickness - mount_rim_thickness;
unmount_pit_thickness = 1.2;
unmount_pit_width = 3.0;

// switch_latch_thickness + screw5mm + gasket_shrinkage
frame_thickness = switch_latch_thickness() + 5 + gasket_shrinkage;


// spacer thickness
// 3.5 >= 3.4 = screw5mm - pcb_thickness
pcb_2_bottom = 3.5;
// 6.5 = pcb_2_bottom + switch_bottom_thickness
mount_2_bottom = pcb_2_bottom + switch_bottom_thickness();
// 5.5 = 2.5 + 3
conn_throgh = 5.5;

/* biscut size
// 1
b4_4 = 2.92 + m14_hole_R;
// 1.5
b2_3 = 2 * b4_4;
// 2
b8_4 = 3 * b4_4;
// 0.25
b1_4 = 3.89 + m14_hole_R;
// 1.25
b5_4 = 5.29 + m14_hole_R;
b1_8 = 3.48 + m14_hole_R;
b3_8 = 6.74 + m14_hole_R;
// 3/8 + 0.75
b9_8 = b3_8 + 4.63 + m14_hole_R;
 */

module hole(r=m14_hole_r) {
  circle(r);
}

function hole_coords(right, top, width=tile_size, height=staggered_height) = [
  tile_corner + right*(width - 2*(tile_corner)),
  tile_corner + top*(height - 2*(tile_corner)),
];

module staggered_holes(settings) {
  for (i=[0:len(settings)-1]) {
    arg = settings[i];
    x = arg[0];
    y = arg[1];
    deg = arg[2];
    direction = arg[3];
    reserve = arg[4];
    rotate(deg) {
      translate([x, y]) {
        for (right = [0, 1], top = [0, 1]) {
          if (floor(direction / pow(2, 2*right + top))%2 == 1) {
            translate(hole_coords(right, top)) {
              hole();
            }
          }
        }
        if (reserve) {
          for (right = [0, 1]) {
            translate(hole_coords(right, 1, height=tile_size)) hole();
            translate([0, (tile_size+tile_space)*2]) translate(hole_coords(right, 0, height=tile_size)) hole();
          }
        }
      }
    }
  }
}

module staggered() {
  difference() {
    for (y = [0:2]) {
      translate([
        0,
        y*(tile_size+tile_space),
      ]) {
        square(tile_size);
      }
    }
    for (right = [0, 1], top = [0, 1]) {
      if (floor(15 / pow(2, 2*right + top))%2 == 1) {
        translate(hole_coords(right, top)) {
          hole();
        }
      }
    }
  }

  // hull version
  // hull () {
  //   polygon(points=[
  //     for (x=[0, 1], y = [0, staggered_tile_num])
  //       [x*tile_size, y*(tile_size+tile_space)-floor(y/staggered_tile_num)*tile_space]
  //   ]);
  // }
}

module staggerd_switch_holes(height=0, width=0, unmount_pit=false, switch_vertical=false, pit_thickness=unmount_pit_thickness, pit_width=unmount_pit_width) {
  hole_height = switch_vertical ? width : height;
  hole_width = switch_vertical ? height : width;
  corner_height = (tile_size - hole_height) / 2;
  corner_width = (tile_size - hole_width) / 2;
  for (y = [0:2]) {
    translate([corner_width, y*(tile_size+tile_space)+corner_height]) {
      color("blue", 0.8) square([hole_width, hole_height]);

      if (unmount_pit) {
        deg = switch_vertical ? 90 : 0;
        init_pos = switch_vertical ? hole_width : 0;
        pit_space = switch_vertical ? hole_width : hole_height;
        pit_pos = switch_vertical ? (hole_height-pit_width)/2 : (hole_width-pit_width)/2;
        color("brown", 0.8) translate([init_pos, 0]) rotate([0, 0, deg]) {
          translate([pit_pos, -pit_thickness]) {
            square([pit_width, pit_thickness]);
          }
          translate([pit_pos, pit_space]) {
            square([pit_width, pit_thickness]);
          }
        }
      }
    }
  }
}

settings = [
  // [x, y, deg, hole_direction, reserve, switch_vertical]
  /*
    hole_direction: 4ビットフラグ(0~15)
    N字を書くようにに番号を振る
    1  3 ... 2  8
    0  2 ... 1  4
    switch_vertical: スイッチをstaggerdとは垂直に配置
  */
  [0, 0, 0, 3, false, false],
  [tile_size+0.2, -0.8, -1.5, 15, true, false],
  [-2*tile_size+4.4, -2*tile_size-0.9, 108.9, 15, true, true],
  [2*tile_size+0.4, 6.2, -2.5, 15, true, false],
  [3*tile_size-0.1, 19.15, -5.18, 3, true, false],
  [4*tile_size-0.1+tile_space, 19.15, -5.18, 12, true, false],
  [5*tile_size+1.1, 14.8, -6.2, 15, true, false],
  [6*tile_size+0.7, 12.8, -8.7, 15, true, false],
];

module pcb(switch=false) {
  for (i=[0:len(settings)-1]) {
    arg = settings[i];
    x = arg[0];
    y = arg[1];
    deg = arg[2];
    rotate(deg) translate([x, y]) {
      color("darkblue", 0.7) linear_extrude(height=pcb_thickness) {
        staggered();
      }

      if (switch) {
        // 1列目はマイコンのため、スイッチを配置しない
        if (i >= 1) {
          translate([tile_size/2, tile_size/2, pcb_thickness - switch_leg_length()]) {
            for (y=[0:2]) {
              translate([
                0,
                y*(tile_size+tile_space),
              ]) switch();
            }
          }
        }
      }
    }
  }
}

function calc_rotate(x, y, deg) = [x*cos(deg)-y*sin(deg), x*sin(deg)+y*cos(deg)];

function get_arg(no, right=0, top=0) = calc_rotate(
  settings[no][0] + right*tile_size,
  settings[no][1] + top*staggered_height,
  settings[no][2]
);

function get_margin_arg(no, right=0, top=0) = calc_rotate(
  settings[no][0] + right*(tile_size+margin) - ((right+1)%2)*margin,
  settings[no][1] + top*(staggered_height+margin) - ((top+1)%2)*margin,
  settings[no][2]
);

module plate_joint_holes() {
  hole_r = m2_hole_r;
  translate(get_arg(1, top=1)) translate([3.5, 2]) hole(hole_r);
  translate(get_arg(4, top=1)) rotate(settings[4][2]) translate([-4.88, 3.58]) hole(hole_r);
  translate(get_arg(5, 1, 1)) rotate(settings[5][2]) translate([4.88, 3.58]) hole(hole_r);
  translate(get_arg(7, 1, 1)) rotate(settings[7][2]) translate([3.10, 3.40]) hole(hole_r);
  translate(get_arg(7, 1)) rotate(settings[7][2]) translate([2.68, -2.68]) hole(hole_r);
  translate(get_arg(4, 1)) rotate(settings[4][2]) translate([1, -10.20]) hole(hole_r);
  translate(get_arg(2)) rotate(settings[2][2]) translate([-3.58, -4.88]) hole(hole_r);
  translate(get_arg(2, 1, 1)) rotate(settings[2][2]) translate([2.68, 2.68]) hole(hole_r);
  translate(get_arg(2, top=1)) rotate(settings[2][2]) translate([-2.68, 2.68]) hole(hole_r);
  translate(get_arg(0, 1)) translate([-0.58, -3.20]) hole(hole_r);
}

module plate(bottom=false) {
  // 面取り
  offset(round_off) offset(-round_off) offset(-round_off) offset(round_off) {
    union() {
      polygon(points=[
        get_arg(1, top=1),
        get_margin_arg(0, 1, 1),
        get_margin_arg(4, top=1),
        get_margin_arg(5, 1, 1),
        get_margin_arg(7, 1, 1),
        get_margin_arg(7, 1),
        get_margin_arg(7),
        get_margin_arg(4),
        get_arg(1),
      ]);
      polygon(points=[
        get_arg(1),
        get_margin_arg(2, 1, 1),
        get_margin_arg(2, top=1),
        get_margin_arg(2),
        get_margin_arg(4, 1),
        get_margin_arg(0, 1, 1),
      ]);
      if (bottom) {
        polygon(points=[
          get_margin_arg(0),
          get_margin_arg(0, top=1),
          get_margin_arg(0, 1, 1),
          get_arg(1),
          get_margin_arg(2, 1, 1),
        ]);
      }
    }
  }
}

module frame_plate_notch() {
  translate(get_arg(1)) rotate(settings[1][2]) translate([-2, -printer_margin/2]) square([10, staggered_height+printer_margin]);
}

module frame_plate() {
  offset(1) offset(-1) {
    difference() {
      plate();
      offset(1) offset(-1) {
        offset(-frame_width) plate();
      }
      frame_plate_notch();
    }
  }
}

module frame_gutter() {
  difference() {
    offset(-frame_width+1+gasket_R) plate();
    offset(-frame_width+1) plate();
    frame_plate_notch();
  }
}

module frame() {
  difference() {
    linear_extrude(height=frame_thickness) {
      difference() {
        frame_plate();
        plate_joint_holes();
      }
    }
    #linear_extrude(height=gasket_shrinkage) {
      frame_gutter();
    }
  }
}

module mount(plate_thickness=mount_plate_thickness, rim_thickness=mount_rim_thickness, rim_z=mount_rim_z, right=true) {
  if (plate_thickness >= rim_thickness + rim_z) {
    hole_height = switch_rim_size() + printer_pitch;
    hole_width  = switch_rim_size() + printer_pitch;
    rim_hole_height = switch_bottom_height();
    rim_hole_width = switch_bottom_width();

    color("orange", 1) linear_extrude(height=plate_thickness) {
      difference() {
        plate();
        plate_joint_holes();
        // 0はマイコンの場所なので1~len-1
        for (i=[1:len(settings)-1]) {
          arg = settings[i];
          x = arg[0];
          y = arg[1];
          deg = arg[2];
          switch_vertical = arg[5];
          rotate(deg) {
            translate([x, y]) {
              staggerd_switch_holes(height=rim_hole_height, width=hole_width, unmount_pit=true, switch_vertical=switch_vertical);
            }
          }
        }
      }
    }

    z = right ? rim_z : 0;
    for (i=[1:len(settings)-1]) {
      arg = settings[i];
      x = arg[0];
      y = arg[1];
      deg = arg[2];
      switch_vertical = arg[5];
      rotate(deg) {
        translate([x, y, z]) {
          color("purple", 1) linear_extrude(height=rim_thickness) {
            difference() {
              staggerd_switch_holes(height=rim_hole_height, width=hole_width, switch_vertical=switch_vertical);
              staggerd_switch_holes(height=hole_height, width=rim_hole_width, switch_vertical=switch_vertical);
            }
          }
        }
      }
    }
  } else {
    echo(plate_thickness, ", ", rim_thickness, ", ", rim_z);
    echo(str("plate_thickness must larger than rim_thickness + rim_z: ", plate_thickness, "< ", rim_thickness + rim_z));
  }
}

module bottom_2d() {
  difference() {
    plate(bottom=true);
    staggered_holes(settings);
    plate_joint_holes();
  }
}

module bottom(dxf=false) {
  if (dxf) {
    bottom_2d();
  } else {
    color("gray", 0.9) {
      linear_extrude(height=bottom_plate_thickness) {
        bottom_2d();
      }
    }
  }
}

module cover() {
  difference() {
    offset(cover_round_off) offset(-cover_round_off) {
      // translate([-2, -1]) square([tile_size+2, staggered_height+2]);
      square([tile_size, staggered_height]);
    }
    #translate([settings[0][0], settings[0][1]]) translate(hole_coords(0, 1, height=tile_size)) hole();
    #translate([settings[0][0], settings[0][1]]) translate(hole_coords(1, 0, height=tile_size)) hole();
  }
}
