module motor_arm_creation(a, b, h, aero_grav_center) {
    all_pts = get_trailing_edge_points();
    
    
    //**************** Function **********//
        function interpolate_pt(p1, p2, target_z) =
        let (dz = p2[2] - p1[2], t = (target_z - p1[2]) / dz)
        [ p1[0] + t * (p2[0] - p1[0]), p1[1] + t * (p2[1] - p1[1]), target_z ];

        function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [ for (pr = pairs) if ((pr[0][2] <= target_z && target_z <= pr[1][2]) || (pr[1][2] <=        target_z && target_z <= pr[0][2])) pr ]
            )
            (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;
    
            
    //**************** Module **********//  


    
    translate([ aero_grav_center[1], 10, wing_root_mm+a])
        rotate([ 0, -90, 0 ])
            
            linear_extrude(height = h)
                scale([1, b/a])
                    circle(r = a, $fn=100); 
            

}