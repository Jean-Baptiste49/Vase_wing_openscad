extra_spar_hole_bot_offset=0.2;

module CreateSparHole(sweep_ang, hole_offset, hole_perc, hole_size, hole_length, wing_root_chord, slice_gap)
{
    translate([ 0, hole_offset, 0 ]) union()
    {
        translate([ hole_perc / 100 * wing_root_chord, 0, 0 ]) difference()
        {
            translate([ 0, hole_size / 2 - (slice_gap/2), 0 ]) 
            rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep 
            cube([ slice_gap, 50, hole_length + 10 ]);

            translate([ -5, hole_size / 2, hole_length ]) rotate([ 35, 0, 0 ]) 
            rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep 
            cube([ 10, 50, 20 ]);
        }

        color("red") translate([ hole_perc / 100 * wing_root_chord, 0, 0 ])
            rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep    
            cylinder(h = hole_length, r = hole_size / 2);
    }
}

module CreateSparVoid(sweep_ang, hole_offset, hole_perc, hole_size, hole_length, wing_root_chord, hole_void_clearance)
{   
    translate([ 0, hole_offset - extra_spar_hole_bot_offset, 0 ]) 
    union()
    {
        color("blue") 
        translate([ hole_perc / 100 * wing_root_chord, 0, 0 ])
        rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep
            cylinder(h = hole_length, r = hole_size / 2 + (hole_void_clearance / 2));
        color("brown") 
        translate([ hole_perc / 100 * wing_root_chord - ((hole_size + hole_void_clearance)/2), 0, 0 ])
        rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep
        cube([ hole_size + hole_void_clearance, 100, hole_length ]);
    }
  }