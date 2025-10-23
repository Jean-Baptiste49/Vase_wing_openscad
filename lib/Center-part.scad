module center_part(aero_grav_center, ct_width, ct_length, ct_height){    


 
size = [ct_length, ct_width];    // Square size (X, Y)
radius = 3;         // Radius of rounded corners
tawaki_int_pin_rad = 1.25;
tawaki_ext_pin_rad = 2.9;
tawaki_pin_height = 10;
tawaki_pin_space_length = 30.2;
tawaki_pin_space_width = 30.2;

tawaki_esc_space = 100 + tawaki_pin_space_length;

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
battery_x_pos_2 = 180;

                    
                
    difference(){
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
     }// End of difference

    //Dig hole in part for battery attached            

    //*** Tawaki ***//
    
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

    //*** ESC ***//
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