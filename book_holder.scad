use <Tesselation_4_Customizer.scad>
use <lasercut/lasercut.scad>

$fn = 30;


// unit = mm
m_thickness = 3;
w_book = 190;
h_book = 250;
th_book = 20;
r_corner_book = 10;
slack = 1;

bend_radius = (th_book+0.5*m_thickness)*PI;

notches([2*w_book+bend_radius, h_book, m_thickness], 30, 3, 15,4)
    add_new_hinge(size_x=bend_radius, size_y = h_book, num_holes_x =17, mat_x = 2.5,mat_y = 3,min_hole_x = 1)
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

function select(vector,indices) = [ for (index = indices) vector[index] ];


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
