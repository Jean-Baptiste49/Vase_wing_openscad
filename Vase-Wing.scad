// RC wing generator for Vase mode printing
//
// Prior work used to create this script:
// https://www.thingiverse.com/thing:3506692
// https://github.com/guillaumef/openscad-airfoil

// Module for root airfoil polygon
//include <lib/openscad-airfoil/s/s2027.scad>
include <lib/openscad-airfoil/m/m18.scad>


// Wing airfoils
af_vec_path_root =             airfoil_M18_path();
af_vec_path_mid  =             airfoil_M18_path();
af_vec_path_tip  =             airfoil_M18_path();
module RootAirfoilPolygon() {  airfoil_M18();  }
module MidAirfoilPolygon()  {  airfoil_M18();  }
module TipAirfoilPolygon()  {  airfoil_M18();  }


// TODO 
// ailerons : void with TE + and pin accroche + Ailerons create
// Emprunte servo perso
// Seperation root mid etc ?

// Custom airfoil profil = Murat ?

//*******************END***************************//

//****************Global Variables*****************//

$fa = 5; // 360deg/5($fa) = 60 facets this affects performance and object shoothness
$fs = 1; // Min facet size

slice_ext_width = 0.6;//Used for some of the interfacing and gap width values
slice_gap_width = 0.01;//This is the gap in the outer skin.(smaller is better but is limited by what your slicer can recognise)

wing_mode = 2; // 1=trapezoidal wing 2= elliptic wing

wing_sections = 20; //39; // how many sections you would like to break up the wing into more is higher resolution but higher processing
wing_mm = 417;            // wing length in mm
wing_root_chord_mm = 228.2; // Root chord legth in mm
wing_tip_chord_mm = 38.3;   // wing tip chord length in mm (Not relevant for elliptic wing); //

wing_center_line_perc = 70; // Percentage from the leading edge where you would like the wings center line

//****************Wing Airfoil settings**********//
center_airfoil_change_perc = 100; // Where you want to change to the center airfoil 100 is off
tip_airfoil_change_perc = 100;    // Where you want to change to the tip airfoil 100 is off
slice_transisions = 0; // This is the number of slices that will be a blend of airfiols when airfoil is changed 0 is off
//******//

//****************Wing Washout settings**********//
washout_deg = 2;         // how many degrees of washout you want 0 for none
washout_start = 60;      // where you would like the washout to start in mm from root
washout_pivot_perc = 25; // Where the washout pivot point is percent from LE
//******//

//****************Wing Sweep settings**********//
use_custom_lead_edge_sweep = true;
// ([z , x]
lead_edge_sweep = [
  [0, 0],       
  [100, 50],     
  [200, 100],     
  [300, 150],     
  [350, 175],    
  [417, 210]      
];
//******//

//****************Wing Y curve settings**********//
use_custom_lead_edge_curve = true; 
curve_amplitude = 0.15;
// ([z , y]
lead_edge_curve_y = [
  [0,     0],
  [100,   0],
  [200,   0],
  [250,   0],
  [275,   0],
  [300,   0],
  [320,   25],
  [340,  50],
  [360,  100],
  [370,  140], 
  [375,  170],    
  [380,  180],
  [385,  230],  
  [390,  280],
  [395,  330],  
  [400,  380],
  [405,  430],
  [410,  480],
  [412,  500],
  [414,  530],
  [417,  550]
];
//******//

add_inner_grid = true; // true if you want to add the inner grid for 3d printing

grid_mode = 2;           // Grid mode 1=diamond 2= spar and cross spars
create_rib_voids = false; // add holes to the ribs to decrease weight

//****************Grid mode 1 settings**********//
grid_size_factor = 2; // changes the size of the inner grid blocks
//******//

//****************Grid mode 2 settings**********//
spar_num = 3;     // Number of spars for grid mode 2
spar_offset = 15; // Offset the spars from the LE/TE
rib_num = 6;      // Number of ribs
rib_offset = 1;   // Offset
//******//

//****************Carbon Spar settings**********//
spar_hole = false;                // Add a spar hole into the wing
spar_hole_perc = 35;             // Percentage from leading edge
spar_hole_size = 5;              // Size of the spar hole
spar_hole_length = 200;          // lenth of the spar in mm
spar_hole_offset = 4;            // Adjust where the spar is located
spar_hole_void_clearance = 1; // Clearance for the spar to grid interface(at least double extrusion width is usually needed)

spar_hole_perc_2 = 60;             // Percentage from leading edge
spar_hole_size_2 = 5;              // Size of the spar hole
spar_hole_length_2 = 200;          // lenth of the spar in mm
spar_hole_offset_2 = 3;            // Adjust where the spar is located
spar_hole_void_clearance_2 = 1; 
//******//

//****************Servo settings**********//
create_servo_void = false; // It is important to check that your servo placement doesnt create any artifacts(You can
// comment out the CreateWing() function to assist)
servo_type = 1;           // 1=3.7g 2=5g 3=9g
servo_dist_root_mm = 100; // servo placement from root
servo_dist_le_mm = 64;    // servo placement from the leading edge
servo_rotate_z_deg = -7;  // degrees to rotate on z axis
servo_dist_depth_mm = 10; // offset the servo into or out of the wing till you dont see red
servo_show = false;       // for debugging only. Show the servo for easier placement
//******//

//****************Aileron settings**********//
create_aileron = true; // Create an Aileron
aileron_root_width = 50;    //The aileron width from the TE on the root side
aileron_tip_width = 40;    //The aileron width from the TE on the tip side
aileron_length = 60;      //How long to make the aileron
aileron_start = 40;        //How far from the root should the aileron start
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


    
module main()
{
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
                                        CreateSparVoid();
                                        CreateSparVoid_2();
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
                CreateSparHole();
                CreateSparHole_2();
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

    main();
    CreateAileronVoid();
    //points_te = get_trailing_edge_points();     
    //show_trailing_edge_points(points_te);





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