// Split Keyboard Left/Right PCB polygon library
//
// API:
//     getKeyboardLeftPCBPolygon()
//     getKeyboardRightPCBPolygon()
//     getKeyboardLeftPCBWidth()
//     getKeyboardLeftPCBHeight()
//     getKeyboardRightPCBWidth()
//     getKeyboardRightPCBHeight()
//     getKeyboardPCBDepth()
//
// Usage:
//     // Just draw the left PCB area of keyboard
//     polygon(getKeyboardLeftPCBPolygon());
//
//     // Just draw the right PCB area of keyboard
//     polygon(getKeyboardRightPCBPolygon());
//
//     // Draw the left and right PCB areas of keyboard side by side
//     translate([-getKeyboardLeftPCBWidth() - 10,
//                -getKeyboardLeftPCBHeight() / 2, 0])
//         linear_extrude(height=getKeyboardPCBDepth())
//             polygon(getKeyboardLeftPCBPolygon());
//
//     translate([10, -getKeyboardRightPCBHeight() / 2, 0])
//         linear_extrude(height=getKeyboardPCBDepth())
//             polygon(getKeyboardRightPCBPolygon());
//
// ----------------------------------------------------------------------------
// SVG width = 297mm, height = 210mm
// SVG viewport width = 116930, height = 82680
//
// Convert viewport point(X, Y) to mm unit:
//     Xmm unit = X * 297 / 116930
//     Ymm unit = Y * 210 / 82680

KeyboardSVGWidth = 297;
KeyboardSVGHeight = 210;

function getKeyboardSVGWidth() = KeyboardSVGWidth;
function getKeyboardSVGHeight() = KeyboardSVGHeight;

// LEFT
//     SVG polygon point(viewport pixel) = [
//         [35800,  8200], [35800, 21700],
//         [11000, 21700], [11000, 70000],
//         [31800, 70000], [37800, 64000],
//         [76700, 64000], [76700,  8200] ]
//     SVG polygon point(convert to mm) = [
//         [ 90.9,  20.5], [ 90.9,  55.1],
//         [ 27.9,  55.1], [ 27.9, 177.8],
//         [ 80.8, 177.8], [ 96.0, 162.6],
//         [194.9, 162.6], [194.9,  20.8] ]
// RIGHT
//     SVG polygon point(viewport pixel) = [
//         [ 72000, 13900], [  8100, 13900],
//         [  8000, 55000], [ 40000, 55000],
//         [ 60000, 61000], [102000, 61000]
//         [102000, 25000] ]
//     SVG polygon point(convert to mm) = [
//         [182.8,  35.3], [ 20.6,  35.3],
//         [ 20.3, 139.7], [101.6, 139.7],
//         [152.4, 154.9], [259.0, 154.9],
//         [259.0,  63.5] ]

// All coordinates are based on SVG
function getKeyboardLeftPCBPolygon_SVG() = [
    [ 90.9, -20.5], [ 90.9, -55.1],   //     ___
    [ 27.9, -55.1], [ 27.9,-177.8],   //  __|   |
    [ 80.8,-177.8],                   //  |     |
    [ 96.0,-162.6],                   //  |  ___|
    [194.9,-162.6], [194.9, -20.8] ]; //  |_/
function getKeyboardRightPCBPolygon_SVG() = [
    [182.8, -35.3], [ 20.6, -35.3],  //   ____
    [ 20.3,-139.7], [101.6,-139.7],  //  |    \__
    [152.4,-154.9], [259.0,-154.9],  //  |__     |
    [259.0, -63.5] ];                //     \____|

// Full SVG preview
module KeyboardLeftPCBFull_SVG(show_page = false) {
    translate([-KeyboardSVGWidth / 2, -KeyboardSVGHeight / 2, 0]) {
        import("left_side_svgs/keyboard-Edge_Cuts.svg");
        import("left_side_svgs/keyboard-F_SilkS.svg");
        import("left_side_svgs/keyboard-Dwgs_User.svg");

        // For checking the entire page area of SVG
        if (show_page)
            color(alpha=0.2) cube([KeyboardSVGWidth, KeyboardSVGHeight, 1]);
    }
}
module KeyboardRightPCBFull_SVG(show_page = false) {
    translate([-KeyboardSVGWidth / 2, -KeyboardSVGHeight / 2, 0]) {
        import("right_side_svgs/keyboard_right-Edge_Cuts.svg");
        import("right_side_svgs/keyboard_right-F_Cu.svg");
        import("right_side_svgs/keyboard_right-F_SilkS.svg");

        // For checking the entire page area of SVG
        if (show_page)
            color(alpha=0.2) cube([KeyboardSVGWidth, KeyboardSVGHeight, 1]);
    }
}

// Verify that the polycon fits exactly into the PCB area
module KeyboardLeftPCBFit_SVG(height=4) {
    translate([-KeyboardSVGWidth / 2, KeyboardSVGHeight / 2, 0]) {
        linear_extrude(height=height)
            polygon(getKeyboardLeftPCBPolygon_SVG());
    }
}
module KeyboardRightPCBFit_SVG(height=4) {
    translate([-KeyboardSVGWidth / 2, KeyboardSVGHeight / 2, 0]) {
        linear_extrude(height=height)
            polygon(getKeyboardRightPCBPolygon_SVG());
    }
}

// All coordinates are changed relative to [0,0](Left to Right, Bottom to Up]),
// and additional space is added outside the PCB for assembly.
//
//   Screen coordinates
//   [0,0]+----------+
//        |          |           +------+
//        |  ---->   |           |   /`\|
//        |      |   |  ->       |    | |
//        |     \./  |           |----> |
//        |          |     [0,0] +------+
//        +----------+     3D coordinates
//
function getKeyboardLeftPCBPolygon() = [
    [  0,   0], [ 55,   0],
    [ 70,  15], [169,  15],
    [169, 159], [ 63, 159],
    [ 63, 125], [  0, 125] ];
function getKeyboardRightPCBPolygon() = [
    [  0,  15], [ 84,  15],
    [132,   0], [241,   0],
    [241,  93], [164, 122],
    [  0, 122] ];

PCBLeftWidth = 169;
PCBLeftHeight = 159;
function getKeyboardLeftPCBWidth() = PCBLeftWidth;
function getKeyboardLeftPCBHeight() = PCBLeftHeight;

PCBRightWidth = 241;
PCBRightHeight = 122;
function getKeyboardRightPCBWidth() = PCBRightWidth;
function getKeyboardRightPCBHeight() = PCBRightHeight;

PCBDepth = 20; /* FIXME */
function getKeyboardPCBDepth() = PCBDepth;

// Verify the PCB area polygon
module KeyboardLeftPCB_VerifyPolygon(height=4) {
    KeyboardLeftPCBFull_SVG(true);

    // Adjusted the coordinates(-37, +5.5) to match the PCB position in the SVG.
    translate([-PCBLeftWidth / 2 - 37, -PCBLeftHeight / 2 + 5.5, 0]) {
        color(alpha=0.5)
            linear_extrude(height)
                polygon(getKeyboardLeftPCBPolygon());
    }
}
module KeyboardRightPCB_VerifyPolygon(height=4) {
    KeyboardRightPCBFull_SVG(false);

    // Adjusted the coordinates(-8.5, +9.5) to match the PCB position in the SVG.
    translate([-PCBRightWidth / 2 - 8.5, -PCBRightHeight / 2 + 9.5, 0]) {
        color(alpha=0.5)
            linear_extrude(height)
                polygon(getKeyboardRightPCBPolygon());
    }
}
