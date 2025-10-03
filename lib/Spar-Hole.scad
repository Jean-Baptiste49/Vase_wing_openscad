extra_spar_hole_bot_offset=0.2;

module CreateSparHole(spar_sweep_angle)
{
    translate([ 0, spar_hole_offset, 0 ]) union()
    {
        translate([ spar_hole_perc / 100 * wing_root_chord_mm, 0, 0 ]) difference()
        {
            translate([ 0, spar_hole_size / 2 - (slice_gap_width/2), 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep 
            cube([ slice_gap_width, 50, spar_hole_length + 10 ]);

            translate([ -5, spar_hole_size / 2, spar_hole_length ]) rotate([ 35, 0, 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep 
            cube([ 10, 50, 20 ]);
        }

        color("red") translate([ spar_hole_perc / 100 * wing_root_chord_mm, 0, 0 ])
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep    
            cylinder(h = spar_hole_length, r = spar_hole_size / 2);
    }
}

module CreateSparVoid(spar_sweep_angle)
{   
    translate([ 0, spar_hole_offset-extra_spar_hole_bot_offset, 0 ]) 
    union()
    {
        color("blue") 
        translate([ spar_hole_perc / 100 * wing_root_chord_mm, 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = spar_hole_length, r = spar_hole_size / 2 + (spar_hole_void_clearance / 2));
        color("brown") 
        translate([ spar_hole_perc / 100 * wing_root_chord_mm - ((spar_hole_size + spar_hole_void_clearance)/2), 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
        cube([ spar_hole_size + spar_hole_void_clearance, 100, spar_hole_length ]);
    }
  }
  
module CreateSparHole_2(spar_sweep_angle)
{
    translate([ 0, spar_hole_offset_2, 0 ]) union()
    {
        translate([ spar_hole_perc_2 / 100 * wing_root_chord_mm, 0, 0 ]) difference()
        {
            translate([ 0, spar_hole_size_2 / 2 - (slice_gap_width/2), 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cube([ slice_gap_width, 50, spar_hole_length_2 + 10 ]);

            translate([ -5, spar_hole_size_2 / 2, spar_hole_length_2 ]) rotate([ 35, 0, 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cube([ 10, 50, 20 ]);
        }

        color("red") translate([ spar_hole_perc_2 / 100 * wing_root_chord_mm, 0, 0 ])
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = spar_hole_length_2, r = spar_hole_size_2 / 2);
    }
}

module CreateSparVoid_2(spar_sweep_angle)
{

    translate([ 0, spar_hole_offset_2-extra_spar_hole_bot_offset, 0 ]) 
    union()
    {
        color("green") 
        translate([ spar_hole_perc_2 / 100 * wing_root_chord_mm, 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = spar_hole_length_2, r = spar_hole_size_2 / 2 + (spar_hole_void_clearance_2 / 2));
        color("red") 
        translate([ spar_hole_perc_2 / 100 * wing_root_chord_mm - ((spar_hole_size_2 + spar_hole_void_clearance_2)/2), 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
        cube([ spar_hole_size_2 + spar_hole_void_clearance_2, 100, spar_hole_length_2 ]);
    }
  }

module CreateSparHole_3(spar_sweep_angle)
{
    translate([ 0, spar_hole_offset_3, 0 ]) union()
    {
        translate([ spar_hole_perc_3 / 100 * wing_root_chord_mm, 0, 0 ]) difference()
        {
            translate([ 0, spar_hole_size_3 / 2 - (slice_gap_width/2), 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cube([ slice_gap_width, 50, spar_hole_length_3 + 10 ]);

            translate([ -5, spar_hole_size_3 / 2, spar_hole_length_3 ]) rotate([ 35, 0, 0 ]) 
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cube([ 10, 50, 20 ]);
        }

        color("red") translate([ spar_hole_perc_3 / 100 * wing_root_chord_mm, 0, 0 ])
            rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = spar_hole_length_3, r = spar_hole_size_3 / 2);
    }
}

module CreateSparVoid_3(spar_sweep_angle)
{

    translate([ 0, spar_hole_offset_3-extra_spar_hole_bot_offset, 0 ]) 
    union()
    {
        color("green") 
        translate([ spar_hole_perc_3 / 100 * wing_root_chord_mm, 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = spar_hole_length_3, r = spar_hole_size_3 / 2 + (spar_hole_void_clearance_3 / 2));
        color("red") 
        translate([ spar_hole_perc_3 / 100 * wing_root_chord_mm - ((spar_hole_size_3 + spar_hole_void_clearance_3)/2), 0, 0 ])
        rotate([ 0, spar_sweep_angle, 0 ]) //Spar angle rotation to follow the sweep
        cube([ spar_hole_size_3 + spar_hole_void_clearance_3, 100, spar_hole_length_3 ]);
    }
  }  