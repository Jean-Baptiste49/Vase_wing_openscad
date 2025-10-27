
module Create_winglet(cube_for_vase = false)
{
    
    points_le = get_leading_edge_points();
    z_pos = wing_root_mm + wing_mid_mm + motor_arm_width;
    manual_rounding = 3;
    cube_for_vase_y1 = attached_1_radius*10;
    cube_for_vase_z1 = attached_1_length;
    cube_for_vase_y2 = attached_2_radius*10;
    cube_for_vase_z2 = attached_2_length;    

    
    
  
    function interpolate_pt(p1, p2, target_z) =
        let (dz = p2[2] - p1[2], t = (target_z - p1[2]) / dz)
        [ p1[0] + t * (p2[0] - p1[0]), p1[1] + t * (p2[1] - p1[1]), target_z ];

    function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [ for (pr = pairs) if ((pr[0][2] <= target_z && target_z <= pr[1][2]) || (pr[1][2] <= target_z && target_z <= pr[0][2])) pr ]
        )
        (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;

    pt_start = find_interpolated_point(z_pos, points_le);
    
    module winglet_shape() {
        polygon(points=[
            [0, 0], 
            [base_length + winglet_rear_bottom_offset, 0], 
            [base_length + winglet_rear_up_offset, winglet_height], 
            [2 * base_length / 3, winglet_height]
        ]);
    }
   
   intersection(){
    union() {
    
    translate([pt_start[0]-winglet_x_pos,winglet_y_pos,z_pos])
        color("orange")   
          linear_extrude(height = winglet_width)
            offset(r = corner_radius)
                offset(delta = -corner_radius)
                    winglet_shape(); 
                
      

    p1 = [pt_start[0]-winglet_x_pos, winglet_y_pos, z_pos];
    p2 = [pt_start[0]-winglet_x_pos + 2 * base_length / 3, winglet_y_pos+ winglet_height, z_pos];      
    
    dx = p2[0] - p1[0];
    dy = p2[1] - p1[1];
    dz = p2[2] - p1[2];
    distance = sqrt(dx*dx + dy*dy + dz*dz);
    angle = atan2(dy, dx);
    mid = [ (p1[0] + p2[0])/2, (p1[1] + p2[1])/2, z_pos + winglet_width / 2 ];
    
    translate(mid)
        rotate([0, 90, angle])
            color("orange")
                cylinder(h=distance+1, r=winglet_width/2, center=true);
                
                
    p3 = [pt_start[0]-winglet_x_pos + 2 * base_length / 3, winglet_y_pos+ winglet_height, z_pos];  
    p4 = [pt_start[0]-winglet_x_pos + base_length+ winglet_rear_up_offset, winglet_y_pos + winglet_height, z_pos];    
    
    dx2 = p4[0] - p3[0];
    dy2 = p4[1] - p3[1];
    dz2 = p4[2] - p3[2];
    distance2 = sqrt(dx2*dx2 + dy2*dy2 + dz2*dz2);
    angle2 = atan2(dy2, dx2);
    mid2 = [ (p3[0] + p4[0])/2, (p3[1] + p4[1])/2, z_pos + winglet_width / 2 ];
    
    translate(mid2)
        rotate([0, 90, angle2])
            color("orange")
                cylinder(h=distance2, r=winglet_width/2, center=true);   
    }// End of Union
   
    union(){
        translate([pt_start[0]-winglet_x_pos + 2.5*manual_rounding, winglet_y_pos+2*manual_rounding , z_pos+ winglet_width])
            rotate([180,0,0])
                color("orange") 
                    cylinder(h = winglet_width, r = 2.5*manual_rounding, center = false); 
                    
        translate([pt_start[0]-winglet_x_pos + 6*manual_rounding/2, winglet_y_pos, z_pos])          
            cube([50*base_length,2*winglet_height,winglet_width]);  
    }// End of Union
    
    }// End of intersection
    
    
    translate([pt_start[0]-attached_1_x_pos,attached_1_y_pos,z_pos+1]){
        rotate([180,sweep_angle,0])
            color("green") 
            if(cube_for_vase){ // In vase mode, we create the hole in the mid part, we therefore offset the hole to avoid too tight junction 
                cylinder(h = attached_1_length, r = attached_1_radius*winglet_attach_dilatation_offset_PLA, center = false);
            }
            else {
                 cylinder(h = attached_1_length, r = attached_1_radius, center = false);
            }
                
            if(cube_for_vase){
                rotate([0,sweep_angle,0])
                    translate([0,0,-cube_for_vase_z1])
                        color("green")   
                            cube([slice_gap_width,cube_for_vase_y1,cube_for_vase_z1]);
                 }
               
                }                
            
    translate([pt_start[0]-attached_2_x_pos,attached_2_y_pos,z_pos + 1]){
        rotate([180,sweep_angle,0])
            color("green") 
            if(cube_for_vase){   // In vase mode, we create the hole in the mid part, we therefore offset the hole to avoid too tight junction         
                cylinder(h = attached_2_length, r = attached_2_radius*winglet_attach_dilatation_offset_PLA, center = false);
            }
            else {
                 cylinder(h = attached_2_length, r = attached_2_radius, center = false);
            }
            
            if(cube_for_vase){
                rotate([0,sweep_angle,0])    
                    translate([0,0,-cube_for_vase_z2])
                        color("green")   
                            cube([slice_gap_width,cube_for_vase_y2,cube_for_vase_z2]);
                 }
                }                

}

module Create_winglet_void()
{

    points_le = get_leading_edge_points();
    z_pos = wing_root_mm + wing_mid_mm + motor_arm_width;
    manual_rounding = 3;
   
    
    
  
    function interpolate_pt(p1, p2, target_z) =
        let (dz = p2[2] - p1[2], t = (target_z - p1[2]) / dz)
        [ p1[0] + t * (p2[0] - p1[0]), p1[1] + t * (p2[1] - p1[1]), target_z ];

    function find_interpolated_point(target_z, pts) =
        let (
            pairs = [for (i = [0 : len(pts) - 2]) [pts[i], pts[i+1]]],
            valid = [ for (pr = pairs) if ((pr[0][2] <= target_z && target_z <= pr[1][2]) || (pr[1][2] <= target_z && target_z <= pr[0][2])) pr ]
        )
        (len(valid) > 0) ? interpolate_pt(valid[0][0], valid[0][1], target_z) : undef;

    pt_start = find_interpolated_point(z_pos, points_le);

    translate([pt_start[0]-attached_1_x_pos,attached_1_y_pos,z_pos+1])
        rotate([180,sweep_angle,0])
            color("green") 
                cylinder(h = attached_1_length*winglet_attach_dilatation_offset_PLA, r = attached_1_radius*winglet_attach_dilatation_offset_PLA, center = false);

            
    translate([pt_start[0]-attached_2_x_pos,attached_2_y_pos,z_pos+1])
        rotate([180,sweep_angle,0])
            color("green") 
                cylinder(h = attached_2_length*winglet_attach_dilatation_offset_PLA, r = attached_2_radius*winglet_attach_dilatation_offset_PLA, center = false);  

                
                
}