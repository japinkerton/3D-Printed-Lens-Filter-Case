//BUILD PARAMETERS - ONLY EDIT THIS SECTION
maxFilterDia = 48.25; //Filter Diameters are not the size printed on the filter.  It's the overall diameter of the filter ring
minFilterDia = 37;
filterThicknesses = [10,10,7,7,7,6,6,6,6,6];
tolerance = 1.5;
lidTolerance = .5;
innerWallThickness = 1.5;
outerWallThickness = 2;
lidHeight = 10;


//DO NOT EDIT BELOW HERE
//Sum the elements of a list.
function addl(list, c = 0) = 
 c < len(list) - 1 ? 
 list[c] + addl(list, c + 1) 
 :
 list[c];
 
//get sublist 
function partial(list,start,end) = [for (i = [start:end]) list[i]];

overallLength = (innerWallThickness + tolerance) * len(filterThicknesses) + outerWallThickness + addl(filterThicknesses);
overallWidth = maxFilterDia + tolerance + (2 * outerWallThickness);
overallHeight = maxFilterDia + tolerance + (2 * outerWallThickness);
$fn=200;

difference()
{
	cube([overallLength,overallWidth,overallHeight]);
	translate([outerWallThickness,overallWidth/2,overallHeight])
	{
		rotate([0,90,0])
		{
			resize([0,overallWidth - outerWallThickness*2,0])
			{
				cylinder(h = overallLength-2*outerWallThickness,r = overallHeight - minFilterDia + tolerance);
			}
		}
	}
	for (i = [0:1:len(filterThicknesses)-1])
	{
		if(i ==0 )
		{
			translate([outerWallThickness,outerWallThickness,outerWallThickness+(maxFilterDia+tolerance)/2])
			{
				cube([filterThicknesses[i]+tolerance,maxFilterDia+tolerance,maxFilterDia+tolerance]);
				rotate([0,90,0])
				{
					translate([0,(maxFilterDia+tolerance)/2,0])
					{
						cylinder(filterThicknesses[i]+tolerance,(maxFilterDia+tolerance)/2,(maxFilterDia+tolerance)/2);
					}
				}
			}
		}
		else
		{
			distOffset = addl(partial(filterThicknesses,0,i-1));
			translate([outerWallThickness+distOffset+(tolerance+innerWallThickness)*i,outerWallThickness,outerWallThickness+(maxFilterDia+tolerance)/2])
			union()
			{
				cube([filterThicknesses[i]+tolerance,maxFilterDia+tolerance,maxFilterDia+tolerance]);
				rotate([0,90,0])
				{
					translate([0,(maxFilterDia+tolerance)/2,0])
					{
						cylinder(filterThicknesses[i]+tolerance,(maxFilterDia+tolerance)/2,(maxFilterDia+tolerance)/2);
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
		cube([overallLength + outerWallThickness + lidTolerance*2,overallWidth + outerWallThickness + lidTolerance*2,lidHeight]);
		translate([outerWallThickness/2 +lidTolerance/2 ,outerWallThickness/2 +lidTolerance/2,outerWallThickness/2])
		{
			cube([overallLength+lidTolerance,overallWidth+lidTolerance,overallHeight]);
		}
	}
}


