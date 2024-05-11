include <wings.scad>;

$vpd = 305;
$vpr = [0, 0, 0];
$vpt = [60, 40, 0];

// DMM.makeでPA11 MJFを指定する際のマージン
shell_margin = 5.0;

translate([21, 42]) {
  // %pcb();
  mount(right=false);
  translate([0, 0, shell_margin + mount_plate_thickness]) mount();
}
