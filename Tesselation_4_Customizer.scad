//Living Hinge
//Ari M Diacou
//Metis Industries
//August 2016

//Thanks to Ronaldo Persiano for the inspiration for add_hinge() and tesselation_hinge()

///////////////////////////// Parameters /////////////////////////////////////
/* [Array dimensions] */
//The y dimension of the hinge, parallel to the laser cuts
length=30;
//The x dimension of the hinge, transverse to laser cuts
width=40;
//Number of objects in x direction
num_in_x=6;
//Number of objects in y direction
num_in_y=8;
//How thick do you want the hinge to be
height=.1;
//The character you want to tesselate(only first)
my_character="+";
//The type of the array you want
array_type="hexagonal";//[square,hexagonal,triangular]

/* [Transformations] */
//By how many degrees do you want to rotate the object?
theta=0;
//The percentage of a cell's height that should not be filled by the object
x_padding_percentage=10;//[0,1,2,3,4,5,10,15,20,25,30,40,50,60,70,80,90]
//The percentage of a cell's width that should not be filled by the object
y_padding_percentage=0;//[0,1,2,3,4,5,10,15,20,25,30,40,50,60,70,80,90]
//The percentage of a cell's width that an object should be translated
x_shift_adjustment=-30;//[-50,-40,-30,-25,-20,-10,-5,-4,-3,2-,-1,0,1,2,3,4,5,10,15,20,25,30,40,50]
//The percentage of a cell's height that an object should be translated
y_shift_adjustment=-15;//[-50,-40,-30,-25,-20,-10,-5,-4,-3,2-,-1,0,1,2,3,4,5,10,15,20,25,30,40,50]

///////////////////////////////// Main() //////////////////////////////////////
//preview[view:north, tilt:top]
//cell_x=width/num_in_x;
//cell_y=length/num_in_y;
//my_text=my_character[0];
//linear_extrude(height) 
//    tesselation_hinge(  
//        num=[num_in_x,num_in_y], 
//        size=[width,length],
//        padding=[x_padding_percentage*cell_x/100,y_padding_percentage*cell_y/100],
//        type=array_type
//        ) 
//        translate([x_shift_adjustment*cell_x/100,y_shift_adjustment*cell_y/100])  
//            rotate(theta)
//                text(my_text,valign="center",halign="center");

////Uncomment lines to see Examples (all flat for DXF exporting)
///////////////////////////// Hinge() ///////////////////////////////////////
//new_hinge();
//add_new_hinge(size_x = 50,size_y = 200, size_z = 2,center=true) cube([200,200,2 ],center = true);


//////////////////////////// Tesselate() ////////////////////////////////////
//tesselate(num=[3,6], size=[3,2],padding=[.1,.1],type="hex") rotate(30) circle($fn=6);
//tesselate(num=[3,6], size=[2,1],padding=[.4,.1],type="tri") translate([-.1,-.1]) text("T",valign="center",halign="center");
//tesselate(num=[6,6], size=[2,.7071],padding=[0.01,.01],type="tri") translate([0,.25]) rotate(30)  circle($fn=3);
//tesselate(num=[8,6], size=[2,1],padding=[.6,.1],type="tri") translate([-.1,-.1]) rotate(25) text("y",valign="center",halign="center");
//tesselate(num=[6,8], size=[1.5,1],padding=[.6,.1],type="hex") translate([-.1,-.1])  text("+",valign="center",halign="center");
//////////////////////// Tesselation_Hinge() ////////////////////////////////
//tesselation_hinge(num=[6,8], size=[9,6],padding=[.6,.1],type="hex") translate([-.1,-.1])  text("+",valign="center",halign="center");
//tesselation_hinge(size=[4,5],num=[3,6],padding=[.1,.4],type="hex") translate([-.8,-.5])square(); //running bond bricks
//tesselation_hinge(size=[4,5],num=[4,5],padding=[.1,.1],type="tri") translate([0,.28])rotate(30) circle($fn=3);
//tesselation_hinge(size=[4,5],num=[4,5],padding=[.7,.1],type="tri") translate([-.1,-.1]) rotate(5) text("t",valign="center",halign="center");
//tesselation_hinge(num=[3,6], size=[3,6],padding=[.4,.1],type="tri") translate([-.1,-.1]) text("T",valign="center",halign="center");
//tesselation_hinge(size=[6,6],num=[6,6],padding=[.2,.2],type="hex") rotate(30) circle($fn=6);


    
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
        
        for (x=[0:num_holes_x-1]){
            translate([x*(mat_x+hole_width) ,0,0]){
                for(y=[0:num_holes_y]){
                    translate([0,y*(hole_length + mat_y) - (x%2)*(hole_length/2) + mat_y, 0])
                        rounded_sheet([hole_width,hole_length,size_z], radius = hole_width/2, center = false);
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
    render() intersection(){
        children();
        union(){
            new_hinge(size_x = size_x, 
                      size_y = size_y, 
                      size_z = size_z,
                      num_holes_x = num_holes_x, 
                      num_holes_y = num_holes_y, 
                      mat_x = mat_x,
                      mat_y = mat_y,
                      min_hole_x = min_hole_x, 
                      center=center);
            difference(){
                children();
                cube([size_x,size_y,size_z],center=center);
            }
        }
    }
    
}  

module add_hinge(size=[20,30],d=3,minimum_thinness=3,hinge_length=3,hinges_across_length=2,center=true){
    //add_hinge() modifies another 2D object, by adding a hinge which is centered on the origin (by default, this can be changed to false, so that the bottom left corner of the hinge is at the origin. It uses the same parameters as hinge(). 
    //First, difference() a rectangle the size of the hinge from the child object (makes a hole for the hinge
    //Second, union() a hinge with First (puts the hinge in the hole)
    //Third, intersection() the child object with Second (cuts off any extra hinge that sticks out past the child object)
    intersection(){
        children();
        union(){
            hinge(size=size,d=d,minimum_thinness=minimum_thinness,hinge_length=hinge_length,hinges_across_length=hinges_across_length,center=center);
            difference(){
                children();
                square([size[0],size[1]],center=center);
                }
            }
        }
    }    

module tesselate(num=[1,1],size=[1,1],padding=[0,0],type="square"){
    //Tesselate acts on a child object, and tesselates it, in a sqaure, triagular or hexagonal array.
    //num is [the number of objects in x, the number of objects in y]
    //size is [the size of each "cell" in x, the size of each "cell" in y]
    //padding is how much should be subtracted from the "cell" size to get the object size. This is absolute, not proportional, i.e. padding of .1 means each object is 0.1mm smaller than the cell, not 10% or 90% the size of the cell.
    //type is the type of array. There are exactly 3 types of regular polyhedron tesselations, square (normal graph paper), hexagonal (hex tiles, e.g. Civilization 5, or bricks in "running bond"), and triangular (this particular code uses a 180 degree rotation in z instead of a reflection in the xz-plane
    index = (type=="h"||type=="hex"||type=="hexagon"||type=="hexagonal")     ? 1 :
            (type=="t"||type=="tri"||type=="triangle"||type=="triangular")   ? 2 : 0;//index converts the text of type into a numbered index. I didn't want to slow down computation time by having if statements or conditionals, so I calculate transforamtions for all 3, make an array of them, and then use index to pick the appropriate one.
    sq=[[1,0],[0,1]]; hex=[[1,0],[.5,.75]]; tri=[[.5,0],[0,1]]; //These are the unit vectors for each of the array types.
    Map=[sq,hex,tri][index]; 
    for(j=[0:num[1]-1]) //Iterate in y
        for(i=[0:num[0]-1]){ //Iterate in x
            translation=[(i+.5)*Map[0]*size[0]+(j+.5)*Map[1]*size[1],[(i+.5)*(size[0]*Map[0][0])+Map[1][0]*size[0]*(j%2),(j+.5)*(size[1]*Map[1][1])],(i+.5)*Map[0]*size[0]+(j+.5)*Map[1]*size[1]][index]; //What is the vector that describes the position of each object in the array?
            rot=[0,0,180*((i+j)%2)][index]; //Only triangular arrays need a rotation
            translate(translation) 
                rotate(rot) 
                    resize(size-padding)  
                        children();
            }
    }

module tesselation_hinge(num=[1,1],size=[1,1],padding=[0,0],type="square"){
    //Tesselation hinge takes the difference of a square(size) and a tesselate(). 
    //size as used in this function is the size of the hinge, not the size of each object (like in tesselate()) the size of the objects are dynamically adjusted based on num and padding, and of course, the size of the hinge.
    //num, padding and type have all the same meanings as they do in tesselate().
    index = (type=="h"||type=="hex"||type=="hexagon"||type=="hexagonal")     ? 1 :
            (type=="t"||type=="tri"||type=="triangle"||type=="triangular")   ? 2 : 0;
    sq=[[1,0],[0,1]]; hex=[[1,0],[.5,.75]]; tri=[[.5,0],[0,1]];
    Map=[sq,hex,tri][index];
    //These parameters need to be re-declared because when calling tesselate(), the size of each object needs to be recalculated based on the size of each cell. These parameters must be the same in both functions.
    difference(){
        square(size);
        tesselate(num=num,size=[size[0]/num[0]/Map[0][0],size[1]/num[1]/Map[1][1]],padding=padding,type=type)
            children();
        } 
    }    