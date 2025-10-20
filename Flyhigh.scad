// RC wing generator for Vase mode printing
//
// Prior work used to create this script:
// https://www.thingiverse.com/thing:3506692
// https://github.com/guillaumef/openscad-airfoil


//include <lib/openscad-airfoil/s/s2027.scad>





// Wing airfoils
include <lib/openscad-airfoil/m/mh45.scad>
af_vec_path_root =             airfoil_MH45_path();
af_vec_path_mid  =             airfoil_MH45_path();
af_vec_path_tip  =             airfoil_MH45_path();
module RootAirfoilPolygon() {  airfoil_MH45();  }
module MidAirfoilPolygon()  {  airfoil_MH45();  }
module TipAirfoilPolygon()  {  airfoil_MH45();  }



// TODO 
// Profil = OK
// Wingspan 90 = OK
// Root tip = Falcom style = OK
// Zagi sweep = OK
// Small Washout = OK
// Curvature ? tobedefined = OK
// Stab margin 10% = OK
// Longerons = OK


// Main stage :
// Longerons insertiin main stage + long
// Longerons axe x ?
// Faire surépaisseur main stage longerons

// Emprunte servo
// Close face supp part for aileron side for pin ==> issue with pin mid to be solved
// Adjust arm size

//Later :
// Try on Orca and add printer conf in git
// Readme and clean and comment function with parameters description
// Custom airfoil profil
// Add written CG on arm or fuselage
// Structure Grid Mode 1 Adapat ? 
// Optimize wing grid and hole vs mass
// Ailerons module clean and fix little bug on command pin

//*******************END***************************//

//****************Global Variables*****************//

// Printing Mode : Choose which part of wings you want
// Choose one at a time
Left_side = true;
Right_side = false;

Aileron_part = false;
Root_part = true;
Mid_part = false;
Tip_part = false;
Motor_arm_full = false;
Motor_arm_front = false;
Motor_arm_back = false;
Center_part = false;

Full_system = false;

//****************Wing Airfoil settings**********//
wing_sections = 20; // how many sections : more is higher resolution but higher processing
wing_mm = 500;            // wing length in mm (= Half the wingspan)
wing_root_chord_mm = 180; // Root chord length in mm
wing_tip_chord_mm = 110; // wing tip chord length in mm (Not relevant for elliptic wing);
wing_center_line_perc = 70; // Percentage from the leading edge where you would like the wings center line
wing_mode = 2; // 1=trapezoidal wing 2= elliptic wing
center_airfoil_change_perc = 100; // Where you want to change to the center airfoil 100 is off
tip_airfoil_change_perc = 100;    // Where you want to change to the tip airfoil 100 is off
slice_transisions = 0; // This is the number of slices that will be a blend of airfoils when airfoil is changed 0 is off
//**************** Motor arm **********//
ellipse_maj_ax = 9;        // ellipse's major axis (rayon z)
ellipse_min_ax = 13;        // ellipse's minor axis (rayon y)
motor_arm_length = 280;        // Tube length z
motor_arm_height = 19;      // Height of motor arm
motor_arm_tilt_angle  = 20; // Tilt angle of motor arm
motor_arm_screw_fit_offset = 2; // Offset to adjust screw position after rotation
dummy_motor = false;
// More parameters are available inside the motor_arm module
//**************** Wing Airfoil dimensions **********//
// Total must do wing_mm
motor_arm_width = 2*ellipse_maj_ax;
wing_root_mm = 230;
wing_mid_mm = 200;
wing_tip_mm = wing_mm - wing_root_mm - wing_mid_mm - motor_arm_width;
echo("Wing_tip_mm = ", wing_tip_mm);
AC_CG_margin = 10; //Margin between mean aerodynamic center and gravity center in pourcentage
aerodyn_center_plot = false; //Black
gravity_center_plot = false; //Green
//******//
//**************** Fuselage and center part **********//
center_width = 150;
center_length = 250;
center_height = 17;
//******//

//****************Wing Washout settings**********//
washout_deg = 1.5;         // how many degrees of washout you want 0 for none
washout_start = 60;      // where you would like the washout to start in mm from root
washout_pivot_perc = 25; // Where the washout pivot point is percent from LE
//******//

//**************** Wing Sweep X settings **********//
use_custom_lead_edge_sweep = true;
// ([z , x]
lead_edge_sweep = [
  [0, 0],
  [wing_mm,281]
];  
//******//

//**************** Wing Y curve settings **********//
use_custom_lead_edge_curve = true; 
curve_amplitude = 0.10;
max_amplitude = 400;
// ([z , y]
lead_edge_curve_y = [
  [0,     0],
  [wing_mm - wing_tip_mm     ,   0*max_amplitude/10],
  [wing_mm - 9*wing_tip_mm/10,   0*max_amplitude/10],
  [wing_mm - 8*wing_tip_mm/10,   0*max_amplitude/10],
  [wing_mm - 7*wing_tip_mm/10,   0*max_amplitude/10],
  [wing_mm - 6*wing_tip_mm/10,   1*max_amplitude/10],
  [wing_mm - 5*wing_tip_mm/10,   2*max_amplitude/10],
  [wing_mm - 4*wing_tip_mm/10,   4*max_amplitude/10],
  [wing_mm - 3*wing_tip_mm/10,   6*max_amplitude/10],  
  [wing_mm - 2*wing_tip_mm/10,   8*max_amplitude/10],
  [wing_mm - 1*wing_tip_mm/10,   11*max_amplitude/10],
  [wing_mm - 0*wing_tip_mm/10,   16*max_amplitude/10] 
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
spar_offset = 15; // Offset the spars from the LE/TE
rib_num = 13; //6;      // Number of ribs
rib_offset = 1;   // Offset
//******//

//**************** Carbon Spar settings **********//
debug_spar_hole = false;
spar_num = 3;     // Number of spars for grid mode 2
spar_length_offset_1 = wing_mm - 10*wing_tip_mm/10;
spar_length_offset_2 = wing_mm - 19*wing_tip_mm/10;
spar_angle_fitting_coeff = 1.15; // Coeff to adjust the spar angle into the wing
//Spar angle rotation to follow the sweep
sweep_angle = use_custom_lead_edge_sweep ? atan((spar_angle_fitting_coeff * lead_edge_sweep[len(lead_edge_sweep) - 1][1]) / lead_edge_sweep[len(lead_edge_sweep) - 1][0]) : 0;

spar_hole = true;                // Add a spar hole into the wing
spar_hole_perc = 25;             // Percentage from leading edge
spar_hole_size = 5;              // Size of the spar hole
spar_hole_length = use_custom_lead_edge_sweep ? spar_length_offset_1/cos(sweep_angle) : spar_length_offset_1; // length of the spar in mm
spar_hole_offset = 1.8;            // Adjust where the spar is located
spar_hole_void_clearance = 1; // Clearance for the spar to grid interface(at least double extrusion width is usually needed)
spar_flip_side_1 = false; // use to offset the spar attached on a side of the wing to the other
// Second spar
spar_hole_perc_2 = 45;             // Percentage from leading edge
spar_hole_size_2 = 5;              // Size of the spar hole
spar_hole_length_2= use_custom_lead_edge_sweep ? spar_length_offset_2/cos(sweep_angle) : spar_length_offset_2; // length of the spar in mm
spar_hole_offset_2 = 1.8;            // Adjust where the spar is located
spar_hole_void_clearance_2 = 1; 
spar_flip_side_2 = false; // use to offset the spar attached on a side of the wing to the other
// third spar
spar_hole_perc_3 = 81;             // Percentage from leading edge
spar_hole_size_3 = 5;              // Size of the spar hole
spar_hole_length_3= 30 + motor_arm_width + wing_root_mm;// length of the spar in mm
spar_hole_offset_3 = 0.85;            // Adjust where the spar is located
spar_hole_void_clearance_3 = 1; 
spar_flip_side_3 = true; // use to offset the spar attached on a side of the wing to the other
sweep_angle_3rd_spar = 2.09*sweep_angle/3;
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
aileron_thickness = 32;           // Aileron dimension on X axis toward Leading Edge
aileron_height = 50;              // Aileron dimension on Y axis 
aileron_pin_hole_diameter = 1.5;  // Diameter of the pin hole fixing the aileron to wing
aileron_pin_hole_length = 7;      // Length of the pin hole
aileron_start_z = wing_root_mm;   // Aileron dimension on Z axis on Trailing Edge
aileron_end_z = wing_root_mm + wing_mid_mm + motor_arm_width - aileron_pin_hole_length; // Aileron dimension on Z axis on Trailing Edge
aileron_cyl_radius = 6;  // Aileron void cylinder radius 
aileron_reduction = 1;            // Aileron size reduction to fit in the ailerons void with ease 
cylindre_wing_dist_nosweep = 1;   // Distance offset between cylinder and cube to avoid discontinuities in cut
cylindre_wing_dist_sweep = -10; // Distance offset between cylinder and cube to avoid discontinuities in cut
aileron_command_pin_void_length = 10;
aileron_command_pin_width = 7.5;
aileron_command_pin_s_radius = 1.7;
aileron_command_pin_b_radius = 3.15;
aileron_command_pin_x_offset = 3;
aileron_dist_LE_command_center = aileron_thickness - aileron_command_pin_width - aileron_command_pin_b_radius - aileron_command_pin_x_offset;
aileron_dist_LE_pin_center = aileron_thickness;// - aileron_command_pin_b_radius - aileron_command_pin_x_offset;

//******//

//**************** Other settings **********//
$fa = 5; // 360deg/5($fa) = 60 facets this affects performance and object shoothness
$fs = 1; // Min facet size

slice_ext_width = 0.6;//Used for some of the interfacing and gap width values
slice_gap_width = 0.01;//This is the gap in the outer skin.(smaller is better but is limited by what your slicer can recognise)
debug_leading_trailing_edge = false;
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



    
module wing_main()
{ 
  if(Full_system == false) {  
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
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
                                        CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                Servo3_7gVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                Servo5gVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                Servo9gVoid();
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
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_flip_side_2);
                CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_flip_side_3);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        Servo3_7g();
                    }
                    else if (servo_type == 2)
                    {
                        Servo5g();
                    }
                    else if (servo_type == 3)
                    {
                        Servo9g();
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
  }// End intersection
  
  } // End if Full wing
  
  
  else if (Full_system) {
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
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
                                        CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                Servo3_7gVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                Servo5gVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                Servo9gVoid();
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
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_flip_side_2);
                CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_flip_side_3);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        Servo3_7g();
                    }
                    else if (servo_type == 2)
                    {
                        Servo5g();
                    }
                    else if (servo_type == 3)
                    {
                        Servo9g();
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
                                        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);
                                        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
                                        CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);
                                    }
                                    if (create_servo_void)
                                    {
                                        rotate([ 0, 0, servo_rotate_z_deg ])
                                            translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                                        {
                                            if (servo_type == 1)
                                            {
                                                Servo3_7gVoid();
                                            }
                                            else if (servo_type == 2)
                                            {
                                                Servo5gVoid();
                                            }
                                            else if (servo_type == 3)
                                            {
                                                Servo9gVoid();
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
                CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_flip_side_2);
                CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_flip_side_3);
            }
            if (create_servo_void)
            {
                rotate([ 0, 0, servo_rotate_z_deg ])
                    translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
                {
                    if (servo_type == 1)
                    {
                        Servo3_7g();
                    }
                    else if (servo_type == 2)
                    {
                        Servo5g();
                    }
                    else if (servo_type == 3)
                    {
                        Servo9g();
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

module motor_arm_main(aero_grav_center){
    
        if(Motor_arm_full || Motor_arm_front || Motor_arm_back || Full_system){
        difference(){
        motor_arm(ellipse_maj_ax, ellipse_min_ax, motor_arm_length, motor_arm_height, motor_arm_tilt_angle, motor_arm_screw_fit_offset, aero_grav_center, back =Motor_arm_back, front = Motor_arm_front, full = Motor_arm_full);
            union(){
                        CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                        CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_flip_side_2);
                        CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_flip_side_3);
            }
        }//End of difference
    }//End of Motor_arm_left
    
}






module center_part(aero_grav_center, ct_width, ct_length, ct_height){    


 
size = [ct_length, ct_width];    // Square size (X, Y)
radius = 3;         // Radius of rounded corners

translate([ct_length/2,2*ct_height/3,-ct_width/2])
    rotate([90,0,0])
        linear_extrude(ct_height)
            offset(r=radius)
                offset(delta=-radius)
                    square([ct_length, ct_width], center=true);
            
           
}


module center_part_main(aero_grav_center, ct_width, ct_length, ct_height){  


    if(Center_part){
    
        difference(){    
            center_part(aero_grav_center, ct_width, ct_length, ct_height);
  
            union(){
            CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                        CreateSparHole_center(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, ct_width);
                        CreateSparHole_center(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, ct_width);
                        CreateSparHole_center(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, ct_width);
                        mirror([0, 0, 1]) {
                            translate([0, 0, center_width]){
            CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                        CreateSparHole_center(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, ct_width);
                        CreateSparHole_center(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, ct_width);
                        CreateSparHole_center(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, ct_width);
                            } // End of translate
                        } // End of Mirror
                        
            }//End of Union
        }//End of difference
    
    
    }//End if Center_part
}


 
//CreateAileron();
    
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




    //**************** Aero and Gravity Center **********//
    aerodynamic_gravity_center(wing_mm, AC_CG_margin, display_surface = false, display_point = false, aero_center_plot = aerodyn_center_plot, grav_center_plot = gravity_center_plot);
    aero_grav_center = get_gravity_aero_center(AC_CG_margin);
    
    
    //**************** Wing **********//
    if(Full_system || Root_part || Mid_part || Tip_part || Aileron_part){
        
        if(Left_side || Full_system){
            wing_main();
        }
        if(Right_side || Full_system){
            mirror([0, 0, 1]) {
                translate([0, 0, center_width])
                    wing_main();
            } 
        }//End if Right_side
    }


    //**************** Motor arm **********//
    if(Left_side || Full_system){
    motor_arm_main(aero_grav_center);
    }
    if(Right_side || Full_system){
        mirror([0, 0, 1]) {
            translate([0, 0, center_width])
                motor_arm_main(aero_grav_center);
        } 
    }//End if Full System

    
    //**************** Center part **********//
    center_part_main(aero_grav_center, center_width, center_length, center_height);
    
    
    


















    
    
    if(debug_leading_trailing_edge)
    {
        points_te = get_trailing_edge_points();     
        show_trailing_edge_points(points_te); 
        points_le = get_leading_edge_points();     
        show_leading_edge_points(points_le); 
    }
    
    if(debug_spar_hole)
    {
        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);
        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
        CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);
        
        CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_flip_side_1);
                    CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_flip_side_2);
                    CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_flip_side_3);
    }    




    if (servo_show)
    {
        rotate([ 0, 0, servo_rotate_z_deg ]) translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
        {
            if (servo_type == 1)
            {
                Servo3_7g();
                //Servo3_7gVoid();
            }
            else if (servo_type == 2)
            {
                Servo5g();
                //Servo5gVoid();
            }
            else if (servo_type == 3)
            {
                Servo9g();
                //Servo9gVoid();
            }
        }
    }
}

