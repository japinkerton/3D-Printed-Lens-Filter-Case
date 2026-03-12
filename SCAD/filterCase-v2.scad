/* [Main Box] */
//Overall width of your widest filter. This is not the size printed on the filter, but rather the measured overall diameter including the filter ring. This will be used to determine the overall width of the box
MAX_FILTER_DIAMETER = 65.3;

//Overall width of your smallest filter. This can be undersized a bit. This will be used to determine the height of the internal dividers.
MIN_FILTER_DIAMETER = 52.1;

//List of THICKNESS of each filter you want to hold. This will define how many slots there are, and how wide they are.  Do not enter any spaces or decimals.
FILTER_THICKNESS = "10,10,10,10,8,8,8,8,8,8";

//Gap added around all sides of the filters. This will be added to all of the values above this.
FILTER_TOLERANCE = 1.5;

//Gap added between the lid and box. This is to compensate for imperfections in the printing process.
LID_TOLERANCE = .5;

//Thickness of the outer walls including the lid.
INNER_WALL_THICK = 1.5;

//Thickness of the outer walls including the lid.
OUTER_WALL_THICK = 2.1;

//Height of the lid
LID_HEIGHT = 10;

//How far the lid locking tabs protrude
LID_TAB_THICK = .5;

/* [Label] */

//Label on side
LABEL_TEXT = "37mm";

//Font (Courier is default for predicatable letter sizing)
LABEL_FONT = "Courier"; //["Courier","Verdana","Arial","Times New Roman"]

//Label text height
LABEL_TEXT_SIZE = 20;

//How far the label text will protrude
LABEL_TEXT_THICK = 1.1;

//Show label on short side
LABEL_ON_SHORT = "yes"; // [yes,no]

//Show label on long side 
LABEL_ON_LONG = "yes"; // [yes,no]

/* [Color Control] */
//This section is used to automatically render colors separately.  You shouldn't need to touch these values.
CC_COLOR_COUNT = 0;

//0 renders all colors.  Individual colors can be rendered separately by setting this to each index up to CC_COLOR_COUNT
CC_COLOR = 0;

/* [Hidden] */
//DO NOT EDIT BELOW HERE


//Sum the elements of a list.
function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];
 
//get sublist 
function partial(list,start,end) = [for (i = [start:end]) list[i]];

function csv_to_vector(s, i=0, current="", result=[]) =
    i > len(s) ? result :
    i == len(s) ? 
        concat(result, [to_int(current)]) :
    s[i] == "," ?
        csv_to_vector(s, i+1, "", concat(result, [to_int(current)])) :
        csv_to_vector(s, i+1, str(current, s[i]), result);

function to_int(s, i=0, val=0) =
    i >= len(s) ? val :
    let(c = s[i])
    to_int(s, i+1, val*10 + (ord(c)));

// Fixed ord function - OpenSCAD returns ASCII values directly
function ord(c) =
    c == "0" ? 0 :
    c == "1" ? 1 :
    c == "2" ? 2 :
    c == "3" ? 3 :
    c == "4" ? 4 :
    c == "5" ? 5 :
    c == "6" ? 6 :
    c == "7" ? 7 :
    c == "8" ? 8 :
    c == "9" ? 9 : 0;

// Alternative: simpler approach using search()
function csv_to_vector2(s) =
    let(
        parts = split(s, ","),
        numbers = [for(p = parts) parse_int(p)]
    ) numbers;

function split(s, delimiter, pos=0, result=[]) =
    let(
        next_delim = search(delimiter, s, 1, pos)[0]
    )
    next_delim == [] ?
        concat(result, [substr(s, pos)]) :
        split(s, delimiter, next_delim+1, 
              concat(result, [substr(s, pos, next_delim-pos)]));

function parse_int(s, i=0, val=0) =
    i >= len(s) ? val :
    let(
        digit = search(s[i], "0123456789")[0]
    )
    digit == [] ? val :  // Stop at first non-digit
    parse_int(s, i+1, val*10 + digit[0]);

    
//FILTER_THICKNESS converted to a vector
FILTER_THICKNESSES = csv_to_vector(FILTER_THICKNESS);

overallLength = (INNER_WALL_THICK + FILTER_TOLERANCE) * len(FILTER_THICKNESSES) + OUTER_WALL_THICK + (OUTER_WALL_THICK - INNER_WALL_THICK) + addl(FILTER_THICKNESSES);
overallWidth = MAX_FILTER_DIAMETER + FILTER_TOLERANCE + (2 * OUTER_WALL_THICK);
overallHeight = MAX_FILTER_DIAMETER + FILTER_TOLERANCE + (2 * OUTER_WALL_THICK);

//Length of lid locking tabs
LID_TAB_LENGTH = overallLength/2.5;



$fn=200;
module buildBox()
{

    difference()
    {
        cube([overallLength,overallWidth,overallHeight]);
        translate([OUTER_WALL_THICK,overallWidth/2,overallHeight])
        {
            rotate([0,90,0])
            {
                resize([0,overallWidth - OUTER_WALL_THICK*2,0])
                {
                    cylinder(h = overallLength-2*OUTER_WALL_THICK,r = overallHeight - MIN_FILTER_DIAMETER + FILTER_TOLERANCE);
                }
            }
        }
        for (i = [0:1:len(FILTER_THICKNESSES)-1])
        {
            if(i ==0 )
            {
                translate([OUTER_WALL_THICK,OUTER_WALL_THICK,OUTER_WALL_THICK+(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2])
                {
                    cube([FILTER_THICKNESSES[i]+FILTER_TOLERANCE,MAX_FILTER_DIAMETER+FILTER_TOLERANCE,MAX_FILTER_DIAMETER+FILTER_TOLERANCE]);
                    rotate([0,90,0])
                    {
                        translate([0,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2,0])
                        {
                            cylinder(FILTER_THICKNESSES[i]+FILTER_TOLERANCE,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2);
                        }
                    }
                }
            }
            else
            {
                distOffset = addl(partial(FILTER_THICKNESSES,0,i-1));
                translate([OUTER_WALL_THICK+distOffset+(FILTER_TOLERANCE+INNER_WALL_THICK)*i,OUTER_WALL_THICK,OUTER_WALL_THICK+(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2])
                union()
                {
                    cube([FILTER_THICKNESSES[i]+FILTER_TOLERANCE,MAX_FILTER_DIAMETER+FILTER_TOLERANCE,MAX_FILTER_DIAMETER+FILTER_TOLERANCE]);
                    rotate([0,90,0])
                    {
                        translate([0,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2,0])
                        {
                            cylinder(FILTER_THICKNESSES[i]+FILTER_TOLERANCE,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2,(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2);
                        }
                    }
                }

            }
        }
        
    }
    translate([overallLength/2 - LID_TAB_LENGTH/2,0,overallHeight - (LID_HEIGHT - (OUTER_WALL_THICK + LID_HEIGHT)/2)])
        rotate([0,90,0]) cylinder(h=LID_TAB_LENGTH,LID_TAB_THICK/2,LID_TAB_THICK/2);
    translate([overallLength/2 - LID_TAB_LENGTH/2,overallWidth,overallHeight - (LID_HEIGHT - (OUTER_WALL_THICK + LID_HEIGHT)/2)])
        rotate([0,90,0]) cylinder(h=LID_TAB_LENGTH,LID_TAB_THICK/2,LID_TAB_THICK/2);

}
module buildLid()
{
    

    difference()
    {
        cube([overallLength + OUTER_WALL_THICK*2 + LID_TOLERANCE*2,overallWidth + OUTER_WALL_THICK*2 + LID_TOLERANCE*2,LID_HEIGHT]);
        translate([OUTER_WALL_THICK +LID_TOLERANCE/2 ,OUTER_WALL_THICK +LID_TOLERANCE/2,OUTER_WALL_THICK])
        {
            cube([overallLength+LID_TOLERANCE,overallWidth+LID_TOLERANCE,overallHeight]);
        }
        
    
    
        translate([OUTER_WALL_THICK + LID_TOLERANCE,OUTER_WALL_THICK + LID_TOLERANCE/2,(OUTER_WALL_THICK + LID_HEIGHT)/2])    
            rotate([0,90,0])    cylinder(h=overallLength,LID_TAB_THICK*(2/3),LID_TAB_THICK*(3/4));
        
        translate([OUTER_WALL_THICK + LID_TOLERANCE,OUTER_WALL_THICK + LID_TOLERANCE/2 + overallWidth + LID_TAB_THICK/2,(OUTER_WALL_THICK + LID_HEIGHT)/2])    
            rotate([0,90,0])   cylinder(h=overallLength,LID_TAB_THICK*(2/3),LID_TAB_THICK*(3/4));
    }


}
module buildLabels()
{
    if(LABEL_ON_SHORT=="yes")
    {
        translate([overallLength-OUTER_WALL_THICK/2,overallWidth/2,overallHeight/2]) rotate([90,0,90])
            linear_extrude(height=LABEL_TEXT_THICK+OUTER_WALL_THICK/2)
                text(text=LABEL_TEXT,size=LABEL_TEXT_SIZE,font=LABEL_FONT,halign="center",valign="center");
                
                
        translate([OUTER_WALL_THICK/2,overallWidth/2,overallHeight/2]) rotate([90,0,270])
            linear_extrude(height=LABEL_TEXT_THICK+OUTER_WALL_THICK/2)
                text(text=LABEL_TEXT,size=LABEL_TEXT_SIZE,font=LABEL_FONT,halign="center",valign="center");
    }
    if(LABEL_ON_LONG=="yes")
    {
        translate([overallLength/2,OUTER_WALL_THICK/2,overallHeight/2]) rotate([90,0,0])
            linear_extrude(height=LABEL_TEXT_THICK+OUTER_WALL_THICK/2)
                text(text=LABEL_TEXT,size=LABEL_TEXT_SIZE,font=LABEL_FONT,halign="center",valign="center");
                
                
         translate([overallLength/2,overallWidth-OUTER_WALL_THICK/2,overallHeight/2]) rotate([90,0,180])
            linear_extrude(height=LABEL_TEXT_THICK+OUTER_WALL_THICK/2)
                text(text=LABEL_TEXT,size=LABEL_TEXT_SIZE,font=LABEL_FONT,halign="center",valign="center");
    }
}

module build()
{
    if (CC_COLOR == 0 || CC_COLOR == 1)
    {
        color("dimgray")
        {
            difference()
            {
                buildBox();
                buildLabels();
            }
            translate([0,overallWidth + 10,0])
                buildLid();
        }
    }
    if (CC_COLOR == 0 || CC_COLOR == 2)
    {
        color("darkred")
        {
            buildLabels();
        }
    }
}
build();
