module center_part(aero_grav_center, ct_width, ct_length, ct_height){    


 
size = [ct_length, ct_width];    // Square size (X, Y)
radius = 3;         // Radius of rounded corners
tawaki_int_pin_rad = 1.25;
tawaki_ext_pin_rad = 2.9;
tawaki_pin_height = 10;
tawaki_pin_space_length = 30.2;
tawaki_pin_space_width = 30.2;

tawaki_esc_space = 90 + tawaki_pin_space_length;

esc_int_pin_rad = 1.25;
esc_ext_pin_rad = 3.15;
esc_pin_height = 5;
esc_pin_space_length = 32;
esc_pin_space_width = 30.7;

main_stage_y_width = 2*ct_height/3;

gravity_line_width = 1;
gravity_line_height = 0.2;

battery_width = 50;
battery_hole_width = 8;
battery_hole_length = 25;
battery_x_pos_1 = 100;
battery_x_pos_2 = 160;

rear_motor_int_circle_r = 4.75;
rear_motor_int_circ_attach_r = 1.5;
rear_motor_int_circ_attach_dist_to_ct = 8 + rear_motor_int_circ_attach_r;
rear_motor_square_support_attach_length = 32;
rear_motor_square_support_attach_width = 4;

// === Grid Parameters ===
// === Grid Parameters ===
front_offset = 5;
grid_width = 40;
grid_length = 210;
slot_width    = 5;     
slot_spacing  = 10;     
grid_angle    = 45;  
front_x_length = tawaki_pin_space_length - front_offset;
front_x_offset = front_offset + tawaki_pin_space_length/2 + front_x_length/2;  
front_x_width = tawaki_pin_space_width - 2*tawaki_ext_pin_rad; 
mid_x_length = 6*(tawaki_esc_space-tawaki_pin_space_length-2*tawaki_ext_pin_rad)/10;
mid_x_offset = tawaki_esc_space  - mid_x_length/2;
mid_x_width = ct_width - 15;
rear_x_length = rear_motor_square_support_attach_length;
rear_x_offset = tawaki_pin_space_length+2*tawaki_ext_pin_rad+ rear_x_length/2 + tawaki_esc_space + esc_ext_pin_rad;
rear_x_width = ct_width - 15;




    //**** Rear Motor Attach ****//
    rear_motor_attach();

    difference(){ //Difference for battery holder   
    
    difference(){ //Difference for the grid   
        main_stage_and_gravity_line();
        grid_center_part();
    
    } // End Difference for the grid   
     
    void_battery_holder();
    }// End of Difference for battery holder 
               
    //*** Tawaki ***//
    tawaki_pin_support();
    
    //*** ESC ***//
    esc_pin_support();

   
   
   
   
 
   
  
 
module main_stage_and_gravity_line(){

        union(){
        //Main stage support definition
        translate([ct_length/2,main_stage_y_width,-ct_width/2])
            rotate([90,0,0])
                linear_extrude(ct_height)
                    offset(r=radius)
                        offset(delta=-radius)
                            square([ct_length, ct_width], center=true);
                          
        //Draw CG Line on main stage up and bottom
        translate([aero_grav_center[1],main_stage_y_width,-ct_width])  
            color("red")
                cube([gravity_line_width,gravity_line_height, ct_width]);

        translate([aero_grav_center[1],main_stage_y_width - ct_height - gravity_line_height,-ct_width])  
            color("red")
                cube([gravity_line_width,gravity_line_height, ct_width]);
     } // End of union 1
} 


module grid_center_part(){

    union(){ //Union Object to withdraw
    //Front part under Tawaki
    render(convexity=5) // Use for simplification for calculation
    translate([front_x_offset,0,-center_width/2])
        rotate([90, 0, 0])
        difference() {
            // Principal part
            cube([front_x_length, front_x_width, 2*center_height], center = true);

            // Slot grid
            union(){ 
            rotate([0, 0, grid_angle])
                for (x = [-grid_length : slot_spacing : grid_length])
                    translate([x, 0, 0])
                        cube([slot_width, grid_width * 10, 2*center_height], center = true);
            }
        }

    //Mid part under Tawaki
    render(convexity=5) // Use for simplification for calculation
    translate([mid_x_offset,0,-center_width/2])
    rotate([90, 0, 0])
        difference() {
            // Principal part
            cube([mid_x_length, mid_x_width, 2*center_height], center = true);

            // Slot grid
            union(){ 
            rotate([0, 0, grid_angle])
                for (x = [-grid_length : slot_spacing : grid_length])
                    translate([x, 0, 0])
                        cube([slot_width, grid_width * 10, 2*center_height], center = true);
            }
        }
        
    //Rear part behind ESC
    render(convexity=5) // Use for simplification for calculation
    translate([rear_x_offset,0,-center_width/2])
        rotate([90, 0, 0])
            difference() {
                // Principal part
                cube([rear_x_length, rear_x_width, 2*center_height], center = true);

                // Slot grid
                union(){ 
                rotate([0, 0, grid_angle])
                    for (x = [-grid_length : slot_spacing : grid_length])
                        translate([x, 0, 0])
                            cube([slot_width, grid_width * 10, 2*center_height], center = true);
               }
            }

    }//End Union Object to withdraw
}


module void_battery_holder(){

     union(){ //Union for battery hole to attach to Center part

        translate([battery_x_pos_1,main_stage_y_width-2*ct_height,-ct_width/2 + battery_width/2])  
            color("green")
                    cube([battery_hole_length,4*ct_height, battery_hole_width]);

        translate([battery_x_pos_1,main_stage_y_width-2*ct_height,-ct_width/2 - battery_hole_width - battery_width/2])  
            color("green")
                    cube([battery_hole_length,4*ct_height, battery_hole_width]);
                    
        translate([battery_x_pos_2,main_stage_y_width-2*ct_height,-ct_width/2 + battery_width/2])  
            color("green")
                    cube([battery_hole_length,4*ct_height, battery_hole_width]);

        translate([battery_x_pos_2,main_stage_y_width-2*ct_height,-ct_width/2 - battery_hole_width - battery_width/2])  
            color("green")
                    cube([battery_hole_length,4*ct_height, battery_hole_width]);      
      
     }// End of union 2

}


module tawaki_pin_support(){

//Tawaki pin support definition 1                
    translate([tawaki_ext_pin_rad,main_stage_y_width + tawaki_pin_height,-ct_width/2-tawaki_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = tawaki_pin_height, r = tawaki_ext_pin_rad, center = false);
                    cylinder(h = tawaki_pin_height, r = tawaki_int_pin_rad, center = false);
                }
    //Tawaki pin support definition 2                
    translate([tawaki_ext_pin_rad,main_stage_y_width + tawaki_pin_height,-ct_width/2+tawaki_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = tawaki_pin_height, r = tawaki_ext_pin_rad, center = false);
                    cylinder(h = tawaki_pin_height, r = tawaki_int_pin_rad, center = false);
                }                
    //Tawaki pin support definition 3                
    translate([tawaki_ext_pin_rad + tawaki_pin_space_length,main_stage_y_width + tawaki_pin_height,-ct_width/2-tawaki_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = tawaki_pin_height, r = tawaki_ext_pin_rad, center = false);
                    cylinder(h = tawaki_pin_height, r = tawaki_int_pin_rad, center = false);
                }                
    //Tawaki pin support definition 4                
    translate([tawaki_ext_pin_rad + tawaki_pin_space_length,main_stage_y_width + tawaki_pin_height,-ct_width/2+tawaki_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = tawaki_pin_height, r = tawaki_ext_pin_rad, center = false);
                    cylinder(h = tawaki_pin_height, r = tawaki_int_pin_rad, center = false);
                }

}


module esc_pin_support(){

//ESC pin support definition 1                
    translate([tawaki_esc_space + esc_ext_pin_rad,main_stage_y_width + esc_pin_height,-ct_width/2-esc_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = esc_pin_height, r = esc_ext_pin_rad, center = false);
                    cylinder(h = esc_pin_height, r = esc_int_pin_rad, center = false);
                }
    //ESC pin support definition 2                
    translate([tawaki_esc_space + esc_ext_pin_rad,main_stage_y_width + esc_pin_height,-ct_width/2+esc_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = esc_pin_height, r = esc_ext_pin_rad, center = false);
                    cylinder(h = esc_pin_height, r = esc_int_pin_rad, center = false);
                }                
    //ESC pin support definition 3                
    translate([tawaki_esc_space + esc_ext_pin_rad + esc_pin_space_length,main_stage_y_width + esc_pin_height,-ct_width/2-esc_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = esc_pin_height, r = esc_ext_pin_rad, center = false);
                    cylinder(h = esc_pin_height, r = esc_int_pin_rad, center = false);
                }                
    //ESC pin support definition 4                
    translate([tawaki_esc_space + esc_ext_pin_rad + esc_pin_space_length,main_stage_y_width + esc_pin_height,-ct_width/2+esc_pin_space_width/2])
        rotate([90,0,0])                    
            color("grey")
                difference(){
                    cylinder(h = esc_pin_height, r = esc_ext_pin_rad, center = false);
                    cylinder(h = esc_pin_height, r = esc_int_pin_rad, center = false);
                }   

}


module rear_motor_attach(){

    translate([ct_length - rear_motor_square_support_attach_width,main_stage_y_width,-ct_width/2+ rear_motor_square_support_attach_length/2])
        rotate([0,180,0])
        linear_extrude(height = rear_motor_square_support_attach_width)
        polygon(points=[[0, 0], [0, rear_motor_square_support_attach_length], [rear_motor_square_support_attach_length, 0]]);

    translate([ct_length - rear_motor_square_support_attach_width,main_stage_y_width,-ct_width/2- rear_motor_square_support_attach_length/2+rear_motor_square_support_attach_width])
        rotate([0,180,0])
        linear_extrude(height = rear_motor_square_support_attach_width)
        polygon(points=[[0, 0], [0, rear_motor_square_support_attach_length], [rear_motor_square_support_attach_length, 0]]);

        

    translate([ct_length - rear_motor_square_support_attach_width,main_stage_y_width + rear_motor_square_support_attach_length/2,-ct_width/2])
        rotate([0,90,0])
    difference(){
        linear_extrude(rear_motor_square_support_attach_width)
            square([rear_motor_square_support_attach_length, rear_motor_square_support_attach_length], center=true);
            
        linear_extrude(rear_motor_square_support_attach_width){
        circle(r = rear_motor_int_circle_r); //hole for rear motor tree passage

        translate([rear_motor_int_circ_attach_dist_to_ct,0,0]){//Hole for screwing the rear motor
            translate([-rear_motor_int_circ_attach_r,0,0]) 
            circle(r = rear_motor_int_circ_attach_r);     
            translate([rear_motor_int_circ_attach_r,0,0]) 
            circle(r = rear_motor_int_circ_attach_r);       
            square([2*rear_motor_int_circ_attach_r, 2*rear_motor_int_circ_attach_r], center=true);
        }     
                   
        translate([-rear_motor_int_circ_attach_dist_to_ct,0,0]){//Hole for screwing the rear motor
            translate([-rear_motor_int_circ_attach_r,0,0]) 
            circle(r = rear_motor_int_circ_attach_r);     
            translate([rear_motor_int_circ_attach_r,0,0]) 
            circle(r = rear_motor_int_circ_attach_r);       
            square([2*rear_motor_int_circ_attach_r, 2*rear_motor_int_circ_attach_r], center=true);
        }         
         
        translate([0,rear_motor_int_circ_attach_dist_to_ct,0]){//Hole for screwing the rear motor
            rotate([0,0,90]){
                translate([-rear_motor_int_circ_attach_r,0,0]) 
                circle(r = rear_motor_int_circ_attach_r);     
                translate([rear_motor_int_circ_attach_r,0,0]) 
                circle(r = rear_motor_int_circ_attach_r);       
                square([2*rear_motor_int_circ_attach_r, 2*rear_motor_int_circ_attach_r], center=true);
            }
        }   

        translate([0,-rear_motor_int_circ_attach_dist_to_ct,0]){//Hole for screwing the rear motor
            rotate([0,0,90]){
                translate([-rear_motor_int_circ_attach_r,0,0]) 
                circle(r = rear_motor_int_circ_attach_r);     
                translate([rear_motor_int_circ_attach_r,0,0]) 
                circle(r = rear_motor_int_circ_attach_r);       
                square([2*rear_motor_int_circ_attach_r, 2*rear_motor_int_circ_attach_r], center=true);
            }
        }  

        }// End of Linear Extrude
    } // End of difference
}


 
}    