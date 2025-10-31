// RC wing generator for Vase mode printing
//
// Prior work used to create this script:
// https://www.thingiverse.com/thing:3506692
// https://github.com/guillaumef/openscad-airfoil

//Tips
// 1- If you want to add something into the wing, add a void offset around the part you want to add to avoid conflict with intern ribs during vase print  
// 2- When spar hole is far from a edge and the vase circuit connection is too long, the system doesnt like and don't draw the spar hole. Use spar_flip_side parameter to orientate the vase circuit connection to the closest edge


// Note Printer 
// 1- No support in motor arm spar holes
// 2- use PLA Aero user preset to get nice print
// 3- Bambulab can crash each time you enter a too large model to slice. It can be due to a NVIDIA parameter for bambulab, here is the solution : https://forum.bambulab.com/t/bambu-studio-crashes-after-slicing-solved-nvidia-problem/162392
// 4- When you import a preset, the import can not work due to version difference. Be carefull to update the version of your printer into the preset document you want to import




// Wing airfoils
include <lib/openscad-airfoil/m/mh45.scad>
af_vec_path_root =             airfoil_MH45_path();
af_vec_path_mid  =             airfoil_MH45_path();
af_vec_path_tip  =             airfoil_MH45_path();
module RootAirfoilPolygon() {  airfoil_MH45();  }
module MidAirfoilPolygon()  {  airfoil_MH45();  }
module TipAirfoilPolygon()  {  airfoil_MH45();  }



// TODO 
// Clean main with modules : Motor arm and main stage
// Note on openscad nightly and manifold option
// Mid_Tip_part ? We keep ?
// Ailerons print slower + Pb servo 

// Choix :
// Test print Encoche servo correction
// Allonger Spar numero 3 ou supp attach central

//Later :
// Ailerons pin attach both sides 
// Longerons axe x Main stage
// Ailerons module clean
// Try on Orca and add printer conf in git
// Readme and clean and comment function with parameters description
// Structure Grid Mode 1 Adapat ? 
// Optimize wing grid and hole vs mass
// Close face ?


//*******************END***************************//

//****************Global Variables*****************//

// Printing Mode : Choose which part of wings you want
Full_system = false;

Left_side = true;
Right_side = false;

// Choose one at a time
Aileron_part = true;
Root_part = false;
Mid_part = false;
Tip_part = false;
Mid_Tip_part = false; //TODO
Motor_arm_full = false;
Motor_arm_front = false;
Motor_arm_back = false;
Center_part = false;
Center_part_locker = false; 

//****************Wing Airfoil settings**********//
wing_sections = Full_system?10:20; // how many sections : more is higher resolution but higher processing. We decrease wing_sections for Full_system because it's too much elements just for display
wing_mm = 500;            // wing length in mm (= Half the wingspan)
wing_root_chord_mm = 180; // Root chord length in mm
wing_tip_chord_mm = 110; // wing tip chord length in mm (Not relevant for elliptic wing);
wing_center_line_perc = 70; // Percentage from the leading edge where you would like the wings center line
wing_mode = 2; // 1=trapezoidal wing 2= elliptic wing
center_airfoil_change_perc = 100; // Where you want to change to the center airfoil 100 is off
tip_airfoil_change_perc = 100;    // Where you want to change to the tip airfoil 100 is off
slice_transisions = 0; // This is the number of slices that will be a blend of airfoils when airfoil is changed 0 is off
elliptic_param = 3.5; //Paramater for surrellipse adjustement. Ellipse = 2. Square tip >2 and Sharp tip <2


//**************** Motor arm **********//
ellipse_maj_ax = 9;        // ellipse's major axis (rayon z)
ellipse_min_ax = 13;        // ellipse's minor axis (rayon y)
motor_arm_length_front = 170;        // Tube length z
motor_arm_length_back = 210;        // Tube length z
motor_arm_y_offset = 3;   //Offset on Y axis
motor_arm_height = 19;      // Height of motor arm
motor_arm_tilt_angle  = 20; // Tilt angle of motor arm
motor_arm_screw_fit_offset = 2; // Offset to adjust screw position after rotation
dummy_motor = false; // Parameters to see how the helix is positionned in comparison of the aircraft
motor_arm_grav_center_offset = 35;
// More parameters are available inside the motor_arm module



//**************** Wing Airfoil dimensions **********//
// Total must do wing_mm
motor_arm_width = 2*ellipse_maj_ax;
wing_root_mm = 215;
wing_mid_mm = 245;
wing_tip_mm = wing_mm - wing_root_mm - wing_mid_mm - motor_arm_width;
AC_CG_margin = 10; //Margin between mean aerodynamic center and gravity center in pourcentage
aerodyn_center_plot = false; //Black
gravity_center_plot = false; //Green
//******//


//**************** Fuselage and center part **********//
center_width = 55;
center_length = 210;
center_height = 8;
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
  [wing_mm - 0*wing_tip_mm/10,   14*max_amplitude/10] 
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
spar_offset = 12;//15; // Offset the spars from the LE/TE
rib_num = 14;      // Number of ribs
rib_offset = 3;   // Offset
//******//



//**************** Winglet settings **********//
winglet_mode = true;
winglet_height = 55;
winglet_width = 4;
winglet_rear_up_offset = 75;
winglet_rear_bottom_offset = 45;
winglet_y_pos = -3.5;
winglet_x_pos = 7;
base_length = 4*wing_root_chord_mm/10;
corner_radius = 0; 
winglet_attach_dilatation_offset_PLA = 1.01;// We use this offset for the dilation of material after print to keep the right dimensions
winglet_attach_void_clearance = 1.3; // We use this offset to create void in the ribs structure
    
attached_1_x_pos = -30;
attached_1_y_pos = 1.5;
attached_1_radius = 2.5;
attached_1_length = 30;
    
attached_2_x_pos = -50;
attached_2_y_pos = 1;
attached_2_radius = 2.2;
attached_2_length = 30;
//******//


//**************** Carbon Spar settings **********//
debug_spar_hole = false;
debug_spar_void = false;
spar_num = 3;     // Number of spars for grid mode 2
spar_length_offset_1 = wing_mm - wing_tip_mm - 2*attached_1_length;
spar_length_offset_2 = wing_mm - wing_tip_mm - 2*attached_2_length;
spar_angle_fitting_coeff = 1.15; // Coeff to adjust the spar angle into the wing
//Spar angle rotation to follow the sweep
sweep_angle = use_custom_lead_edge_sweep ? atan((spar_angle_fitting_coeff * lead_edge_sweep[len(lead_edge_sweep) - 1][1]) / lead_edge_sweep[len(lead_edge_sweep) - 1][0]) : 0;

spar_hole = true;                // Add a spar hole into the wing
spar_hole_perc = 15;             // Percentage from leading edge
spar_hole_size = 5.6;              // Size of the spar hole
spar_hole_length = use_custom_lead_edge_sweep ? spar_length_offset_1/cos(sweep_angle) : spar_length_offset_1; // length of the spar in mm
spar_hole_offset = 1.8;            // Adjust where the spar is located
spar_hole_void_clearance = 2; // Clearance for the spar to grid interface(at least double extrusion width is usually needed)
spar_flip_side_1 = true; // use to offset the spar attached on a side of the wing to the other
// Second spar
spar_hole_perc_2 = 37;             // Percentage from leading edge
spar_hole_size_2 = 5.6;              // Size of the spar hole
spar_hole_length_2= use_custom_lead_edge_sweep ? spar_length_offset_2/cos(sweep_angle) : spar_length_offset_2; // length of the spar in mm
spar_hole_offset_2 = 1.2;            // Adjust where the spar is located
spar_hole_void_clearance_2 = 2; 
spar_flip_side_2 = true; // use to offset the spar attached on a side of the wing to the other
// third spar
spar_hole_perc_3 = 75;             // Percentage from leading edge
spar_hole_size_3 = 5.6;              // Size of the spar hole (5.7 too large, 5.5 too tight)
spar_hole_length_3= 31 + motor_arm_width + wing_root_mm;// length of the spar in mm
spar_hole_offset_3 = 1.2;            // Adjust where the spar is located
spar_hole_void_clearance_3 = 2;
spar_flip_side_3 = true; // use to offset the spar attached on a side of the wing to the other
sweep_angle_3rd_spar = 2.04*sweep_angle/3;
spar_circles_nb = 12; //Number of outer circle around spar to maintain the part
spar_circle_holder = 0.27; //radius of outer circle around spar to maintain the part 0.25 too large and 0.30 too tight
spar_inser_lgth_into_center_part = center_width/2;
//******//




//**************** Servo settings **********//  
servo_dimension_perso = [23,8,27.5]; //[24,9,27.5]; 
all_pts_servo = get_trailing_edge_points();
pt_start_servo = find_interpolated_point(wing_root_mm - 0, all_pts_servo);

create_servo_void = true; // It is important to check that your servo placement doesnt create any artifacts(You can
// comment out the CreateWing() function to assist)
servo_type = 4;           // 1=3.7g 2=5g 3=9g 4=perso
servo_dist_root_mm = wing_root_mm-6.65; // servo placement from root
servo_dist_le_mm = pt_start_servo[0]-40;    // servo placement from the leading edge
servo_rotate_z_deg = -0;  // degrees to rotate on z axis
servo_dist_depth_mm = -0; // offset the servo into or out of the wing till you dont see red
servo_show = false;       // for debugging only. Show the servo for easier placement
//******//





//**************** Aileron settings **********//
create_aileron = true;            // Create an Aileron
aileron_thickness = 32;           // Aileron dimension on X axis toward Leading Edge
aileron_height = 50;              // Aileron dimension on Y axis 
aileron_pin_hole_diameter = 1.5;  // Diameter of the pin hole fixing the aileron to wing
aileron_pin_hole_length = 7;      // Length of the pin hole
aileron_start_z = wing_root_mm;   // Aileron dimension on Z axis on Trailing Edge
aileron_end_z = wing_root_mm + wing_mid_mm + motor_arm_width;// - 3*aileron_pin_hole_length; // Aileron dimension on Z axis on Trailing Edge
aileron_cyl_radius = 6;  // Aileron void cylinder radius 
aileron_reduction = 1;            // Aileron size reduction to fit in the ailerons void with ease 
cylindre_wing_dist_nosweep = 1;   // Distance offset between cylinder and cube to avoid discontinuities in cut
cylindre_wing_dist_sweep = -10; // Distance offset between cylinder and cube to avoid discontinuities in cut
aileron_command_pin_void_length = 10;
aileron_command_pin_width = 7.5;
aileron_command_pin_s_radius = 0.6;//1.7;
aileron_command_pin_b_radius = 1.7;//3.15;
aileron_command_pin_x_offset = 3;
y_offset_aileron_to_wing = 0.6;
aileron_dist_LE_command_center = aileron_thickness - aileron_command_pin_width - aileron_command_pin_b_radius - aileron_command_pin_x_offset;
aileron_dist_LE_pin_center = aileron_thickness;// - aileron_command_pin_b_radius - aileron_command_pin_x_offset;
void_offset_command_ailerons = 1.3; // Use this offset for ribs to pin command conflict in vase. It will make a hole in ribs around the pin command void
void_offset_pin_hole_ailerons = 2.5; // Use this offset for ribs to pin conflict in vase. It will make a hole in ribs around the pin void
ailerons_pin_hole_dilatation_offset_PLA = 1.2; // We use this offset for the dilation of material after print to keep the right dimensions
ailerons_pin_hole_dilatation_offset_PETG = 1.3; 
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
include <lib/Winglet-Creator.scad>
include <lib/Center-part.scad>


    
//-----------------------------------------------------------
// MAIN WING MODULE
//-----------------------------------------------------------
module wing_main() {
    if (!Full_system) {
        intersection() {
            difference() {
                difference() {
                    wing_shell();
                    if (add_inner_grid) wing_inner_grid();
                }
                wing_modif();
            }
            if (Aileron_part) CreateAileron(); //We remove ailerons from wing if request
            wing_cut_sections();
        }
        if (winglet_mode && Tip_part)
            winglet_with_void();
    }
    else {
        wing_full_system();
    }
}


//-----------------------------------------------------------
// WING SHELL (outer skin)
//-----------------------------------------------------------
module wing_shell() {
    CreateWing();
}


//-----------------------------------------------------------
// INTERNAL STRUCTURE (grid, ribs, spars)
//-----------------------------------------------------------
module wing_inner_grid() {
    difference() {
        if (grid_mode == 1)
            StructureGrid(wing_mm, wing_root_chord_mm, grid_size_factor);
        else
            StructureSparGrid(3 * wing_mm, wing_root_chord_mm, grid_size_factor,
                              spar_num, spar_offset, 3 * rib_num, rib_offset); //We multiply by 3 to to cover largely the whole wing

        if (create_rib_voids) //Void in ribs to decrease weight
            if(grid_mode == 1) CreateRibVoids(); 
            else CreateRibVoids2();

        wing_voids();      // servo, spar, aileron, and winglet voids
        CreateGridVoid();  // internal grid clearance for vase mode
    }
}


//-----------------------------------------------------------
// INTERNAL VOIDS (spar, servo, aileron, winglet)
//-----------------------------------------------------------
module wing_voids() {
    union() {
        if (spar_hole) wing_spar_voids();
        if (create_aileron) Ailerons_pin_void();
        if (winglet_mode) Create_winglet_void();
        if (create_servo_void) servo_void_block();
    }
}


//-----------------------------------------------------------
// WING MODIFICATIONS (visible outer parts)
//-----------------------------------------------------------
module wing_modif() {
    union() {
        if (winglet_mode)
            Create_winglet(cube_for_vase = true);

        if (create_aileron && !Aileron_part && !Full_system)
            CreateAileronVoid();

        if (spar_hole)
            wing_spar_holes();

        if (create_servo_void)
            servo_block();
    }
}


//-----------------------------------------------------------
// SUBMODULES: Spars, Servos, Winglets
//-----------------------------------------------------------
//Create Void into ribs for spars to avoid conflict between spar and ribs for vase print
module wing_spar_voids() {
    CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size,
                   spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);

    CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2,
                   spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);

    CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3,
                   spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);
}

//Create holes for spars in wings
module wing_spar_holes() {
    CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size,
                   spar_hole_length, wing_root_chord_mm, slice_gap_width,
                   spar_circles_nb, spar_circle_holder, spar_flip_side_1);

    CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2,
                   spar_hole_length_2, wing_root_chord_mm, slice_gap_width,
                   spar_circles_nb, spar_circle_holder, spar_flip_side_2);

    CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3,
                   spar_hole_length_3, wing_root_chord_mm, slice_gap_width,
                   spar_circles_nb, spar_circle_holder, spar_flip_side_3);
}

//Create Void in ribs for servo (same reason as spar)
module servo_void_block() {
    rotate([0, 0, servo_rotate_z_deg])
    translate([servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm])
    {
        if (servo_type == 1) Servo3_7gVoid();
        else if (servo_type == 2) Servo5gVoid();
        else if (servo_type == 3) Servo9gVoid();
        else if (servo_type == 4) Servo4Void();
    }
}

//Create Void in wings for servo 
module servo_block() {
    rotate([0, 0, servo_rotate_z_deg])
    translate([servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm])
    {
        if (servo_type == 1) Servo3_7g();
        else if (servo_type == 2) Servo5g();
        else if (servo_type == 3) Servo9g();
        else if (servo_type == 4) Servo4();
    }
}

//Create Winglet with the Pin Aileron connection
module winglet_with_void() {
    difference() {
        Create_winglet();
        if (create_aileron)
            CreateAileronVoid();
    }
}


//-----------------------------------------------------------
// SECTION CUTS (for printing)
//-----------------------------------------------------------
module wing_cut_sections() {
    if (Aileron_part) cube_cut(wing_root_mm + motor_arm_width, wing_mid_mm);
    if (Root_part) cube_cut(0, wing_root_mm);
    if (Mid_part) cube_cut(wing_root_mm + motor_arm_width, wing_mid_mm);
    if (Tip_part && !winglet_mode)
        cube_cut(wing_root_mm + motor_arm_width + wing_mid_mm, wing_tip_mm);
    if (Mid_Tip_part)
        cube_cut(wing_root_mm + motor_arm_width, wing_mid_mm + wing_tip_mm);
}

module cube_cut(start_z, len_z) {
    translate([-1000, -1000, start_z])
        cube([2000, 2000, len_z]);
}


//-----------------------------------------------------------
// FULL SYSTEM BUILD
//-----------------------------------------------------------
module wing_full_system() {
    union() {
        intersection() {
            difference() {
                difference() {
                    wing_shell();
                    if (add_inner_grid) wing_inner_grid();
                }
                    wing_modif();
                    CreateAileronVoid(); //We remove the ailerons the ailerons
            }
            //We remove the tip for Winglet
            if (winglet_mode) cube_cut(0,wing_root_mm + motor_arm_width + wing_mid_mm);
        }
        if (winglet_mode) winglet_with_void();

        // Create aileron block in full mode
        intersection() {
            difference() {
                wing_shell();
                if (add_inner_grid) wing_inner_grid();
                servo_block();
            }
        if (create_aileron)
            CreateAileron();
       }

    }
}


module motor_arm_main(aero_grav_center){
    
        if(Motor_arm_full || Motor_arm_front || Motor_arm_back || Full_system){
        difference(){
        motor_arm(ellipse_maj_ax, ellipse_min_ax, motor_arm_length_front, motor_arm_length_back, motor_arm_height, motor_arm_tilt_angle, motor_arm_screw_fit_offset, aero_grav_center, motor_arm_grav_center_offset, motor_arm_y_offset, back =Motor_arm_back, front = Motor_arm_front, full = Motor_arm_full);
            union(){
                        CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_1);
                        CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_2);
                        CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_3);
            


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
                            else if (servo_type == 4)
                            {
                                Servo4();
                            }                    
                        }
                    }            
                        
                        
                        
            }
        }//End of difference
    }//End of Motor_arm_left
    
}









module center_part_main(aero_grav_center, ct_width, ct_length, ct_height, rear_spar_locker){  


    if(Center_part || Center_part_locker || Full_system){
     
        difference(){    
            center_part(aero_grav_center, ct_width, ct_length, ct_height, rear_spar_locker);
  
            union(){
            CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_1);
                        CreateSparHole_center(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                        CreateSparHole_center(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                        CreateSparHole_center(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                        mirror([0, 0, 1]) {
                            translate([0, 0, center_width]){
            CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_1);
                        CreateSparHole_center(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                        CreateSparHole_center(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                        CreateSparHole_center(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, ct_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
                            } // End of translate
                        } // End of Mirror
                        
            }//End of Union
        }//End of difference
    
    
    }//End if Center_part
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




    //**************** Aero and Gravity Center **********//
    aerodynamic_gravity_center(wing_mm, AC_CG_margin, display_surface = false, display_point = false, aero_center_plot = aerodyn_center_plot, grav_center_plot = gravity_center_plot);
    aero_grav_center = get_gravity_aero_center(AC_CG_margin);
    
    //**************** Spar Length for user **********//
    echo(str("[SPAR] Spar 1 at ",spar_hole_perc,"% from LE is ", spar_hole_length + spar_inser_lgth_into_center_part, "mm length."));
    echo(str("[SPAR] Spar 2 at ",spar_hole_perc_2,"% from LE is ", spar_hole_length_2 + spar_inser_lgth_into_center_part, "mm length."));    
    echo(str("[SPAR] Spar 3 at ",spar_hole_perc_3,"% from LE is ", spar_hole_length_3 + spar_inser_lgth_into_center_part, "mm length."));        
    
    
    //**************** Wing **********//
    if(Full_system || Root_part || Mid_part || Tip_part || Aileron_part || Mid_Tip_part){
        
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
    center_part_main(aero_grav_center, center_width, center_length, center_height, Center_part_locker);
    
    
    
    
    if(debug_leading_trailing_edge)
    {
        points_te = get_trailing_edge_points();     
        show_trailing_edge_points(points_te); 
        points_le = get_leading_edge_points();     
        show_leading_edge_points(points_le); 
    }
    
    if(debug_spar_hole)
    {  
        ///*** Spar hole in Wings ***///
        CreateSparHole(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_1);
        CreateSparHole(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_2);
        CreateSparHole(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, slice_gap_width, spar_circles_nb, spar_circle_holder, spar_flip_side_3);
        
        ///*** Spar hole in Center Part ***///            
        CreateSparHole_center(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, center_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
        CreateSparHole_center(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, center_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);
        CreateSparHole_center(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, center_width, spar_circles_nb, spar_circle_holder, spar_inser_lgth_into_center_part);          
  
                    
    }    

    if(debug_spar_void)
    {
        CreateSparVoid(sweep_angle, spar_hole_offset, spar_hole_perc, spar_hole_size, spar_hole_length, wing_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);
        CreateSparVoid(sweep_angle, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2, spar_hole_length_2, wing_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
        CreateSparVoid(sweep_angle_3rd_spar, spar_hole_offset_3, spar_hole_perc_3, spar_hole_size_3, spar_hole_length_3, wing_root_chord_mm, spar_hole_void_clearance_3, spar_flip_side_3);     
        
    }

    if (servo_show)
    {
        rotate([ 0, 0, servo_rotate_z_deg ]) translate([ servo_dist_le_mm, servo_dist_depth_mm, servo_dist_root_mm ])
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
            else if (servo_type == 4)
            {
                Servo4();
                Servo4Void();
            }
        }
    }
}



/*

//-----------------------------------------------------------
// MAIN MOTOR ARM MODULE
//-----------------------------------------------------------
module motor_arm_main() {
    intersection() {
        difference() {
            motor_arm_shell();
            if (add_inner_grid) motor_arm_inner_grid();
        }
        motor_arm_addons();
    }
}


//-----------------------------------------------------------
// OUTER SHELL
//-----------------------------------------------------------
module motor_arm_shell() {
    CreateMotorArm();
}


//-----------------------------------------------------------
// INTERNAL GRID STRUCTURE
//-----------------------------------------------------------
module motor_arm_inner_grid() {
    difference() {
        StructureGrid(motor_arm_mm, motor_arm_root_mm, grid_size_factor);

        if (create_rib_voids)
            CreateRibVoids();

        if (spar_hole)
            motor_arm_spar_voids();

        CreateGridVoid();
    }
}


//-----------------------------------------------------------
// SPAR VOID
//-----------------------------------------------------------
module motor_arm_spar_voids() {
    CreateSparVoid(0, spar_hole_offset, spar_hole_perc, spar_hole_size,
                   spar_hole_length, motor_arm_root_mm, spar_hole_void_clearance, spar_flip_side_1);
}


//-----------------------------------------------------------
// ADD-ONS (spar holes, connectors, servos…)
//-----------------------------------------------------------
module motor_arm_addons() {
    union() {
        if (spar_hole)
            CreateSparHole(0, spar_hole_offset, spar_hole_perc, spar_hole_size,
                           spar_hole_length, motor_arm_root_mm, slice_gap_width,
                           spar_circles_nb, spar_circle_holder, spar_flip_side_1);

        if (create_servo_void)
            servo_block();
    }
}


//-----------------------------------------------------------
// MAIN CENTER PART MODULE
//-----------------------------------------------------------
module center_part_main() {
    intersection() {
        difference() {
            center_shell();
            if (add_inner_grid) center_inner_grid();
        }
        center_addons();
    }
}


//-----------------------------------------------------------
// OUTER SHELL
//-----------------------------------------------------------
module center_shell() {
    CreateCenterPart();
}


//-----------------------------------------------------------
// INTERNAL STRUCTURE
//-----------------------------------------------------------
module center_inner_grid() {
    difference() {
        StructureGrid(center_mm, center_root_chord_mm, grid_size_factor);

        if (create_rib_voids)
            CreateRibVoids();

        if (spar_hole)
            center_spar_voids();

        CreateGridVoid();
    }
}


//-----------------------------------------------------------
// SPAR VOIDS
//-----------------------------------------------------------
module center_spar_voids() {
    CreateSparVoid(0, spar_hole_offset, spar_hole_perc, spar_hole_size,
                   spar_hole_length, center_root_chord_mm, spar_hole_void_clearance, spar_flip_side_1);

    CreateSparVoid(0, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2,
                   spar_hole_length_2, center_root_chord_mm, spar_hole_void_clearance_2, spar_flip_side_2);
}


//-----------------------------------------------------------
// ADD-ON PARTS
//-----------------------------------------------------------
module center_addons() {
    union() {
        if (spar_hole)
            CreateSparHole(0, spar_hole_offset, spar_hole_perc, spar_hole_size,
                           spar_hole_length, center_root_chord_mm, slice_gap_width,
                           spar_circles_nb, spar_circle_holder, spar_flip_side_1);

        if (spar_hole_2)
            CreateSparHole(0, spar_hole_offset_2, spar_hole_perc_2, spar_hole_size_2,
                           spar_hole_length_2, center_root_chord_mm, slice_gap_width,
                           spar_circles_nb, spar_circle_holder, spar_flip_side_2);

        if (create_servo_void)
            servo_block();
    }
}
*/
