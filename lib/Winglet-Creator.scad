

module Create_winglet()
{
    
    points_le = get_leading_edge_points();
    z_pos = wing_root_mm + wing_mid_mm + motor_arm_width;
    
    
  
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
            [base_length, 0], 
            [base_length + winglet_rear_offset, winglet_height], 
            [2 * base_length / 3, winglet_height]
        ]);
    }
   
       
    translate([pt_start[0]-winglet_x_pos,winglet_y_pos,z_pos])
        color("orange")   
          linear_extrude(height = winglet_width)
            offset(r = corner_radius)
                offset(delta = -corner_radius)
                    winglet_shape(); 
                
    translate([pt_start[0]-attached_1_x_pos,attached_1_y_pos,z_pos])
        rotate([180,0,0])
            color("green") 
                cylinder(h = attached_1_length, r = attached_1_radius, center = false);
            
    translate([pt_start[0]-attached_2_x_pos,attached_2_y_pos,z_pos])
        rotate([180,0,0])
            color("green") 
                cylinder(h = attached_2_length, r = attached_2_radius, center = false);
      

    p1 = [pt_start[0]-winglet_x_pos, winglet_y_pos, z_pos];
    p2 = [pt_start[0]-winglet_x_pos + 2 * base_length / 3, winglet_y_pos+ winglet_height, z_pos];      
    
    dx = p2[0] - p1[0];
dy = p2[1] - p1[1];
angle = atan2(dy, dx);
mid = [ (p1[0] + p2[0])/2, (p1[1] + p2[1])/2, z_pos + winglet_width / 2 ];
translate(p1)
    rotate([0, 90, angle])  // oriente le cylindre pour qu’il soit perpendiculaire au bord
        color("blue")
            cylinder(h=10, r=2, center=true);  // extrusion en hauteur (normale au plan)

}