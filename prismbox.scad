

// if your printer prints holes too small,
// adjust this parameter to increase all
// hole dimensions
hole_extra = 0.0;

// overall dimensions of the box
b_width      = 80;
b_depth      = 50;
b_height     = 50; // height includes the lid
b_lid_height = 15;

// size of the bevel
b_prism      = 3;

// thickness of the walls
b_walls      = 2;

// dimensions of the inner lip
b_lip_width  = 1.2;
b_lip_height = 3;

// dimensions of the four screw holes
b_screw_heads       = 6   + hole_extra; // diameter of the screw heads
b_screw_head_height = 2   + hole_extra; // height of the screw heads, use 0 if you don't want to countersink them
b_screw_shaft       = 3   + hole_extra; // diameter of the screw shaft
b_screw_tap         = 2.5 + hole_extra; // diameter of the hole that will receive the screw
b_screw_tap_depth   = 15  + hole_extra; // depth of the hole that will receive the screw

// set to true if your screw head tapers, set to false if your screw head is cylindrical
b_counter_sunk = true;

// set either one to true if you just want to render either case or lid
just_case = false;
just_lid  = false;

module pbox(width, depth, height, prism) {

    difference(){
        cube([width,depth,height]);

        // long edges
        rotate([45,0,0])
        translate([-1,-prism/2,-prism/2])
        cube([width+2,prism,prism]);

        translate([0,0,height])
        rotate([45,0,0])
        translate([-1,-prism/2,-prism/2])
        cube([width+2,prism,prism]);

        translate([0,depth,height])
        rotate([45,0,0])
        translate([-1,-prism/2,-prism/2])
        cube([width+2,prism,prism]);

        translate([0,depth,0])
        rotate([45,0,0])
        translate([-1,-prism/2,-prism/2])
        cube([width+2,prism,prism]);
        
        // short edges
        rotate([0,45,0])
        translate([-prism/2,-1,-prism/2])
        cube([prism,depth+2,prism]);

        translate([0,0,height])
        rotate([0,45,0])
        translate([-prism/2,-1,-prism/2])
        cube([prism,depth+2,prism]);

        translate([width,0,height])
        rotate([0,45,0])
        translate([-prism/2,-1,-prism/2])
        cube([prism,depth+2,prism]);

        translate([width,0,0])
        rotate([0,45,0])
        translate([-prism/2,-1,-prism/2])
        cube([prism,depth+2,prism]);
        
        //vertical edges
        rotate([0,0,45])
        translate([-prism/2,-prism/2,-1])
        cube([prism,prism,height+2]);

        translate([0,depth,0])
        rotate([0,0,45])
        translate([-prism/2,-prism/2,-1])
        cube([prism,prism,height+2]);

        translate([width,depth,0])
        rotate([0,0,45])
        translate([-prism/2,-prism/2,-1])
        cube([prism,prism,height+2]);

        translate([width,0,0])
        rotate([0,0,45])
        translate([-prism/2,-prism/2,-1])
        cube([prism,prism,height+2]);    
    }
}

module post(walls,screw_heads,height,prism){

    post_r = (screw_heads+2*walls)/2;

    difference(){
        union() {
            translate([sin(45)*prism+post_r,sin(45)*prism+post_r,0])
            cylinder(r=post_r,h=height,$fn=36);

            cube([sin(45)*prism+2*post_r,sin(45)*prism+post_r,height]);
            cube([sin(45)*prism+post_r,sin(45)*prism+2*post_r,height]);
        }

        rotate([45,0,0])
        translate([-1,-prism/2,-prism/2])
        cube([sin(45)*prism+2*post_r+2,prism,prism]);

        rotate([0,45,0])
        translate([-prism/2,-1,-prism/2])
        cube([prism,sin(45)*prism+2*post_r+2,prism]);

        rotate([0,0,45])
        translate([-prism/2,-prism/2,-1])
        cube([prism,prism,height+2]);    
    }

}

module symshell(width,depth,height,walls,prism,screw_heads) {

    difference(){
        pbox(width,depth,height*2,prism);
        translate([walls,walls,walls])
        pbox(width-2*walls,depth-2*walls,2*height-2*walls,prism);
        translate([-1,-1,height])
        cube([width+2,depth+2,height+1]);
    }

    post(walls,screw_heads,height,prism);

    translate([width,0,0])
    rotate([0,0,90])
    post(walls,screw_heads,height,prism);

    translate([width,depth,0])
    rotate([0,0,180])
    post(walls,screw_heads,height,prism);

    translate([0,depth,0])
    rotate([0,0,270])
    post(walls,screw_heads,height,prism);
    
}


module corner_lip (height,lip_height,lip_width,prism,walls,screw_heads) {
    
    post_r = (screw_heads+2*walls)/2;

    translate([0,0,height-lip_height])
    union() {
        difference(){
            union() {
                difference(){
                    translate([sin(45)*prism+post_r,sin(45)*prism+post_r,0])
                    cylinder(r=post_r+lip_width,h=lip_height*2,$fn=36);

                    translate([sin(45)*prism+post_r,sin(45)*prism+post_r,-1])
                    cylinder(r=post_r,h=lip_height*2+2,$fn=36);            
                }
                difference(){
                    translate([sin(45)*prism+post_r,sin(45)*prism+post_r,-lip_width])
                    cylinder(d1=post_r*2,d2=(post_r+lip_width)*2,h=lip_width,$fn=36);

                    translate([sin(45)*prism+post_r,sin(45)*prism+post_r,-1-lip_width])
                    cylinder(r=post_r,h=lip_width+2,$fn=36);            
                }
            }

            translate([0,-walls-lip_width-1,-1-lip_width])
            cube([sin(45)*prism+2*post_r+walls+lip_width+1,sin(45)*prism+post_r+walls+lip_width+1,lip_height*2+2+lip_width]);
            translate([-lip_width-1-walls,-1-lip_width,-1-lip_width])
            cube([sin(45)*prism+post_r+walls+lip_width+1,sin(45)*prism+2*post_r+walls+2*lip_width+1,lip_height*2+2+lip_width]);        
        }
        
        difference(){
            translate([walls,sin(45)*prism+2*post_r,-lip_width])
            cube([sin(45)*prism+post_r-walls,lip_width,lip_height*2+lip_width]);

            translate([walls-1,sin(45)*prism+2*post_r,-lip_width])
            rotate([-45,0,0])
            cube([sin(45)*prism+post_r-walls+2,lip_width/sin(45),lip_width/sin(45)]);
        }

        translate([0,walls+sin(45)*prism+post_r,0])
        rotate([0,0,270])
        difference(){
            translate([walls,sin(45)*prism+2*post_r,-lip_width])
            cube([sin(45)*prism+post_r-walls,lip_width,lip_height*2+lip_width]);

            translate([walls-1,sin(45)*prism+2*post_r,-lip_width])
            rotate([-45,0,0])
            cube([sin(45)*prism+post_r-walls+2,lip_width/sin(45),lip_width/sin(45)]);
        }
    }
    
}

module bottom_tap() {
    translate([sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,b_height-b_lid_height-b_screw_tap_depth])
    cylinder(d=b_screw_tap,h=b_screw_tap_depth+1,$fn=36);
}

if (just_lid == false) {
    union() {
        difference(){
            symshell(b_width,b_depth,b_height-b_lid_height,b_walls,b_prism,b_screw_heads);

            // bottom taps
            bottom_tap();

            translate([b_width,0,0])
            rotate([0,0,90])
            bottom_tap();

            translate([b_width,b_depth,0])
            rotate([0,0,180])
            bottom_tap();

            translate([0,b_depth,0])
            rotate([0,0,270])
            bottom_tap();
        }

        corner_lip(b_height-b_lid_height,b_lip_height,b_lip_width,b_prism,b_walls,b_screw_heads);

        translate([b_width,0,0])
        rotate([0,0,90])
        corner_lip(b_height-b_lid_height,b_lip_height,b_lip_width,b_prism,b_walls,b_screw_heads);

        translate([b_width,b_depth,0])
        rotate([0,0,180])
        corner_lip(b_height-b_lid_height,b_lip_height,b_lip_width,b_prism,b_walls,b_screw_heads);

        translate([0,b_depth,0])
        rotate([0,0,270])
        corner_lip(b_height-b_lid_height,b_lip_height,b_lip_width,b_prism,b_walls,b_screw_heads);

        translate([b_screw_heads+2*b_walls+sin(45)*b_prism,b_walls,b_height-b_lid_height-b_lip_height-b_lip_width])
        difference(){        
            cube([b_width-2*(b_screw_heads+2*b_walls+sin(45)*b_prism),b_lip_width,2*b_lip_height+b_lip_width]);        
            rotate([-45,0,0])
            translate([-1,0,0])
            cube([b_width-2*(b_screw_heads+2*b_walls+sin(45)*b_prism)+2,b_lip_width/sin(45),b_lip_width/sin(45)]);
        }

        translate([b_screw_heads+2*b_walls+sin(45)*b_prism,b_depth-b_walls-b_lip_width,b_height-b_lid_height-b_lip_height-b_lip_width])
        difference(){
            cube([b_width-2*(b_screw_heads+2*b_walls+sin(45)*b_prism),b_lip_width,2*b_lip_height+b_lip_width]);
            
            translate([0,b_lip_width,0])
            rotate([135,0,0])
            translate([-1,0,0])
            cube([b_width-2*(b_screw_heads+2*b_walls+sin(45)*b_prism)+2,b_lip_width/sin(45),b_lip_width/sin(45)]);
        }

        translate([b_walls,b_screw_heads+2*b_walls+sin(45)*b_prism,b_height-b_lid_height-b_lip_height-b_lip_width])
        difference() {
            cube([b_lip_width,b_depth-2*(b_screw_heads+2*b_walls+sin(45)*b_prism),2*b_lip_height+b_lip_width]);
            
            rotate([0,45,0])
            translate([0,-1,0])
            cube([b_lip_width/sin(45),b_depth-2*(b_screw_heads+2*b_walls+sin(45)*b_prism)+2,b_lip_width/sin(45)]);
        }

        translate([b_width-b_walls-b_lip_width,b_screw_heads+2*b_walls+sin(45)*b_prism,b_height-b_lid_height-b_lip_height-b_lip_width])
        difference(){
            cube([b_lip_width,b_depth-2*(b_screw_heads+2*b_walls+sin(45)*b_prism),2*b_lip_height+b_lip_width]);
            
            translate([0,0,-b_lip_width])
            rotate([0,-45,0])
            translate([0,-1,0])
            cube([b_lip_width/sin(45),b_depth-2*(b_screw_heads+2*b_walls+sin(45)*b_prism)+2,b_lip_width/sin(45)]);
        }
        
        
    }
}

module top_tap() {
    translate([sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,-1])
    cylinder(d=b_screw_shaft,h=b_lid_height+2,$fn=36);
    
    translate([sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,sin(45)*b_prism+(b_screw_heads+2*b_walls)/2,-0.01])
    if (b_counter_sunk == true)
        cylinder(d1=b_screw_heads,d2=b_screw_shaft,h=b_screw_head_height+0.01,$fn=36);
    else
        cylinder(d=b_screw_heads,h=b_screw_head_height+0.01,$fn=36);
    
}

if (just_case == false) {
    translate([0,b_depth+20,0]) {
        
        difference() {
            symshell(b_width,b_depth,b_lid_height,b_walls,b_prism,b_screw_heads);
            
            top_tap();

            translate([b_width,0,0])
            rotate([0,0,90])
            top_tap();

            translate([b_width,b_depth,0])
            rotate([0,0,180])
            top_tap();

            translate([0,b_depth,0])
            rotate([0,0,270])
            top_tap();
        }
        
    }
}