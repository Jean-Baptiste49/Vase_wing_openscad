module WashoutSlice(index, current_chord_mm, local_wing_sections)
{

    washout_start_point = (wing_mode == 1) ? (local_wing_sections * (washout_start / 100))
                                           : WashoutStart(0, local_wing_sections, washout_start, wing_mm);
    washout_deg_frac = washout_deg / (local_wing_sections - washout_start_point);
    washout_deg_amount = (washout_start_point - index) * washout_deg_frac;
    rotate_point = current_chord_mm * (washout_pivot_perc / 100);

    translate([ rotate_point, 0, 0 ]) rotate(washout_deg_amount) translate([ -rotate_point, 0, 0 ])

        Slice(index, local_wing_sections);
}

module Slice(index, local_wing_sections)
{
    tip_airfoil_change_index = local_wing_sections * (tip_airfoil_change_perc / 100);
    center_airfoil_change_index = local_wing_sections * (center_airfoil_change_perc / 100);

    if (tip_airfoil_change_perc < 100 && (index > (tip_airfoil_change_index - slice_transisions) &&
                                          index < (tip_airfoil_change_index + slice_transisions)))
    {
        projection()
        {
            intersection()
            {
                hull()
                {
                    translate([ 0, 0, -10 ]) linear_extrude(height = 0.00000001, slices = 0) MidAirfoilPolygon();

                    translate([ 0, 0, 10 ]) linear_extrude(height = 0.00000001, slices = 0) TipAirfoilPolygon();
                }
            }
        }
    }
    else if (index > tip_airfoil_change_index)
    {
        TipAirfoilPolygon();
    }
    else if (center_airfoil_change_perc < 100 && (index > (center_airfoil_change_index - slice_transisions) &&
                                                  index < (center_airfoil_change_index + slice_transisions)))
    {
        projection()
        {
            intersection()
            {
                hull()
                {
                    translate([ 0, 0, -10 ]) linear_extrude(height = 0.00000001, slices = 0) RootAirfoilPolygon();

                    translate([ 0, 0, 10 ]) linear_extrude(height = 0.00000001, slices = 0) MidAirfoilPolygon();
                }
            }
        }
    }
    else if (index > center_airfoil_change_index)
    {
        MidAirfoilPolygon();
    }
    else
    {
        RootAirfoilPolygon();
    }
}

module WingSlice(index, z_location, local_wing_sections)
{
    current_chord_mm = (wing_mode == 1) ? ChordLengthAtIndex(index, local_wing_sections)
                                        : ChordLengthAtEllipsePosition((wing_mm + 0.1), wing_root_chord_mm, z_location);
    scale_factor = current_chord_mm / 100;

    translate([ 0, 0, z_location ]) linear_extrude(height = 0.00000001, slices = 0)
        translate([ -wing_center_line_perc / 100 * current_chord_mm, 0, 0 ])
            scale([ scale_factor, scale_factor,
                    1 ]) if (washout_deg > 0 &&
                             ((wing_mode > 1 && index > WashoutStart(0, local_wing_sections, washout_start, wing_mm)) ||
                              (wing_mode == 1 && index > (local_wing_sections * (washout_start / 100)))))
    {
        WashoutSlice(index, current_chord_mm, local_wing_sections);
    }
    else
    {
        Slice(index, local_wing_sections);
    }
}

module CreateWing(low_res = false)
{
    local_wing_sections = low_res ? floor(wing_sections / 3) : wing_sections;
    wing_section_mm = wing_mm / local_wing_sections;

    if (wing_mode == 1)
    {
        translate([ wing_root_chord_mm * (wing_center_line_perc / 100), 0, 0 ]) union()
            {
        for (i = [0:local_wing_sections - 1])
        {
            x0 = wing_section_mm * i;
            x1 = wing_section_mm * (i + 1);

            y0 = use_custom_lead_edge_curve ? interpolate_y(x0) * curve_amplitude : 0;
            y1 = use_custom_lead_edge_curve ? interpolate_y(x1) * curve_amplitude : 0;

            x_off0 = use_custom_lead_edge_sweep ? interpolate_x(x0) : 0;
            x_off1 = use_custom_lead_edge_sweep ? interpolate_x(x1) : 0;

            hull()
            {
                //translate([x_off0, y0, x0])
                translate([x_off0, y0, 0])
                    WingSlice(i, x0, local_wing_sections);
                //translate([x_off1, y1, x1])
                translate([x_off1, y1, 0])
                    WingSlice(i + 1, x1, local_wing_sections);
            }
        }
        }
    }
    else
    {
        for (i = [0:local_wing_sections - 1])
        {
            pos = f(i, local_wing_sections, wing_mm);
            npos = f(i + 1, local_wing_sections, wing_mm);

            y0 = use_custom_lead_edge_curve ? interpolate_y(pos) * curve_amplitude : 0;
            y1 = use_custom_lead_edge_curve ? interpolate_y(npos) * curve_amplitude : 0;

            x_off0 = use_custom_lead_edge_sweep ? interpolate_x(pos) : 0;
            x_off1 = use_custom_lead_edge_sweep ? interpolate_x(npos) : 0;
            translate([ wing_root_chord_mm * (wing_center_line_perc / 100), 0, 0 ]) union()
            {
            hull()
            {
                translate([x_off0, y0, 0])
                    WingSlice(i, pos, local_wing_sections);
                translate([x_off1, y1, 0])
                    WingSlice(i + 1, npos, local_wing_sections);
            }
        }
        }
    }
}

//****************Tools function for interpolation**********//
// Y interpolation function from X (simple linear)
function interpolate_x(z) =
    let(
        i = search_index_z(lead_edge_sweep, z)
    )
    i == -1 ? 0 :
    let(
        z0 = lead_edge_sweep[i][0],
        x0 = lead_edge_sweep[i][1],
        z1 = lead_edge_sweep[i+1][0],
        x1 = lead_edge_sweep[i+1][1]
    )
    x0 + (z - z0) * (x1 - x0) / (z1 - z0);

function search_index_z(arr, z) = 
    (z < arr[0][0] || z > arr[len(arr)-1][0]) ? -1 :
    search_index_helper_z(arr, z, 0);

function search_index_helper_z(arr, z, i) = 
    (i >= len(arr) - 1) ? len(arr) - 2 :
    (z >= arr[i][0] && z < arr[i+1][0]) ? i :
    search_index_helper_z(arr, z, i + 1);
    
    
function interpolate_y(z) = let(i = search_index_z_y(lead_edge_curve_y, z))
    i == -1 ? 0 :
    let(z0 = lead_edge_curve_y[i][0], y0 = lead_edge_curve_y[i][1],
        z1 = lead_edge_curve_y[i+1][0], y1 = lead_edge_curve_y[i+1][1])
      y0 + (z - z0) * (y1 - y0)/(z1 - z0);

function search_index_z_y(arr, z) = 
    (z < arr[0][0] || z > arr[len(arr)-1][0]) ? -1 : search_index_helper_z_y(arr, z, 0);

function search_index_helper_z_y(arr, z, i) =
    (i >= len(arr)-1) ? len(arr)-2 :
    (z >= arr[i][0] && z < arr[i+1][0]) ? i :
    search_index_helper_z_y(arr, z, i+1);  
    
 
//****************Tools function for Trailing Edge points retrieval  **********// 
function rotate2D(pt, angle_deg, pivot) =
    let (
        angle = angle_deg * PI / 180,
        dx = pt[0] - pivot,
        dy = pt[1],
        x_rot = cos(angle) * dx - sin(angle) * dy + pivot,
        y_rot = sin(angle) * dx + cos(angle) * dy
    )
    [ x_rot, y_rot ];

    
function trailing_edge_point(index, local_wing_sections) =
    let (
        // Position envergure
        z = (wing_mode == 1) ? (index * wing_mm / local_wing_sections)
                             : f(index, local_wing_sections, wing_mm),

        // Length chord
        chord = (wing_mode == 1) ? ChordLengthAtIndex(index, local_wing_sections)
                                 : ChordLengthAtEllipsePosition((wing_mm + 0.1), wing_root_chord_mm, z),

        // Washout
        washout_start_point = (wing_mode == 1)
                                ? (local_wing_sections * (washout_start / 100))
                                : WashoutStart(0, local_wing_sections, washout_start, wing_mm),
        washout_deg_frac = (local_wing_sections - washout_start_point > 0) ? (washout_deg / (local_wing_sections - washout_start_point)) : 0,
        washout_deg_amount = (index > washout_start_point) ? (index - washout_start_point) * washout_deg_frac : 0,
        washout_pivot = chord * (washout_pivot_perc / 100),

        // Raw TE point (in untransformed 2D profile)
        x_te = chord,
        y_te = 0,

        //String center: translate by percentage of string center
        x_local = x_te - (wing_center_line_perc / 100) * chord,
        y_local = y_te,

        //Apply washout if necessary
        rotated = (washout_deg_amount != 0)
                    ? rotate2D([x_local, y_local], washout_deg_amount, washout_pivot - (wing_center_line_perc / 100) * chord)
                    : [x_local, y_local],

        //Sweep (X offset) and curve (Y offset)
        x_sweep = use_custom_lead_edge_sweep ? interpolate_x(z) : 0,
        y_curve = use_custom_lead_edge_curve ? interpolate_y(z) * curve_amplitude : 0,

        //Global translation to align with the rest of the wing
        global_offset = [ wing_root_chord_mm * (wing_center_line_perc / 100), 0, 0 ],

        //End point with global offset
        point = [rotated[0] + x_sweep, rotated[1] + y_curve, z] + global_offset
    )
    point;
 

module show_trailing_edge_points(points) {
    for (p = points)
        translate(p) color("red") sphere(r = 1.5);
}
function get_trailing_edge_points(local_wing_sections = wing_sections) =
    [ for (i = [0 : local_wing_sections]) trailing_edge_point(i, local_wing_sections) ];
       
   
    
//****************Old CreateWing Module**********// 
/*
module CreateWing(low_res = false)
{
    local_wing_sections = low_res ? floor(wing_sections / 3) : wing_sections;
    wing_section_mm = wing_mm / local_wing_sections;
    if (wing_mode == 1)
    {
        translate([ wing_root_chord_mm * (wing_center_line_perc / 100), 0, 0 ]) union()
        {
            for (i = [0:local_wing_sections - 1])
            {
                hull()
                {
                    WingSlice(i, wing_section_mm * i, local_wing_sections);
                    WingSlice(i + 1, wing_section_mm * (i + 1), local_wing_sections);
                }
            }
        }
    }
    else
    {
        for (i = [0:local_wing_sections])
        {
            pos = f(i, local_wing_sections, wing_mm);
            npos = f(i + 1, local_wing_sections, wing_mm);
            translate([ wing_root_chord_mm * (wing_center_line_perc / 100), 0, 0 ]) union()
            {
                hull()
                {
                    WingSlice(i, pos, local_wing_sections);
                    WingSlice(i + 1, npos, local_wing_sections);
                }
                // color("red")
                // translate([0,0,pos])
                // sphere(3);
            }
        }
    }
}*/