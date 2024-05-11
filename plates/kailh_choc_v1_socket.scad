// ref. https://drive.google.com/file/d/1-e0rFtCW9m_soP8Karuuz1jSttS8NSBB/view

$fn = 30;
$vpd = 305;
$vpt = [40, 30, 0];
$vpr = [0, 0, 0];

height = 13.15;
width = 6.85;

base_height = 9.55;
base_thickness = 3.05;
base_block_thickness = 1.80;
base_block_1_height = 4.75;
base_block_2_height = base_height - base_block_1_height;
base_block_width = 4.65;
base_connector_R = 2.90;
base_connector_space_height = 5.00;

connector_thickness = 1.85;
connector_height = (height - base_height) / 2;
connector_width = 1.68;

module base_connector() {
  cylinder(r=base_connector_R/2, h=base_thickness-base_block_thickness);
}

module base() {
  linear_extrude(height=base_block_thickness) {

    square(size=[base_block_width, base_block_1_height], center=true);
    translate([width - base_block_width, base_block_1_height]) square(size=[base_block_width, base_block_2_height], center=true);
  }
  translate([0, 0, base_block_thickness]) #base_connector();
  #translate([width - base_block_width, base_block_1_height, base_block_thickness]) base_connector();
}

module connector() {
  linear_extrude(height=connector_thickness) {
    square(size=[connector_width, connector_height], center=true);
  }
}

module socket() {
  rotate([0, 0, -90]) {
    base();
    translate([0, - (base_block_1_height + connector_height)/2]) #connector();
    translate([width - base_block_width, base_height - (base_block_2_height - connector_height)/2]) #connector();
  }
}

function socket_base_height() = base_height;

socket();
