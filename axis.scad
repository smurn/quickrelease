handle_axis_r=8/2;
handle_axis_top_r=10/2;
handle_thickness=6;
clamp_base_thickness=4;
plate_height=10;

axis_height=plate_height+clamp_base_thickness-handle_thickness;

translate([0,0,axis_height])
cylinder(r1=handle_axis_r, r2=handle_axis_top_r, h=handle_thickness, $fn=36);
cylinder(r=handle_axis_r, h=axis_height, $fn=36);