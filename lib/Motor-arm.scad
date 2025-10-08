module motor_arm(a_ellipse, b_ellipse, arm_length, motor_height, arm_tilt_angle, arm_screw_fit_offset, aero_grav_center, back = false, front = false, full = true) {
   
    
    //**************** Parameters **********//
    y_offset = 10;
    trim_plan_dim = 100;
    screw_hole_motor_arm_offset = 3.7;
    screw_hole_1 = 3;
    screw_hole_2 = 1.5;
    motor_footprint_long = 9.5;
    motor_footprint_short = 8;
    dummy_motor_base_radius = 9.5;
    dummy_motor_base_height = 20;
    motor_support_scale = 1.8;
    dummy_helix_radius = 152.4; //6 inch
    dummy_helix_height = 20;
    x_pos_screw_long = cos(45) * (motor_footprint_long );
    y_pos_screw_long = sin(45) * (motor_footprint_long );
    x_pos_screw_short = cos(45) * (motor_footprint_short );
    y_pos_screw_short = sin(45) * (motor_footprint_short );    
    
    
    //Echo lock parameters
    alpha = 15;
    width = a_ellipse ; 
    taper_angle = 1.5;
    piece_height = 4*b_ellipse;
    offset_clearance = 0.95;
    
        
    width_w_clearance = width * offset_clearance;
    lock_length = 1.52  * width;
    lock_length_2_start = 0.57 *width;
    lock_length_2_stop = 0.8 *width;
    lock_length_2_height = lock_length_2_stop - lock_length_2_start;
    //**************** End Parameters **********//
    
    
    difference() // Difference front / back / full
    { 
    union(){ //Union for whole arm
        
    difference() // Difference for trim, screw holes
    {  
        union(){
    // Draw the arm
    translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
        rotate([ 0, -90, 0 ])
            
            linear_extrude(height = 2*arm_length)
                scale([1, b_ellipse/a_ellipse])
                    circle(r = a_ellipse, $fn=100); 
            
    //**************** Front arm **********//
    //Draw connexion arm to motor support
    translate([ aero_grav_center[1] - arm_length, y_offset, wing_root_mm+a_ellipse])
        scale([1, b_ellipse/a_ellipse])
           sphere(a_ellipse, $fn=100 );

    // Draw the motor support
    translate([ aero_grav_center[1] - arm_length, y_offset, wing_root_mm+a_ellipse])
        rotate([ 0, 90, 90 ])
            linear_extrude(height = motor_height+b_ellipse, scale = motor_support_scale)
                circle(r = a_ellipse, $fn=100);

    //**************** Back arm **********//
    //Draw connexion arm to motor support
    translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
        scale([1, b_ellipse/a_ellipse])
           sphere(a_ellipse, $fn=100 );

    // Draw the motor support
    translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
        rotate([ 0, 90, 90 ])
            linear_extrude(height = motor_height+b_ellipse, scale = motor_support_scale)
                circle(r = a_ellipse, $fn=100);
                
        }
    
    
    union(){    
    //**************** Front arm **********//   
    //Draw trim plan
    translate([ aero_grav_center[1] - arm_length -trim_plan_dim/2, y_offset + b_ellipse + motor_height , wing_root_mm+a_ellipse - trim_plan_dim/2 ]) {
            rotate([ arm_tilt_angle, 0, 0]) {
        
        cube([ trim_plan_dim, trim_plan_dim, trim_plan_dim ]);
    
    //Screw hole position           
    translate([trim_plan_dim/2 +y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Sphere hole position  
    translate([trim_plan_dim/2 , 0, arm_screw_fit_offset + trim_plan_dim/2 ])
        sphere(r=4.25, $fn=100 );
        
      
    }//End of tilt rotation
    }//End translate of trim 
 



    //**************** Back arm **********//    
    //Draw trim plan
    translate([ aero_grav_center[1] + arm_length -trim_plan_dim/2, y_offset + b_ellipse + motor_height , wing_root_mm+a_ellipse - trim_plan_dim/2 ]) {
            rotate([ arm_tilt_angle, 0, 0]) {
        
        cube([ trim_plan_dim, trim_plan_dim, trim_plan_dim ]);
    
    //Screw hole position           
    translate([trim_plan_dim/2 +y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Sphere hole position  
    translate([trim_plan_dim/2 , 0, arm_screw_fit_offset + trim_plan_dim/2 ])
        sphere(r=4.25, $fn=100 );
        
      
    }//End of tilt rotation
    }//End translate of trim 
    
    
    
    }//End of 2nd Union
 
 
    
    }//End of difference       
//
        if(dummy_motor){
    translate([ aero_grav_center[1] + arm_length, y_offset + motor_height, wing_root_mm+a_ellipse])
        rotate([ 0, 90 - arm_tilt_angle, 90 ])
            union(){
            color("red")
                linear_extrude(height = dummy_motor_base_height)
                    circle(r = dummy_motor_base_radius, $fn=100);
            
             translate([ 0, 0, dummy_motor_base_height])    
                color("green")
                    linear_extrude(height = dummy_helix_height)
                        circle(r = dummy_helix_radius, $fn=100);   
            }

    translate([ aero_grav_center[1] - arm_length, y_offset + motor_height, wing_root_mm+a_ellipse])
        rotate([ 0, 90 - arm_tilt_angle, 90 ])
            union(){
            color("red")
                linear_extrude(height = dummy_motor_base_height)
                    circle(r = dummy_motor_base_radius, $fn=100);
            
             translate([ 0, 0, dummy_motor_base_height])    
                color("green")
                    linear_extrude(height = dummy_helix_height)
                        circle(r = dummy_helix_radius, $fn=100);   
            }
            
            
        } // End dummy_motor


        
    } //End Union for whole arm
      
  
    //**************** Difference part to cut the arm in 2 pieces **********//
    if(front){
        union(){
            translate([ aero_grav_center[1] , -motor_arm_length, wing_root_mm - motor_arm_length])
                cube([ 2*motor_arm_length, 2*motor_arm_length, 2*motor_arm_length ]);
          
            //Echo lock attach remove piece on front arm
            translate([ aero_grav_center[1], -y_offset-b_ellipse, wing_root_mm+a_ellipse]){
                rotate([ -90, 90, 0 ]){           
                    color("blue")
                        linear_extrude(height=piece_height, scale = 1.2) 
                            polygon(points=[[-width/2,-lock_length_2_start/2], [width/2,-lock_length_2_start/2], [(width/2 + lock_length_2_height * tan(alpha)), lock_length_2_stop/2], [-width/2-lock_length_2_height * tan(alpha),lock_length_2_stop/2]]);  
                }// rotate
            }// End translate
        }//End union
    }// End if



    if(back){
        union(){
            translate([ aero_grav_center[1] - 2*motor_arm_length , -motor_arm_length, wing_root_mm - motor_arm_length])
                cube([ 2*motor_arm_length, 2*motor_arm_length, 2*motor_arm_length ]);

            //Echo lock attach remove piece on front arm
            translate([ aero_grav_center[1], -y_offset-b_ellipse, wing_root_mm+a_ellipse]){
                rotate([ -90, 90, 0 ]){           
                    color("red")
                        linear_extrude(height=piece_height, scale = 0.8)         
                polygon(points=[[-width/2,-lock_length/2], [width/2,-lock_length/2], [(width/2 - lock_length * tan(alpha)), lock_length/2], [- width/2 +lock_length * tan(alpha),lock_length/2]]); //You center you piece on zero to apply a scale (tapering) in the center of the piece
                }// rotate
            }// End translate        
        }//End union
    }// End if    
    
}// Difference front / back / full
     
    //**************** Echo lock attach **********//  
    if(front){
        
        intersection(){  //Intersection to clean the edge of echo lock
        
            translate([ aero_grav_center[1] - (1-offset_clearance), -y_offset-b_ellipse, wing_root_mm+a_ellipse]){
                rotate([ -90, 90, 0 ]){  
              color("red")
                linear_extrude(height=piece_height, scale = 0.8)         
                    polygon(points=[[-width_w_clearance/2,-lock_length/2], [width_w_clearance/2,-lock_length/2], [(width_w_clearance/2 - lock_length * tan(alpha)), lock_length/2], [- width_w_clearance/2 +lock_length * tan(alpha),lock_length/2]]); //You center you piece on zero to apply a scale (tapering) in the center of the piece
                }    
            }//End translate
                   
            translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
                rotate([ 0, -90, 0 ])           
                    linear_extrude(height = 2*arm_length)
                        scale([1, b_ellipse/a_ellipse])
                            circle(r = a_ellipse, $fn=100); 
            
        }//End Intersection
    }// End if       

    if(back){
        
        intersection(){  //Intersection to clean the edge of echo lock
            
            difference(){          
                translate([ aero_grav_center[1] - (1-offset_clearance), -y_offset-b_ellipse, wing_root_mm+a_ellipse]){
                    rotate([ -90, 90, 0 ]){      
                        color("blue")
                            linear_extrude(height=piece_height, scale = 1.2) 
                                polygon(points=[[-width_w_clearance/2,-lock_length_2_start/2], [width_w_clearance/2,-lock_length_2_start/2], [(width_w_clearance/2 + lock_length_2_height * tan(alpha)), lock_length_2_stop/2], [-width_w_clearance/2-lock_length_2_height * tan(alpha),lock_length_2_stop/2]]);
                    }    
                }
                
                translate([ aero_grav_center[1], -y_offset-b_ellipse, wing_root_mm+a_ellipse]){
                rotate([ -90, 90, 0 ]){      
              color("red")
                linear_extrude(height=piece_height, scale = 0.8)         
                    polygon(points=[[-width/2,-lock_length/2], [width/2,-lock_length/2], [(width/2 - lock_length * tan(alpha)), lock_length/2], [- width/2 +lock_length * tan(alpha),lock_length/2]]); //You center you piece on zero to apply a scale (tapering) in the center of the piece
                }    
            }
            }//End difference
              
            
            translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
                rotate([ 0, -90, 0 ])           
                    linear_extrude(height = 2*arm_length)
                        scale([1, b_ellipse/a_ellipse])
                            circle(r = a_ellipse, $fn=100); 
            
        }//End Intersection        
        
        
    }// End if               
          


}
