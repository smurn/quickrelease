include <elipticcylinder.scad>;

max_r = 25/2;
clamp_distance=2;
angle=55;
thickness=6;
length=40;
handle_thickness = 3;

hole_r1=8/2;
hole_r2=10/2;


min_r = max_r-thickness/tan(angle);



module clamp_head(){
    intersection(){
        eliptic_cylinder(thickness, min_r,min_r-clamp_distance,0,  max_r,max_r-clamp_distance,0,  360);
        translate([-min_r,-max_r,-1])
        cube([2*max_r, 2*max_r, thickness+2]);
    }
}

module handle(){
    scale_factor = (min_r-clamp_distance) / min_r;
    ay = -length / scale_factor;
    br = min_r;
    w = handle_thickness-min_r;
    handle_bend_r = (br*br - w*w - ay*ay) / (2*w - 2*br);

    ax = handle_bend_r + w;
    
    touch_x = ax * br / (br + handle_bend_r);
    touch_y = ay * br / (br + handle_bend_r);
    
    linear_extrude(height=thickness)
    difference(){
        union(){
            translate([-min_r+handle_thickness/2,-length+handle_thickness, 0])
            circle(handle_thickness/2);
            translate([-min_r,-length+handle_thickness, 0])
            square([2*min_r, length+touch_y-handle_thickness]);
            scale([1,scale_factor,1])
            circle(min_r);
            translate([-min_r,-length+handle_thickness, 0])
            square([handle_thickness, length-handle_thickness]);
        }
        translate([handle_bend_r+handle_thickness-min_r,-length])
        scale([1,scale_factor,1])
        circle(handle_bend_r, $fn=2*360);
    }
    
    
}

module complete(){
    difference(){
        union(){
            clamp_head();
            handle();
        }
        translate([0,0,-0.005])
        cylinder(r1=hole_r1, r2=hole_r2, h=thickness+0.01, $fn=2*36);
    }
}

complete();