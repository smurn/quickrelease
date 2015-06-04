plate_width=46.3+0.5;
plate_length = plate_width;
plate_bottom=5;
plate_lip=1;
plate_height=10;
plate_angle=55;
side_thickness=5;
base_thickness=4;

handle_radius = 25/2;
handle_clamp_distance=2;
handle_support_radius = 8;
handle_axis = -(handle_radius - handle_clamp_distance + plate_width/2 - (plate_height - plate_bottom) / tan(plate_angle));
handle_spacing=2;
handle_height=6;
handle_axis_r=8/2;

$fs=0.1;
$fa=2;

module counter_profile(thickness=5){
    y1 = plate_height - plate_bottom - plate_lip;
    x1 = y1 / tan(plate_angle);

    
    polygon(points=[
        [0,0],
        [0,plate_bottom],
        [-x1,plate_height-plate_lip],
        [-x1,plate_height],
        [thickness, plate_height],
        [thickness, 0]
    ], convexity=2);
}

module counter(length, thickness=5){
    translate([length+0.01,0,0])
    rotate([90,0,-90])
    linear_extrude(height=length+0.02,convexity=2)
    counter_profile();
}

module rim(){

    translate([plate_width/2,-plate_width/2,0])
    rotate([0,0,90])
    counter(plate_length, side_thickness);

    translate([-plate_width/2,plate_width/2,0])
    scale([1,-1,1])
    counter(plate_length, side_thickness);




    translate([-plate_width/2,-plate_width/2,0])
    rotate([0,0,90])
    scale([1,-1,1])
    counter(plate_length, side_thickness);
    
    translate([plate_width/2,plate_width/2,0])
    intersection(){
        //cylinder(r=side_thickness,h=plate_height);
        cube([side_thickness,side_thickness,plate_height]);
    }

    translate([-plate_width/2,plate_width/2,0])
    intersection(){
        //cylinder(r=side_thickness,h=plate_height);
        translate([-side_thickness,0,0])
        cube([side_thickness,side_thickness,plate_height]);
    }
}

module handle_support(){
        difference(){
            translate([handle_axis,0,-base_thickness]){
                cylinder(r=handle_support_radius + handle_spacing, h=plate_height - handle_height+base_thickness);
                translate([0,-handle_support_radius-handle_spacing,0])
                cube([100, 2*(handle_support_radius+handle_spacing), plate_height - handle_height+base_thickness]);
            }
            translate([-plate_width/2,-plate_width/2,-base_thickness-1])
            cube([100,100,plate_height - handle_height+base_thickness+2]);
        }
}

module handle_cutout(){
    translate([handle_axis,0,plate_height - handle_height]){
        cylinder(r=handle_radius + handle_spacing, h=handle_height+1);
        translate([-handle_radius-handle_spacing,-100,0])
        cube([2*(handle_radius+handle_spacing), 100, handle_height+1]);
    }
}

module base(){
    translate([-plate_width/2-side_thickness,-plate_width/2,-base_thickness])
    cube([plate_width+2*side_thickness, plate_width+side_thickness,base_thickness]);
}


difference(){
    union(){
        handle_support();
        base();
        rim();
    }
    handle_cutout();
    translate([handle_axis,0,-base_thickness-1])
    cylinder(r=handle_axis_r, h=100);
}