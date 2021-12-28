width = 54;
height = 82;
depth = 10;

holderDepth = 6;

leftSideWidth = 9;
rightSideWidth = 9;

bottomOffset = 1;
bottomCaseDepth = depth + bottomOffset + 2;
bottomCaseWidth = width + 8;
bottomCaseHeight = height + 8;

topCaseWidth = width + 4 - 0.5;
topCaseHeight = height + 4 - 0.5;

STM32Width = 25 + 1;
STM32Height = 60;

module breadboard() {
    translate([0,0,0]) /* body */
        cube([width,height,depth]);
    translate([leftSideWidth/2 - 5/2,height,0]) /* left-top */
        cube([5,2,holderDepth]);
    translate([width/2 - 5/2,height,0]) /* center-top */
        cube([5,2,holderDepth]);
    translate([width - rightSideWidth/2 - 5/2 - 1,height,0]) /* right-top */
        cube([5,2,holderDepth]);
    translate([width,11.5,0]) /* right-up */
        cube([2,5,holderDepth]);
    translate([width,height - 11.5 - 5,0]) /* right-down */
        cube([2,5,holderDepth]);
}

module botttomCase() {
    echo("bottom case", bottomCaseWidth, bottomCaseHeight);

    difference() {
        translate([0,0,0])
            cube([bottomCaseWidth, bottomCaseHeight, bottomCaseDepth]);
        translate([4,4,bottomOffset])
            breadboard();
        translate([2,2,holderDepth])
            cube([width + 4, height + 4, bottomCaseDepth - holderDepth]);

// debug
        translate([bottomCaseWidth/2 - 5, 0, 0])
            cube([10,6,bottomCaseDepth]);
    }
}

module topCase() {
    caseOffset = 1;

    borderDepth = 10;
    topDepth = borderDepth + caseOffset;

    lineLeftX = topCaseWidth/2 - 10;
    lineRightX = topCaseWidth/2 + 10;
    lineWidth = 6;

    echo("top case", topCaseWidth, topCaseHeight);

    difference() {
        translate([0,0,0])
            cube([topCaseWidth, topCaseHeight, topDepth]);
        
        translate([topCaseWidth/2 - width/2, topCaseHeight/2 - height/2, 0])
            cube([width, height, borderDepth]);

        // usb port
        translate([topCaseWidth/2 - STM32Width/2, topCaseHeight - 2, 0])
            cube([STM32Width, 2, topDepth]);

        // pin header line
        translate([lineLeftX - lineWidth, 4, topDepth - caseOffset])
            cube([lineWidth, topCaseHeight - 9, caseOffset]);
        translate([lineRightX, 4, topDepth - caseOffset])
            cube([lineWidth, topCaseHeight - 9, caseOffset]);

        // handle area
        translate([2, topCaseHeight/2 - 7, topDepth - caseOffset])
            cube([7, 14, caseOffset]);
        translate([topCaseWidth-7-2, topCaseHeight/2 - 7, topDepth - caseOffset])
            cube([7, 14, caseOffset]);


        // center
        translate([topCaseWidth/2 - 1, 0, topDepth - 0.3])
            cube([2, topCaseHeight, 0.3]);

        // guide_line
        center_x = topCaseWidth/2 - STM32Width/2;
        translate([center_x, 4 + 2.54*5 - 1, topDepth - 0.3]) /* ROW-0 */
            cube([STM32Width, 2, 0.3]);
        translate([center_x, 4 + 2.54*19 - 1, topDepth - 0.3]) /* Left COL-0 */
            cube([STM32Width/2, 2, 0.3]);
        translate([center_x + 5, 4 + 2.54*(19-7) - 1, topDepth - 0.3])
            cube([1, 2.54*7 + 1, 0.3]);

        translate([center_x + STM32Width/2, 4 + 2.54*24 - 1, topDepth - 0.3]) /* Right COL-0 */
            cube([STM32Width/2, 2, 0.3]);
        translate([center_x + STM32Width - 6, 4 + 2.54*(24-8) - 1, topDepth - 0.3])
            cube([1, 2.54*8, 0.3]);


        translate([topCaseWidth/2 - width/2, topCaseHeight/2 - height/2, -3])
            breadboard();
    }

/*
        translate([topCaseWidth/2 - 10, 0, topDepth])
            cube([20, topCaseHeight, 2]);
        translate([topCaseWidth/2 - 10.5 - 4, 0, topDepth]) color("red")
            cube([4, topCaseHeight, 2]);
*/
}

//translate([0, 0, 0]) color([0.2,0.2,0.2,0.5])
//    botttomCase();

diffX = bottomCaseWidth/2 - topCaseWidth/2;
diffY = bottomCaseHeight/2 - topCaseHeight/2;
translate([diffX, diffY, 7]) //color([1.0,0.2,0.2,0.5])
    topCase();
