extra_spar_hole_bot_offset=0.2;

module CreateSparHole(sweep_ang, hole_offset, hole_perc, hole_size, hole_length, wing_root_chord, slice_gap, spar_flip_side = false)
{
    //Here we rotate of 180 deg if requested to flip to other side
    flip_side = spar_flip_side ? 180 : 0;
    
    translate([ 0, hole_offset, 0 ]) union()
    {
        translate([ hole_perc / 100 * wing_root_chord, 0, 0 ]) difference()
        {
            color("blue")
                translate([ 0, hole_size / 2 - (slice_gap/2), 0 ]) 
                    rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep 
                        rotate([ 0, 0, flip_side ]) //rotation to flip from on side to the other with 
                            cube([ slice_gap, 50, hole_length + 10 ]);

            color("green")
                translate([ -5, hole_size / 2, hole_length ]) rotate([ 35, 0, 0 ]) 
                    rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep 
                        cube([ 10, 50, 20 ]);
        }

        color("red") translate([ hole_perc / 100 * wing_root_chord, 0, 0 ])
            rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep    
                cylinder(h = hole_length, r = hole_size / 2);
    }
}

module CreateSparVoid(sweep_ang, hole_offset, hole_perc, hole_size, hole_length, wing_root_chord, hole_void_clearance, spar_flip_side = false)
{   
    
    void_width = 100;
    //Here we offset of void width if requested to flip to other side
    flip_side = spar_flip_side ? void_width : 0;
    
    translate([ 0, hole_offset - extra_spar_hole_bot_offset, 0 ]) 
    union()
    {
        color("blue") 
            translate([ hole_perc / void_width * wing_root_chord, 0, 0 ])
                rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep
                    cylinder(h = hole_length, r = hole_size / 2 + (hole_void_clearance / 2));
        
        color("brown") 
            translate([ hole_perc / void_width * wing_root_chord - ((hole_size + hole_void_clearance)/2), -flip_side, 0 ])
                rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep
                    cube([ hole_size + hole_void_clearance, void_width, hole_length ]);
    }
}

module CreateSparHole_center(sweep_ang, hole_offset, hole_perc, hole_size, hole_length, wing_root_chord, ct_width)
{
    translate([ 0, hole_offset, 0 ])    
        color("red") translate([ hole_perc / 100 * wing_root_chord, 0, 0 ])
            rotate([ 0, sweep_ang, 0 ]) //Spar angle rotation to follow the sweep    
                translate([ 0, 0, - ct_width/2 ])    
                    cylinder(h = hole_length, r = hole_size / 2);

}