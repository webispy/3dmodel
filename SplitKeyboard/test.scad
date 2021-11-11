use <keyboardPCB.scad>
use <../externals/roundedCube.scad>

//$fn = 30;

layoutMargin = 50;

frameBorder = 10;
frameDepth = 20;

frameLeftWidth = getKeyboardLeftPCBWidth() + frameBorder * 2;
frameLeftHeight = getKeyboardLeftPCBHeight() + frameBorder * 2;

frameRightWidth = getKeyboardRightPCBWidth() + frameBorder * 2;
frameRightHeight = getKeyboardRightPCBHeight() + frameBorder * 2;

module Left() {
    difference() {
        roundedCube2([frameLeftWidth, frameLeftHeight, frameDepth],
                     radius=5, apply_to="zmax");
        translate([frameBorder,
                   frameLeftHeight - frameBorder - 10,
                   frameDepth - 5])
            linear_extrude(height=5)
                text("Left", size = 10);
        translate([frameBorder, frameBorder, 5])
            linear_extrude(height=getKeyboardPCBDepth())
                polygon(getKeyboardLeftPCBPolygon());

    }
}

module Right() {
    difference() {
        roundedCube2([frameRightWidth, frameRightHeight, frameDepth],
                     radius=5, apply_to = "zmax");
        translate([frameBorder, frameBorder, frameDepth - 5])
            linear_extrude(height=5)
                text("Right", size = 10);
        translate([frameBorder, frameBorder, 5])
            linear_extrude(height=getKeyboardPCBDepth())
                polygon(getKeyboardRightPCBPolygon());
    }
}

translate([0, 0, 0])
    Left();

translate([frameLeftWidth + layoutMargin, 0, 0])
    Right();

