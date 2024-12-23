//BUILD PARAMETERS - ONLY EDIT THIS SECTION

//Overall width of your widest filter. This is not the size printed on the filter, but rather the measured overall diameter including the filter ring. This will be used to determine the overall width of the box
MAX_FILTER_DIAMETER = 47.25;

//Overall width of your smallest filter. This can be undersized a bit. This will be used to determine the height of the internal dividers.
MIN_FILTER_DIAMETER = 36;

//List of thickness of each filter you want to hold. This will define how many slots there are, and how wide they are.
FILTER_THICKNESSES = [10,10,7,7,7,6,6,6,6,6];

//Gap added around all sides of the filters. This will be added to all of the values above this.
FILTER_TOLERANCE = 1.5;

//Gap added between the lid and box. This is to compensate for imperfections in the printing process.
LID_TOLERANCE = .5;

//Thickness of the outer walls including the lid.
INNER_WALL_THICKNESS = 1.5;

//Thickness of the outer walls including the lid.
OUTER_WALL_THICKNESS = 2;

//Height of the lid
LID_HEIGHT = 10;


//DO NOT EDIT BELOW HERE
//Sum the elements of a list.
function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];
 
//get sublist 
function partial(list,start,end) = [for (i = [start:end]) list[i]];

overallLength = (INNER_WALL_THICKNESS + FILTER_TOLERANCE) * len(FILTER_THICKNESSES) + OUTER_WALL_THICKNESS + (OUTER_WALL_THICKNESS - INNER_WALL_THICKNESS) + addl(FILTER_THICKNESSES);
overallWidth = MAX_FILTER_DIAMETER + FILTER_TOLERANCE + (2 * OUTER_WALL_THICKNESS);
overallHeight = MAX_FILTER_DIAMETER + FILTER_TOLERANCE + (2 * OUTER_WALL_THICKNESS);
$fn=200;

difference()
{
	cube([overallLength,overallWidth,overallHeight]);
	translate([OUTER_WALL_THICKNESS,overallWidth/2,overallHeight])
	{
		rotate([0,90,0])
		{
			resize([0,overallWidth - OUTER_WALL_THICKNESS*2,0])
			{
				cylinder(h = overallLength-2*OUTER_WALL_THICKNESS,r = overallHeight - MIN_FILTER_DIAMETER + FILTER_TOLERANCE);
			}
		}
	}
	for (i = [0:1:len(FILTER_THICKNESSES)-1])
	{
		if(i ==0 )
		{
			translate([OUTER_WALL_THICKNESS,OUTER_WALL_THICKNESS,OUTER_WALL_THICKNESS+(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2])
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
			translate([OUTER_WALL_THICKNESS+distOffset+(FILTER_TOLERANCE+INNER_WALL_THICKNESS)*i,OUTER_WALL_THICKNESS,OUTER_WALL_THICKNESS+(MAX_FILTER_DIAMETER+FILTER_TOLERANCE)/2])
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


//Lid
translate([0,overallWidth + 10,0])
{
	difference()
	{
		cube([overallLength + OUTER_WALL_THICKNESS + LID_TOLERANCE*2,overallWidth + OUTER_WALL_THICKNESS + LID_TOLERANCE*2,LID_HEIGHT]);
		translate([OUTER_WALL_THICKNESS/2 +LID_TOLERANCE/2 ,OUTER_WALL_THICKNESS/2 +LID_TOLERANCE/2,OUTER_WALL_THICKNESS/2])
		{
			cube([overallLength+LID_TOLERANCE,overallWidth+LID_TOLERANCE,overallHeight]);
		}
	}
}


