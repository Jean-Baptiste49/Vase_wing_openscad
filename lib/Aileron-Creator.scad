x_offset_aileron_cylinder_to_cube = 2.0; //As the hull an discontinuite assembling of cube, there is a tiny between the cylinder connecting the wing and the rest of the aileron. You can adjust the filling of this gap with this offset

module CreateAileronVoid() {
    all_pts = get_trailing_edge_points();

    function interpolate_pt(p1, p2, target_z) =
        let (
            dz = p2[2] - p1[2],
            t = (target_z - p1[2]) / dz
        )
        [
            p1[0] + t * (p2[0] - p1[0]),
            p1[1] + t * (p2[1] - p1[1]),
            target_z
        ];

    function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [
                for (pair = pairs)
                    if (
                        (pair[0][2] <= target_z && target_z <= pair[1][2]) ||
                        (pair[1][2] <= target_z && target_z <= pair[0][2])
                    ) pair
            ]
        )
        (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;

    pt_start = find_interpolated_point(aileron_start_z, all_pts);
    pt_end   = find_interpolated_point(aileron_end_z, all_pts);
    inner_pts = [for (pt = all_pts) if (pt[2] > aileron_start_z && pt[2] < aileron_end_z) pt];
    full_pts = concat(
        pt_start != undef ? [pt_start] : [],
        inner_pts,
        pt_end != undef ? [pt_end] : []
    );
    
    
    // Get the sweep angle between extrem point of ailerons
    sweep_angle_aileron = atan((full_pts[len(full_pts) - 1][0] - full_pts[0][0])/(full_pts[len(full_pts) - 1][2] -full_pts[0][2])); 
    
    

    if (len(full_pts) >= 2) {
        for (i = [0 : len(full_pts) - 2]) {
            pt1 = full_pts[i];
            pt2 = full_pts[i + 1];

            hull() {
                translate([pt1[0] - aileron_thickness - x_offset_aileron_cylinder_to_cube, pt1[1] - aileron_height / 2, pt1[2]])
                    cube([x_offset_aileron_cylinder_to_cube + aileron_thickness+1, aileron_height, 1], center = false);

                translate([pt2[0] - aileron_thickness-x_offset_aileron_cylinder_to_cube, pt2[1] - aileron_height / 2, pt2[2]-1]) // We withdraw 1 to stay in right dimension as the cube of z =1  is the extern limit 
                    cube([x_offset_aileron_cylinder_to_cube + aileron_thickness+1, aileron_height, 1.01], center = false);
            }
        }

        // Offset for adjusting cylinder to ailerons void
        offset_start = [ -aileron_thickness    , y_offset_aileron_to_wing, 0 ];
        offset_end   = [ -aileron_thickness + 1, y_offset_aileron_to_wing, 0 ];
        pt_start_cyl = [ pt_start[0] + offset_start[0], pt_start[1] + offset_start[1], pt_start[2] + offset_start[2] ];
        pt_end_cyl   = [ pt_end[0] + offset_end[0], pt_end[1] + offset_end[1], pt_end[2] + offset_end[2] ];

        color("red")
        if(use_custom_lead_edge_sweep) {
            half_cylinder_between_points_sweep(pt_start_cyl, pt_end_cyl, aileron_cyl_radius, cylindre_wing_dist_sweep);
        } else if (use_custom_lead_edge_sweep == false) {
            half_cylinder_between_points(pt_start_cyl, pt_end_cyl, aileron_cyl_radius, cylindre_wing_dist_nosweep);
        }        
    }
            
            // Pin hole 
            translate([
            full_pts[len(full_pts) - 1][0] - aileron_dist_LE_pin_center,        
            full_pts[len(full_pts) - 1][1] + y_offset_aileron_to_wing/2,  
            full_pts[len(full_pts) - 1][2]  
        ])
            rotate([ 0, sweep_angle_aileron, 0 ]){ //Spar angle rotation to follow the sweep

            cylinder(h = aileron_pin_hole_length, r = aileron_pin_hole_diameter/2, center = true);
            
            //cube use for access from extern layer to pin hole in vase mode
            //We use a side to join pin either extern mid and aileron layer cf rotate 90
            rotate([ 0, 0, 90 ])
                translate([ 0, 0, -aileron_pin_hole_length/2 ])
                    cube([ aileron_thickness, slice_gap_width, aileron_pin_hole_length ]);
            }
         

          
        
}


module Ailerons_pin_void(){

    void_offset_command_ailerons = 1.3;

    all_pts = get_trailing_edge_points();

    function interpolate_pt(p1, p2, target_z) =
        let (
            dz = p2[2] - p1[2],
            t = (target_z - p1[2]) / dz
        )
        [
            p1[0] + t * (p2[0] - p1[0]),
            p1[1] + t * (p2[1] - p1[1]),
            target_z
        ];

    function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [
                for (pair = pairs)
                    if (
                        (pair[0][2] <= target_z && target_z <= pair[1][2]) ||
                        (pair[1][2] <= target_z && target_z <= pair[0][2])
                    ) pair
            ]
        )
        (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;

    pt_start = find_interpolated_point(aileron_start_z, all_pts);
    pt_end   = find_interpolated_point(aileron_end_z, all_pts);
    inner_pts = [for (pt = all_pts) if (pt[2] > aileron_start_z && pt[2] < aileron_end_z) pt];
    full_pts = concat(
        pt_start != undef ? [pt_start] : [],
        inner_pts,
        pt_end != undef ? [pt_end] : []
    );
    
    
    // Get the sweep angle between extrem point of ailerons
    sweep_angle_aileron = atan((full_pts[len(full_pts) - 1][0] - full_pts[0][0])/(full_pts[len(full_pts) - 1][2] -full_pts[0][2])); 
    
    
           
        union(){    
            // Pin hole 
            translate([
            full_pts[len(full_pts) - 1][0] - aileron_dist_LE_pin_center,        
            full_pts[len(full_pts) - 1][1] + y_offset_aileron_to_wing/2,  
            full_pts[len(full_pts) - 1][2] ])
            
            rotate([ 0, sweep_angle_aileron, 0 ]){ //Spar angle rotation to follow the sweep

            cylinder(h = aileron_pin_hole_length, r = aileron_pin_hole_diameter/2, center = true);
            
            //cube use for access from extern layer to pin hole in vase mode
            //We use a side to join pin either extern mid and aileron layer cf rotate 90
            rotate([ 0, 0, 90 ])
                translate([ 0, 0, -aileron_pin_hole_length/2 ])
                    cube([ aileron_thickness, slice_gap_width, aileron_pin_hole_length ]);
            }
         
      
      
      // We withdraw the pin command hole to the aileron to avoid conflict with ribs
       translate([
            full_pts[0][0] - aileron_dist_LE_command_center,        
            full_pts[0][1] + y_offset_aileron_to_wing/2,  
            full_pts[0][2] + motor_arm_width - aileron_command_pin_void_length/2
        ])
    rotate([ 0, sweep_angle_aileron, 0 ]) //Spar angle rotation to follow the sweep
        union() {
            translate([-7.5,0,0])
            color("green")
            cylinder(h = aileron_command_pin_void_length*void_offset_command_ailerons, r = aileron_command_pin_b_radius*void_offset_command_ailerons);

            translate([7.5,0,0])
            color("green")
            cylinder(h = aileron_command_pin_void_length*void_offset_command_ailerons, r = aileron_command_pin_s_radius*void_offset_command_ailerons);

color("green")
            linear_extrude(height = aileron_command_pin_void_length*void_offset_command_ailerons)
            color("green")
                scale([void_offset_command_ailerons, void_offset_command_ailerons])
                    polygon(points=[[aileron_command_pin_width, -aileron_command_pin_s_radius], [aileron_command_pin_width, aileron_command_pin_s_radius], [-aileron_command_pin_width, aileron_command_pin_b_radius], [-aileron_command_pin_width, -aileron_command_pin_b_radius]]);
             
            translate([-aileron_dist_LE_command_center/4,-aileron_thickness,0])
                rotate([0,0,90])
                color("green")
                    cube([ aileron_thickness, slice_gap_width, aileron_command_pin_void_length*void_offset_command_ailerons ]); 
    }
      
      
        } // End of Union



}


module CreateAileron() {
    
    

    all_pts = get_trailing_edge_points();

    function interpolate_pt(p1, p2, target_z) =
        let (dz = p2[2] - p1[2], t = (target_z - p1[2]) / dz)
        [ p1[0] + t * (p2[0] - p1[0]), p1[1] + t * (p2[1] - p1[1]), target_z ];

    function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [ for (pr = pairs) if ((pr[0][2] <= target_z && target_z <= pr[1][2]) || (pr[1][2] <= target_z && target_z <= pr[0][2])) pr ]
        )
        (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;

    pt_start = find_interpolated_point(aileron_start_z + aileron_reduction, all_pts);
    pt_end   = find_interpolated_point(aileron_end_z - aileron_reduction, all_pts);
    create_aileron_thickness = aileron_thickness - aileron_reduction;
    inner_pts = [for (pt = all_pts) if (pt[2] > aileron_start_z && pt[2] < aileron_end_z) pt];
    full_pts = concat(pt_start != undef ? [pt_start] : [], inner_pts, pt_end != undef ? [pt_end] : []);
    
    
        // Get the sweep angle between extrem point of ailerons
    sweep_angle_aileron = atan((full_pts[len(full_pts) - 1][0] - full_pts[0][0])/(full_pts[len(full_pts) - 1][2] -full_pts[0][2])); 
    
    
    
    
    
    difference() {

    if (len(full_pts) >= 2) {
        for (i = [0 : len(full_pts) - 2]) {
            pt1 = full_pts[i]; pt2 = full_pts[i+1];

            hull() {
                translate([pt1[0] - create_aileron_thickness-x_offset_aileron_cylinder_to_cube, pt1[1] - aileron_height / 2, pt1[2]])
                    cube([x_offset_aileron_cylinder_to_cube + create_aileron_thickness, aileron_height, 0.1], center = false);
                translate([pt2[0] - create_aileron_thickness-x_offset_aileron_cylinder_to_cube, pt2[1] - aileron_height / 2, pt2[2]-1]) // We withdraw 1 to stay in right dimension as the cube of z =1  is the extern limit 
                    cube([x_offset_aileron_cylinder_to_cube + create_aileron_thickness, aileron_height, 1], center = false); 
            }
        }

        offset_start = [ -create_aileron_thickness, y_offset_aileron_to_wing, 0 ];
        offset_end   = [ -create_aileron_thickness + 1, y_offset_aileron_to_wing, 0 ];
        pt_start_cyl = [pt_start[0] + offset_start[0], pt_start[1] + offset_start[1], pt_start[2] + offset_start[2]];
        pt_end_cyl   = [pt_end[0]   + offset_end[0],   pt_end[1]   + offset_end[1],   pt_end[2]   + offset_end[2]];

        color("blue")
        if(use_custom_lead_edge_sweep) {
            half_cylinder_between_points_sweep(pt_start_cyl, pt_end_cyl, aileron_cyl_radius, cylindre_wing_dist_sweep);
        } else if (use_custom_lead_edge_sweep == false) {
            half_cylinder_between_points(pt_start_cyl, pt_end_cyl, aileron_cyl_radius, cylindre_wing_dist_nosweep);
        }
    }

        union(){
            // Pin hole 
            translate([
            full_pts[len(full_pts) - 1][0] - aileron_dist_LE_pin_center,        
            full_pts[len(full_pts) - 1][1] + y_offset_aileron_to_wing/2,  
            full_pts[len(full_pts) - 1][2]  
        ])
            rotate([ 0, sweep_angle_aileron, 0 ]){ //Spar angle rotation to follow the sweep
                cylinder(h = aileron_pin_hole_length, r = aileron_pin_hole_diameter/2, center = true);
                //cube use for access from extern layer to pin hole in vase mode
                //We use a side to join pin either extern mid and aileron layer cf rotate 90
                rotate([ 0, 0, 60 ])
                    translate([ 0, 0, -aileron_pin_hole_length/2 ])
                        cube([ aileron_thickness, slice_gap_width, aileron_pin_hole_length ]);
            }
         

         
            //Hole for the command part of ailerons 
    translate([
            full_pts[0][0] - aileron_dist_LE_command_center,        
            full_pts[0][1] + y_offset_aileron_to_wing/2,  
            full_pts[0][2] + motor_arm_width - aileron_command_pin_void_length/2
        ])
    rotate([ 0, sweep_angle_aileron, 0 ]) //Spar angle rotation to follow the sweep
        union() {
            translate([-7.5,0,0])
            cylinder(h = aileron_command_pin_void_length, r = aileron_command_pin_b_radius);

            translate([7.5,0,0])
            cylinder(h = aileron_command_pin_void_length, r = aileron_command_pin_s_radius);


            linear_extrude(height = aileron_command_pin_void_length)
                polygon(points=[[aileron_command_pin_width, -aileron_command_pin_s_radius], [aileron_command_pin_width, aileron_command_pin_s_radius], [-aileron_command_pin_width, aileron_command_pin_b_radius], [-aileron_command_pin_width, -aileron_command_pin_b_radius]]);
             
            translate([-aileron_dist_LE_command_center/4,-aileron_thickness,0])
                rotate([0,0,90])
                    cube([ aileron_thickness, slice_gap_width, aileron_command_pin_void_length ]); 
                
             
                
        }// End of Union  
      
   }//End of Union   
                  
    }//End of Difference

    

}

module half_cylinder_between_points(A, B, radius, distance_cyl_cube, extension = 20) {
    V = [B[0] - A[0], B[1] - A[1], B[2] - A[2]];
    h = norm(V);

    unit_V = [V[0]/h, V[1]/h, V[2]/h];

    // Extended Points
    A_ext = [
        A[0] - extension * unit_V[0] + distance_cyl_cube,
        A[1] - extension * unit_V[1],
        A[2] - extension * unit_V[2]
    ];

    B_ext = [
        B[0] + extension * unit_V[0] + distance_cyl_cube,
        B[1] + extension * unit_V[1],
        B[2] + extension * unit_V[2]
    ];

    V_ext = [B_ext[0] - A_ext[0], B_ext[1] - A_ext[1], B_ext[2] - A_ext[2]];
    h_ext = norm(V_ext);

    angle_z = atan2(V_ext[1], V_ext[0]);
    angle_y = acos(V_ext[2] / h_ext);

    intersection() {
    translate(A_ext)
        rotate([0, angle_y, angle_z])    
                intersection() {
                    // Full Cylinder
                    cylinder(h = h_ext, r = radius, center = false);

                    // Cut to get half cylinder
                    //translate([0, -2 * radius, 0])
                    //    cube([radius, 4 * radius, h_ext]);
                }

    // We cut the extremities of cylinder to get something fitting to ailerons on edge
    translate([-1000, -1000, A[2]])
    cube([2000, 2000, B[2]-A[2]]); 
 }               
}


module half_cylinder_between_points_sweep(A, B, radius, distance_cyl_cube, extension = 20) {
    V = [B[0] - A[0], B[1] - A[1], B[2] - A[2]];
    h = norm(V);

    unit_V = [V[0]/h, V[1]/h, V[2]/h];

    // Extended Points
    A_ext = [
        A[0] - extension * unit_V[0] + distance_cyl_cube +10,
        A[1] - extension * unit_V[1],
        A[2] - extension * unit_V[2]
    ];

    B_ext = [
        B[0] + extension * unit_V[0] + distance_cyl_cube +10,
        B[1] + extension * unit_V[1],
        B[2] + extension * unit_V[2]
    ];

    V_ext = [B_ext[0] - A_ext[0], B_ext[1] - A_ext[1], B_ext[2] - A_ext[2]];
    h_ext = norm(V_ext);

    angle_z = atan2(V_ext[1], V_ext[0]);
    angle_y = acos(V_ext[2] / h_ext);

    intersection() {
    translate(A_ext)
        rotate([0, angle_y, angle_z])    
                difference() {
                    // Full Cylinder
                    cylinder(h = h_ext, r = radius, center = false);

                    // Cut to get half cylinder
                    //translate([0, -2 * radius, 0])
                    //    cube([radius, 4 * radius, h_ext]);
                }

    // We cut the extremities of cylinder to get something fitting to ailerons on edge
    translate([-1000, -1000, A[2]])
    cube([2000, 2000, B[2]-A[2]]); 
 }           
}