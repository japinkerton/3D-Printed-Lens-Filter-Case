# 3D-Printed-Lens-Filter-Case
Open source case for storage of lens filters.

All parts were designed in OpenSCAD for a parametric approach.

If you don't know how to use OpenSCAD, don't worry.  The parts you're looking for are on ([Thingivers](https://www.thingiverse.com/thing:6866168)).

## Printing Parameters
|Parameter|Value|Note|
|-----|-----|-----|
|Slicer|Creality Print ||
|Material|MatterHackers PLA|Any PLA or PETG should be fine|
|Infill| 15% cubic||
|Supports|None||

## How to Edit
The build parameters are defined first in the SCAD file.  You only need to worry about the following global variables

Note: All units are mm.

|Parameter|Explanation|
|-----|-----|
|MAX_FILTER_DIAMETER|Overall width of your widest filter.  This is not the size printed on the filter, but rather the measured overall diameter including the filter ring.  This will be used to determine the overall width of the box|
|MIN_FILTER_DIAMETER|Overall width of your smallest filter.  This can be undersized a bit.  This will be used to determine the height of the internal dividers.|
|FILTER_THICKNESSES|List of thickness of each filter you want to hold.  This will define how many slots there are, and how wide they are.|
|FILTER_TOLERANCE|Gap added around all sides of the filters.  This will be added to all of the values above this.|
|LID_TOLERANCE|Gap added between the lid and box.  This is to compensate for imperfections in the printing process.|
|INNER_WALL_THICKNESS|Thickness of the dividers between slots.|
|OUTER_WALL_THICKNESS|Thickness of the outer walls including the lid.|
|LID_HEIGHT|Height of the lid|
