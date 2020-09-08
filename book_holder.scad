
$fn = 30;


// unit = mm
m_thickness = 3.01;
w_book = 190;
h_book = 256;
th_book = 20+m_thickness;
r_corner_book = 10;
slack = 1;

bend_radius = ((th_book+0.5*m_thickness)*PI)/2;

notches([2*w_book+bend_radius, h_book, m_thickness], 30, 3, 15,4)
    add_new_hinge(size_x=bend_radius, size_y = h_book,size_z = m_thickness, num_holes_x =15, mat_x = 2,mat_y = 3,min_hole_x = 0.02 )
        rounded_sheet([2*w_book+bend_radius, h_book, m_thickness], r_corner_book, center = true);

//thickness = 3;
//x = 50;
//y = 100;
//points = [[0,0], [x,0], [x,y], [x/2,y], [x/2,y/2], [0,y/2], [0,0]];
//lasercutout(thickness=thickness, points = points);

module notches(size, dist_from_edge, notch_height, notch_width, r = 5){
    dfe = dist_from_edge;
    nh = notch_height;
    nw = notch_width;
    
    t=[[ size[0]/2 - dfe, size[1]/2-0.5*nh,0],
       [-size[0]/2 + dfe, size[1]/2-0.5*nh,0],
       [ size[0]/2 - dfe,-size[1]/2+0.5*nh,0],
       [-size[0]/2 + dfe,-size[1]/2+0.5*nh,0]];
    
    s=[[0,0,1,1],[0,0,1,1],[1,1,0,0],[1,1,0,0]];
    
    difference(){
        children();
        for(i=[0:3]){
            translate(t[i]) 
                rounded_sheet([nw, nh,size[2]],r,sides=s[i]);
                    
        }
    }
}

    
module new_hinge(size_x = 50, 
                 size_y = 100,
                 size_z = 3,
                 num_holes_x = 13, 
                 num_holes_y = 3, 
                 mat_x = 2,
                 mat_y = 3,
                 min_hole_x = 1.5, 
                 center=true){
    $fn = 30;
    ep = 0.00101;
    v_center=center?-[size_x,size_y,size_z]/2:[0,0,0];//a vector for adjusting the center position
    
    sum_hole_width = size_x - mat_x*(num_holes_x-1);
    hw = sum_hole_width/num_holes_x ;
    hole_width = hw < min_hole_x ? ep : (sum_hole_width/num_holes_x);               
    mat_x = hw < min_hole_x ? size_x/num_holes_x : mat_x;
        
    sum_hole_length = size_y - mat_y*(num_holes_y+1);
    hole_length = sum_hole_length/(num_holes_y);
    
    translate(v_center) difference(){
        // create a square and cut out a bunch of holes to form the hinge
        cube([size_x,size_y,size_z],center = false);
        
        //A hinge with hinges_across_length=2 should look like:
            // |----------  ------------------  ----------|
            // |  ------------------  ------------------  |
            // |----------  ------------------  ----------|
            // |  ------------------  ------------------  |
        
        // go chroug each of the major lines
        for (x=[0:num_holes_x-1]){
            translate([x*(mat_x+hole_width) + hole_width/2 ,0,0]){
                
                // go throug each of the individual cutouts. 
                for(y=[0:num_holes_y]){
                    translate([0,y*(hole_length + mat_y) - (x%2)*(hole_length/2) + mat_y, 0])
                        
                        // cutout a hole with nice rounded edges. 
                        hull(){
                            cylinder(size_z, r = hole_width/2);
                            translate([0,hole_length]) cylinder(size_z, r = hole_width/2);
                        };
                        
                }
            }
        }        
    }  
}


module rounded_sheet(size, radius, center = true, sides=[1,1,1,1]){
     t = center ? [[ size[0]/2, size[1]/2, 0],
                  [-size[0]/2,  size[1]/2, 0],
                  [ size[0]/2, -size[1]/2, 0],
                  [-size[0]/2, -size[1]/2, 0]]
                :
                 [[ size[0], size[1], size[2]/2],
                  [       0, size[1], size[2]/2],
                  [ size[0], 0      , size[2]/2],
                  [       0, 0      , size[2]/2]];
    r = [180,-90, 90, 0];
    
    difference(){
        cube(size, center=center);
        for(i=[0:3]) if(sides[i])
        {
            translate(t[i]) rotate([0,0,r[i]]) fillet(radius, size[2]);           
        }
    }
}


module fillet(r,thickness) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01,thickness], center = true);

            translate([r/2, r/2, 0])
                cylinder(r =r,h=thickness, center = true);
        }
}


module add_new_hinge(size_x = 50, 
                     size_y = 100, 
                     size_z = 2,
                     num_holes_x = 13, 
                     num_holes_y = 3, 
                     mat_x = 2,
                     mat_y = 3,
                     min_hole_x = 2, 
                     center=true){
    //add_hinge() modifies another 2D object, by adding a hinge which is centered on the origin (by default, this can be changed to false, so that the bottom left corner of the hinge is at the origin. It uses the same parameters as hinge(). 
    //First, difference() a rectangle the size of the hinge from the child object (makes a hole for the hinge
    //Second, union() a hinge with First (puts the hinge in the hole)
    //Third, intersection() the child object with Second (cuts off any extra hinge that sticks out past the child object)
    ep = 0.00101;
            difference(){
                children();
                cube([size_x,size_y,size_z],center=center);
            }
            new_hinge(size_x = size_x, 
                      size_y = size_y, 
                      size_z = size_z,
                      num_holes_x = num_holes_x, 
                      num_holes_y = num_holes_y, 
                      mat_x = mat_x,
                      mat_y = mat_y,
                      min_hole_x = min_hole_x, 
                      center=center);
    
    
}  
