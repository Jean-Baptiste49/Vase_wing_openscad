// RC wing generator for Vase mode printing
//
// Prior work used to create this script:
// https://www.thingiverse.com/thing:3506692
// https://github.com/guillaumef/openscad-airfoil


//include <lib/openscad-airfoil/s/s2027.scad>





// Wing airfoils
include <lib/openscad-airfoil/m/m18.scad>
af_vec_path_root =             airfoil_M18_path();
af_vec_path_mid  =             airfoil_M18_path();
af_vec_path_tip  =             airfoil_M18_path();
module RootAirfoilPolygon() {  airfoil_M18();  }
module MidAirfoilPolygon()  {  airfoil_M18();  }
module TipAirfoilPolygon()  {  airfoil_M18();  }


// TODO 
// Arm design Hole spar : OK
// Arm design separation
// Insert in module and parameters in main 
// Aileron circle attach
// Invert on spar avoid hole
// Add written CG
// Module sym module 
/*copy_mirror(vec=[0,1,0]){
	children();
	mirror(vec) children();
};*/


//Later :
// Readme
// Emprunte servo
// Custom airfoil profil
// Structure Grid Mode 1 Adapat ? 
// Update to new version openscad
// Optimize wing grid and hole

//*******************END***************************//

//****************Global Variables*****************//

// Printing Mode : Choose which part of wings you want
// Choose one at a time
Aileron_part = true;
Root_part = false;
Mid_part = false;
Tip_part = false;
Full_wing = false;
Motor_arm_left = true;

//****************Wing Airfoil settings**********//
wing_sections = 20; //60; // how many sections : more is higher resolution but higher processing
wing_mm = 600;            // wing length in mm
wing_root_chord_mm = 228.2; // Root chord legth in mm
wing_tip_chord_mm = 38.3;   // wing tip chord length in mm (Not relevant for elliptic wing);
wing_center_line_perc = 70; // Percentage from the leading edge where you would like the wings center line
wing_mode = 2; // 1=trapezoidal wing 2= elliptic wing
center_airfoil_change_perc = 100; // Where you want to change to the center airfoil 100 is off
tip_airfoil_change_perc = 100;    // Where you want to change to the tip airfoil 100 is off
slice_transisions = 0; // This is the number of slices that will be a blend of airfiols when airfoil is changed 0 is off
//**************** Motor arm **********//
ellipse_maj_ax = 13;        // ellipse's major axis (rayon z)
ellipse_min_ax = 20;        // ellipse's minor axis (rayon y)
motor_arm_length = 300;        // Tube length z
motor_arm_height = 19;      // Height of motor arm
motor_arm_tilt_angle  = 20; // Tilt angle of motor arm
motor_arm_screw_fit_offset = 3; // Offset to adjust screw position after rotation
dummy_motor = false;
//**************** Wing Airfoil dimensions **********//
// Total must do wing_mm
motor_arm_width = 2*ellipse_maj_ax;
wing_root_mm = 180;
wing_mid_mm = 240;
wing_tip_mm = wing_mm - wing_root_mm - wing_mid_mm - motor_arm_width;
AC_CG_margin = 10; //Margin between mean aerodynamic center and gravity center in pourcentage
aerodyn_center_plot = true; //Black
gravity_center_plot = true; //Green
//******//

//****************Wing Washout settings**********//
washout_deg = 2;         // how many degrees of washout you want 0 for none
washout_start = 60;      // where you would like the washout to start in mm from root
washout_pivot_perc = 25; // Where the washout pivot point is percent from LE
//******//

//**************** Wing Sweep X settings **********//
use_custom_lead_edge_sweep = true;
// ([z , x]
lead_edge_sweep = [
  [0, 0],       
  [100, 50],     
  [200, 100],     
  [300, 150],     
  [400, 200],     
  [500, 250],       
  [600, 300]      
];
//******//

//**************** Wing Y curve settings **********//
use_custom_lead_edge_curve = true; 
curve_amplitude = 0.10;
// ([z , y]
lead_edge_curve_y = [
  [0,     0],
  [500,   0],
  [505,   0],
  [510,   0],
  [515,   0],
  /*[520,   10],
  [525,   25],
  [527,   43],
  [530,  50],
  [533,  65],
  [535,  70],
  [540,  90],
  [543,  120],*/
  [545,  100], 
  [550,  170],    
  [555,  210],
  [560,  200],  
  [565,  220],
  [570,  240],  
  [575,  280],
  [580,  360],
  [585,  380],
  [590,  420],
  [595,  480],
  [600,  550]
];
//******//

//**************** Grid settings **********//
add_inner_grid = true; // true if you want to add the inner grid for 3d printing
grid_mode = 2;           // Grid mode 1=diamond 2= spar and cross spars
create_rib_voids = false; // add holes to the ribs to decrease weight

//**************** Grid mode 1 settings **********//
grid_size_factor = 2; // changes the size of the inner grid blocks
//******//

//**************** Grid mode 2 settings **********//
spar_num = 3;     // Number of spars for grid mode 2
spar_offset = 15; // Offset the spars from the LE/TE
rib_num = 12; //6;      // Number of ribs
rib_offset = 1;   // Offset
//******//

//**************** Carbon Spar settings **********//
debug_spar_hole = false;
spar_length_offset = 515;
spar_angle_fitting_coeff = 1.15; // Coeff to adjust the spar angle into the wing
//Spar angle rotation to follow the sweep
sweep_angle = use_custom_lead_edge_sweep ? atan((spar_angle_fitting_coeff * lead_edge_sweep[len(lead_edge_sweep) - 1][1]) / lead_edge_sweep[len(lead_edge_sweep) - 1][0]) : 0;

spar_hole = true;                // Add a spar hole into the wing
spar_hole_perc = 25;             // Percentage from leading edge
spar_hole_size = 5;              // Size of the spar hole
spar_hole_length = use_custom_lead_edge_sweep ? spar_length_offset/cos(sweep_angle) : spar_length_offset; // length of the spar in mm
spar_hole_offset = 6.5;            // Adjust where the spar is located
spar_hole_void_clearance = 1; // Clearance for the spar to grid interface(at least double extrusion width is usually needed)
// Second spar
spar_hole_perc_2 = 45;             // Percentage from leading edge
spar_hole_size_2 = 5;              // Size of the spar hole
spar_hole_length_2= spar_hole_length; // length of the spar in mm
spar_hole_offset_2 = 6.5;            // Adjust where the spar is located
spar_hole_void_clearance_2 = 1; 
// third spar
spar_hole_perc_3 = 85;             // Percentage from leading edge
spar_hole_size_3 = 5;              // Size of the spar hole
spar_hole_length_3= 30 + motor_arm_width + wing_root_mm;// length of the spar in mm
spar_hole_offset_3 = 0.5;            // Adjust where the spar is located
spar_hole_void_clearance_3 = 1; 
//******//

//**************** Servo settings **********//
create_servo_void = false; // It is important to check that your servo placement doesnt create any artifacts(You can
// comment out the CreateWing() function to assist)
servo_type = 1;           // 1=3.7g 2=5g 3=9g
servo_dist_root_mm = 100; // servo placement from root
servo_dist_le_mm = 64;    // servo placement from the leading edge
servo_rotate_z_deg = -7;  // degrees to rotate on z axis
servo_dist_depth_mm = 10; // offset the servo into or out of the wing till you dont see red
servo_show = false;       // for debugging only. Show the servo for easier placement
//******//

//**************** Aileron settings **********//
create_aileron = true;            // Create an Aileron
aileron_thickness = 30;           // Aileron dimension on X axis toward Leading Edge
aileron_height = 50;              // Aileron dimension on Y axis 
aileron_start_z = wing_root_mm;   // Aileron dimension on Z axis on Trailing Edge
aileron_end_z = wing_root_mm + wing_mid_mm;              // Aileron dimension on Z axis on Trailing Edge
aileron_cyl_radius = 15;          // Aileron void cylinder radius 
aileron_reduction = 1;            // Aileron size reduction to fit in the ailerons void with ease 
cylindre_wing_dist_nosweep = 1;   // Distance offset between cylinder and cube to avoid discontinuities in cut
cylindre_wing_dist_sweep = 2;     // Distance offset between cylinder and cube to avoid discontinuities in cut
aileron_pin_hole_diameter = 1.5;  // Diameter of the pin hole fixing the aileron to wing
aileron_pin_hole_length = 7;      // Length of the pin hole
aileron_pin_offset_x = 25;        // Offset on x of the pin hole
//******//

//**************** Other settings **********//
$fa = 5; // 360deg/5($fa) = 60 facets this affects performance and object shoothness
$fs = 1; // Min facet size

slice_ext_width = 0.6;//Used for some of the interfacing and gap width values
slice_gap_width = 0.01;//This is the gap in the outer skin.(smaller is better but is limited by what your slicer can recognise)
debug_leading_trailing_edge = true;
opacity = 1;
//******//

//*******************END***************************//










include <lib/Grid-Structure.scad>
include <lib/Grid-Void-Creator.scad>
include <lib/Helpers.scad>
include <lib/Rib-Void-Creator.scad>
include <lib/Servo-Hole.scad>
include <lib/Spar-Hole.scad>
include <lib/Wing-Creator.scad>
include <lib/Aileron-Creator.scad>
include <lib/Motor-arm.scad>
include <lib/Tools.scad>



    
module main()
{ 
  if(Full_wing == false) {  
  intersection() {
    difference()
    {
        difference()
        {
            CreateWing();

            if (add_inner_grid)
            {
                union()
                {
                    difference()
                    {
                        difference()
                        {
                            if (grid_mode == 1)
                            {
                                StructureGrid(wing_mm, wing_root_chord_mm, grid_size_factor);
                            }
                            else
                            {
                                StructureSparGrid(3*wing_mm, wing_root_chord_mm, grid_size_factor, spar_num, spar_offset,
                                                  3*rib_num, rib_offset);
                            }
                            union()
                            {
                                if (grid_mode == 1)
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids();
                                    }
                                }
                                else
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids2();
                                    }
                                }
                                union()
                                {
                                    if (spar_hole)
                                    {
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2);
                                        CreateSparVoid(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                3_7gServoVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                5gServoVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                9gServoVoid();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //Use for create void between each ribs to have a 3D vase print path
                        CreateGridVoid();
                    }
                }
            }
        }
        union()
        {
            if(create_aileron && Aileron_part == false)
            {
                CreateAileronVoid();
            }
            if (spar_hole)
            {
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        3_7gServo();
                    }
                    else if (servo_type == 2)
                    {
                        5gServo();
                    }
                    else if (servo_type == 3)
                    {
                        9gServo();
                    }
                }
            }                
        }
    }
  if(Aileron_part) {
  CreateAileron();
  }
  if(Root_part) {
    translate([-1000, -1000, 0])
    cube([2000, 2000, wing_root_mm]); 
  }  
  if(Mid_part) {
    translate([-1000, -1000, wing_root_mm + motor_arm_width])
    cube([2000, 2000, wing_mid_mm]); 
  }  
  if(Tip_part) {
    translate([-1000, -1000, wing_root_mm + motor_arm_width + wing_mid_mm])
    cube([2000, 2000, wing_tip_mm]); 
  } 
  if(Aileron_part) {
    translate([-1000, -1000, wing_root_mm + motor_arm_width])
    cube([2000, 2000, wing_mid_mm]);
  }   
  }
  } // End if Full wing
  
  
  else if (Full_wing) {
  difference() {
  union() {
  intersection() {
    difference()
    {
        difference()
        {
            CreateWing();

            if (add_inner_grid)
            {
                union()
                {
                    difference()
                    {
                        difference()
                        {
                            if (grid_mode == 1)
                            {
                                StructureGrid(wing_mm, wing_root_chord_mm, grid_size_factor);
                            }
                            else
                            {
                                StructureSparGrid(wing_mm, wing_root_chord_mm, grid_size_factor, spar_num, spar_offset,
                                                  rib_num, rib_offset);
                            }
                            union()
                            {
                                if (grid_mode == 1)
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids();
                                    }
                                }
                                else
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids2();
                                    }
                                }
                                union()
                                {
                                    if (spar_hole)
                                    {
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2);
                                        CreateSparVoid(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                3_7gServoVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                5gServoVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                9gServoVoid();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        CreateGridVoid();
                    }
                }
            }
        }
        union()
        {
            if(create_aileron)
            {
                CreateAileronVoid();
            }
            if (spar_hole)
            {
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        3_7gServo();
                    }
                    else if (servo_type == 2)
                    {
                        5gServo();
                    }
                    else if (servo_type == 3)
                    {
                        9gServo();
                    }
                }
            }                
        }
    }
  } // End 1st intersection
  
    // This part is to have aileron with the rest of the wing in full wing mode
    intersection() {
    difference()
    {
        difference()
        {
            CreateWing();

            if (add_inner_grid)
            {
                union()
                {
                    difference()
                    {
                        difference()
                        {
                            if (grid_mode == 1)
                            {
                                StructureGrid(wing_mm, wing_root_chord_mm, grid_size_factor);
                            }
                            else
                            {
                                StructureSparGrid(wing_mm, wing_root_chord_mm, grid_size_factor, spar_num, spar_offset,
                                                  rib_num, rib_offset);
                            }
                            union()
                            {
                                if (grid_mode == 1)
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids();
                                    }
                                }
                                else
                                {
                                    if (create_rib_voids)
                                    {
                                        CreateRibVoids2();
                                    }
                                }
                                union()
                                {
                                    if (spar_hole)
                                    {
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2);
                                        CreateSparVoid(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                3_7gServoVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                5gServoVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                9gServoVoid();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        CreateGridVoid();
                    }
                }
            }
        }
        union()
        {
            if (spar_hole)
            {
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        3_7gServo();
                    }
                    else if (servo_type == 2)
                    {
                        5gServo();
                    }
                    else if (servo_type == 3)
                    {
                        9gServo();
                    }
                }
            }                
        }
    }
    if(create_aileron)
    {
    CreateAileron();
    }
  } // End 2nd intersection
  } // End union in Full wing
    //Union for showing separation between parts. Just for display
    union(){
      translate([ -500, -500, wing_root_mm ])
        cube([ 1000, 1000, motor_arm_width ]);        
        
      translate([ -500, -500, wing_root_mm -1 ])
        cube([ 1000, 1000, 1 ]);
        
      translate([ -500, -500, wing_root_mm + motor_arm_width])
        cube([ 1000, 1000, 1 ]);    

      translate([ -500, -500, wing_root_mm + motor_arm_width + wing_mid_mm])
        cube([ 1000, 1000, 1 ]);         
    }
    
  } // End difference 
  }// End if Full wing
}




module motor_arm(a_ellipse, b_ellipse, arm_length, motor_height, arm_tilt_angle, arm_screw_fit_offset, aero_grav_center) {
   
    
    //**************** Left arm **********//  
    y_offset = 10;
    trim_plan_dim = 100;
    screw_hole_motor_arm_offset = 3.7;
    screw_hole_1 = 3;
    screw_hole_2 = 1.5;
    motor_footprint_long = 9.5;
    motor_footprint_short = 8;
    dummy_motor_base_radius = 9.5;
    dummy_motor_base_height = 20;
    dummy_helix_radius = 152.4; //6 inch
    dummy_helix_height = 20;
    x_pos_screw_long = cos(45) * (motor_footprint_long );
    y_pos_screw_long = sin(45) * (motor_footprint_long );
    x_pos_screw_short = cos(45) * (motor_footprint_short );
    y_pos_screw_short = sin(45) * (motor_footprint_short );    

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
            linear_extrude(height = motor_height+b_ellipse)
                circle(r = a_ellipse, $fn=100);

    //**************** Back arm **********//
    //Draw connexion arm to motor support
    translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
        scale([1, b_ellipse/a_ellipse])
           sphere(a_ellipse, $fn=100 );

    // Draw the motor support
    translate([ aero_grav_center[1] + arm_length, y_offset, wing_root_mm+a_ellipse])
        rotate([ 0, 90, 90 ])
            linear_extrude(height = motor_height+b_ellipse)
                circle(r = a_ellipse, $fn=100);
                
        }
    
    
    union(){    
    //**************** Front arm **********//    
    //Draw trim plan
    translate([ aero_grav_center[1] - arm_length -trim_plan_dim/2, y_offset + b_ellipse + motor_height , wing_root_mm+a_ellipse - trim_plan_dim/2 ]) {
            rotate([ arm_tilt_angle, 0, 0]) {
        
        cube([ trim_plan_dim, trim_plan_dim, trim_plan_dim ]);
    
    //Screw hole position           
    translate([trim_plan_dim/2 -y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_long])
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
    translate([trim_plan_dim/2 -y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_short, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_short])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 +y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 + x_pos_screw_long])
        rotate([ 90, 0, 0]) {   
            linear_extrude(height = 100)
                circle(r = screw_hole_2, $fn=100);
            
         translate([0, 0, screw_hole_motor_arm_offset])   
            linear_extrude(height = 100)
                circle(r = screw_hole_1, $fn=100);
        }
        //Screw hole position   
    translate([trim_plan_dim/2 -y_pos_screw_long, 0, arm_screw_fit_offset + trim_plan_dim/2 - x_pos_screw_long])
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

    
}





  
    
if (wing_sections * 0.2 < slice_transisions)
{
    echo("ERROR: You should lower the amount of slice_transisions.");
}
else if (center_airfoil_change_perc < 0 || center_airfoil_change_perc > 100)
{
    echo("ERROR: center_airfoil_change_perc has to be in a range of 0-100.");
}
else if (add_inner_grid == false && spar_hole == true)
{
    echo("ERROR: add_inner_grid needs to be true for spar_hole to be true");
}
else
{




    aerodynamic_gravity_center(wing_mm, AC_CG_margin, display_surface = false, display_point = true);
    aero_grav_center = get_gravity_aero_center(AC_CG_margin);
    main();
    
    
    if(Motor_arm_left){
    difference(){
    motor_arm(ellipse_maj_ax, ellipse_min_ax, motor_arm_length, motor_arm_height, motor_arm_tilt_angle, motor_arm_screw_fit_offset, aero_grav_center);
    union(){
                        CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width);
    }
    }
    }//End of Motor_arm_left
    
    
    
    
    
    
    
    if(debug_leading_trailing_edge)
    {
        points_te = get_trailing_edge_points();     
        show_trailing_edge_points(points_te); 
        points_le = get_leading_edge_points();     
        show_leading_edge_points(points_le); 
    }
    
    if(debug_spar_hole)
    {
    CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance);
    CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2);
    CreateSparVoid(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3);
    
    CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width);
                CreateSparHole(0, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width);
    }    




    if (servo_show)
    {
        rotate([ 0, 0, servo_rotate_z_deg ]) translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
        {
            if (servo_type == 1)
            {
                3_7gServo();
                //3_7gServoVoid();
            }
            else if (servo_type == 2)
            {
                5gServo();
                //5gServoVoid();
            }
            else if (servo_type == 3)
            {
                9gServo();
                //9gServoVoid();
            }
        }
    }
}