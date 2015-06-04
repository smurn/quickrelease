$fn=36;

//eliptic_cylinder(5, 20,10,20,  5,7,-40);


module eliptic_cylinder(height, major1, minor1, rotation1, major2, minor2, rotation2, segments=$fn){

    for(segment=[0:segments-1]){
        eliptic_cylinder_segment(height, major1, minor1, rotation1, major2, minor2, rotation2, 360*segment / segments, 360*(segment+1) / segments);
    }
}

function rotate_point(x, angle) = [x[0]*cos(angle) - x[1]*sin(angle), x[0]*sin(angle) + x[1]*cos(angle), x[2]];

module eliptic_cylinder_segment(height, major1, minor1, rotation1, major2, minor2, rotation2, from, to){
    x1f = cos(from-rotation1)*major1;
    y1f = sin(from-rotation1)*minor1;
    x1t = cos(to-rotation1)*major1;
    y1t = sin(to-rotation1)*minor1;
    
    x2f = cos(from-rotation2)*major2;
    y2f = sin(from-rotation2)*minor2;
    x2t = cos(to-rotation2)*major2;
    y2t = sin(to-rotation2)*minor2;
    
    
    from1 = [x1f, y1f, 0];
    from2 = [x2f, y2f, height];
    to1 = [x1t, y1t, 0];
    to2 = [x2t, y2t, height];
    
    
    to1_rot = rotate_point(to1, rotation1);
    from1_rot = rotate_point(from1, rotation1);
    to2_rot = rotate_point(to2, rotation2);
    from2_rot = rotate_point(from2, rotation2);
    
    polyhedron(points = [
        [0,0,0],
        from1_rot,
        to1_rot,
        [0,0,height],
        from2_rot,
        to2_rot
    ], 
    faces = [
    
        [0, 4, 1],
        [0, 3, 4],
        [4,2,1],
        [4,5,2],
        [0,2,5],
        [0,5,3],
        [3,5,4],
        [0,1,2]
    
    ], convexity = 1);
}


