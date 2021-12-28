$fn = 30;

/*
 * Standard 1u keycap size
 *  Keycap placeholder space: 19.05 x 19.05mm
 *  Keycap size: 18 x 18mm
 *  Plate switch hole: 14 x 14mm
 *  Distance between switch holes: 5.05mm
 */

U1 = 18; /* Default */
U125 = U1 * 1.25; /* 22.5, Modifier */
U15 = U1 * 1.50;  /* 27.0, Modifier, Tab, '\|'' */
U175 = U1 * 1.75; /* 31.5, Caps Lock */
U2 = U1 * 2.00;   /* 36.0, Num Plus, Num Enter, Backspace */
U225 = U1 * 2.25; /* 40.5, Left Shift */
U275 = U1 * 2.75; /* 49.5, Right Shift */
U625 = U1 * 6.25; /* 112.5, Space */

/**
 * NeoKey PCB + PIN Header slot
 *
 *   |<-------------- 19.5 --------------->|
 *      |<---------- 18(1U) ----------->|
 *
 *  0.7 +-------------------------------+ 0.7 +--
 *      |       +---------------+       |     |
 *      |       |      8.7      |       |     |
 *      |       +---------------+       |     |
 *      |               ^               |     |
 *      |               |               |     |
 *      |  2.8          |               |     |
 *      | +---+         |         +---+ |     |
 *      | +   + <----  13.2 ----> +   + |     |
 *      | +   +         |         +   + |     |
 *      | +   +         |         +   + |     |
 *      | +---+         \/        +---+ |     |
 *      |       +---------------+       |     |
 *      |       |               |       |     |
 *      |       +---------------+       |     |
 *      +-------------------------------+     +--
 *
 *
 * Side view
 *
 *      +---+                       +---+
 *      | 2 |                       | 2 |
 *      +---+-----------------------+---+
 *      |              ^                |
 *      |              |                |
 *      |              6                |
 *      |              |                |
 *      |              \/               |
 *      +-------------------------------+
 *
 */

//----
NeoKeyMargin = 1.5; /* Minimum printable value with Prusa printers */
legDepth = 6;
SupportDepth = 2.0;

GuidelineCOL = 1;
GuidelineVIN = 0;
GuidelineROW = 1;
GuidelineGND = 0;

function getWidth(u_size = U1) = u_size + NeoKeyMargin;
function getHeight() = U1 + NeoKeyMargin;

module PCBSupportBox(u_size = U1) {
    w = u_size + NeoKeyMargin;
    h = U1 + NeoKeyMargin;

    cube([w, h, legDepth + SupportDepth]);
}

module PCBSupport(u_size = U1) {
    w = u_size + NeoKeyMargin;
    h = U1 + NeoKeyMargin;
    U1_w = U1 + NeoKeyMargin;

    diff = u_size - U1;
    sx = diff / 2;
    cx = w / 2;
    ex = w - diff / 2;

    sy = 0;
    cy = h / 2;
    ey = h;

    pinHeaderWidth = 2.8;
    pinHeaderHeight = 8.7;
    PinHeaderDistance = 13.2;

    difference() {
        cube([w, h, legDepth]);

        // Left PinHeader hole
        translate([cx - PinHeaderDistance / 2 - pinHeaderWidth, cy - pinHeaderHeight / 2 - 2.4, -1])
            cube([pinHeaderWidth, pinHeaderHeight, legDepth+2]);

        // Right PinHeader hole
        translate([cx + PinHeaderDistance / 2, cy - pinHeaderHeight / 2 - 2.4, -1])
            cube([pinHeaderWidth, pinHeaderHeight, legDepth+2]);

        // Bottom PinHeader hole
        translate([cx - pinHeaderHeight / 2, cy - PinHeaderDistance / 2 - pinHeaderWidth, -1])
            cube([pinHeaderHeight, pinHeaderWidth, legDepth+2]);

        // Top PinHeader hole
        translate([cx - pinHeaderHeight / 2, cy + PinHeaderDistance / 2, -1])
            cube([pinHeaderHeight, pinHeaderWidth, legDepth+2]);

        VGuidelineHeight = h - pinHeaderWidth * 2;
        VGuidelineWidth = 1;
        HGuidelineHeight = 1;
        HGuidelineWidth = U1_w - pinHeaderWidth * 2;

        // ROW Guideline
        if (GuidelineROW) {
            pin1 = 3.1 + pinHeaderHeight - pinHeaderHeight / 3 + HGuidelineHeight / 2;
            translate([w / 2 - HGuidelineWidth / 2, pin1, -1])
                cube([HGuidelineWidth, HGuidelineHeight, 2]);
        }

        // GND Guideline
        if (GuidelineGND) {
            pin1 = 3.1 + pinHeaderHeight / 3 - HGuidelineHeight;
            translate([w / 2 - HGuidelineWidth / 2, pin1, -1])
                cube([HGuidelineWidth, HGuidelineHeight, 2]);
        }

        // COL Guideline
        if (GuidelineCOL) {
            pin1 = w / 2 - pinHeaderHeight / 3;
            translate([pin1, h / 2 - VGuidelineHeight / 2, -1])
                cube([VGuidelineWidth, VGuidelineHeight, 2]);
        }

        // VIN Guideline
        if (GuidelineVIN) {
            pin3 = w / 2 + pinHeaderHeight / 3;
            translate([pin3, height / 2 - VGuidelineHeight / 2, -1])
                cube([VGuidelineWidth, VGuidelineHeight, 2]);
        }
    }


SupportHeight = 2.8;
SupportMargin = 0.4;
Distance = 0.8;

SupportWidth = w / 2 - pinHeaderHeight / 2 - Distance;

    // Left-Bottom Support
    translate([0, 0, legDepth])
        cube([SupportWidth, SupportHeight, SupportDepth]);

    // Right-Bottom Support
    translate([w - SupportWidth, 0, legDepth])
        cube([SupportWidth, SupportHeight, SupportDepth]);

    // Left-Top Support
    translate([0, h - (SupportHeight - 0.2), legDepth])
        cube([SupportWidth, SupportHeight - 0.2, SupportDepth]);

    // Right-Top Support
    translate([w - SupportWidth, h - (SupportHeight + 0.3), legDepth])
        cube([SupportWidth, SupportHeight + 0.3, SupportDepth]);

}


// ---------
panelDepth = 8;
panelMargin = 1;

module panel5() {
    w = getWidth();
    h = getHeight();

    panelMargin = 5;
    panelWidth = w * 3 + panelMargin * 2;
    panelHeight = h * 2 + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox();
        translate([panelMargin + w, panelMargin, 0])
            PCBSupportBox();
        translate([panelMargin, panelMargin + height, 0])
            PCBSupportBox();
        translate([panelMargin + w, panelMargin + height,0])
            PCBSupportBox();
        translate([panelMargin + w*2, panelMargin + height/2,0])
            PCBSupportBox();

        translate([3, 3, 0])
            cylinder(h = 5, r = 1.25);
        translate([3, panelHeight - 3, 0])
            cylinder(h = 5, r = 1.25);
        translate([panelWidth - 3, 3, 0])
            cylinder(h = 5, r = 1.25);
        translate([panelWidth - 3, panelHeight - 3, 0])
            cylinder(h = 5, r = 1.25);
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport();
    translate([panelMargin + w, panelMargin, 0])
        PCBSupport();
    translate([panelMargin, panelMargin + h, 0])
        PCBSupport();
    translate([panelMargin + w, panelMargin + h,0])
        PCBSupport();
    translate([panelMargin + w*2, panelMargin + h/2,0])
        PCBSupport();
}

module panel1(u_size = U1) {
    panelWidth = getWidth(u_size) + panelMargin * 2;
    panelHeight = getHeight() + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox(u_size);
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport(u_size);
}

module panel2(u_size = U1) {
    w = getWidth(u_size);
    h = getHeight();

echo ("w = ", w);

    panelMargin = 1;
    panelWidth = w * 2 + panelMargin * 2;
    panelHeight = h * 1 + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox(u_size);
        translate([panelMargin + w, panelMargin, 0])
            PCBSupportBox(u_size);
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport(u_size);
    translate([panelMargin + w, panelMargin, 0])
        PCBSupport(u_size);
}

module panel2_tab() {
    h = getHeight();

    panelWidth = getWidth(U15) + getWidth() + panelMargin * 2;
    panelHeight = h * 1;// + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox(U15);
        translate([panelMargin + getWidth(U15), panelMargin, 0])
            PCBSupportBox();
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport(U15);
    translate([panelMargin + getWidth(U15), panelMargin, 0])
        PCBSupport();
}

module panel2_ctrl() {
    h = getHeight();

    panelWidth = getWidth(U175) + getWidth() + panelMargin * 2;
    panelHeight = h * 1;// + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox(U175);
        translate([panelMargin + getWidth(U175), panelMargin, 0])
            PCBSupportBox();
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport(U175);
    translate([panelMargin + getWidth(U175), panelMargin, 0])
        PCBSupport();
}

module panel2_shift() {
    h = getHeight();

    panelWidth = getWidth(U225) + getWidth() + panelMargin * 2;
    panelHeight = h * 1;// + panelMargin * 2;

    difference() {
        translate([0, 0, 0])
            cube([panelWidth, panelHeight, panelDepth]);

        translate([panelMargin, panelMargin, 0])
            PCBSupportBox(U225);
        translate([panelMargin + getWidth(U225), panelMargin, 0])
            PCBSupportBox();
    }

    translate([panelMargin, panelMargin, 0])
        PCBSupport(U225);
    translate([panelMargin + getWidth(U225), panelMargin, 0])
        PCBSupport();
}

/*
translate([0, getHeight() * 2 + 2, 0])
    panel2_tab();

translate([0, getHeight(), 0])
    panel2_ctrl();

translate([0, 0, 0])
    panel2_shift();

translate([0, -30, 0])
    panel1();

translate([30, -30, 0])
    PCBSupport(U1);
*/

/*
KEYS = [
    [U1, U1, U1],
    [U15, U1, U1],
    [U175, U1, U1],
    [U225, U1, U1],
    [U125, U125, U125]
];
*/

KEYS = [
    [U1, U1, U1],
    [U15, U1, U1],
];

module _col(is_hole, x, y, i, list) {
    if (i < len(list)) {
        if (is_hole)
            translate([x, y, 0])
                PCBSupportBox(list[i]);
        else
            translate([x, y, 0])
                PCBSupport(list[i]);

        _col(is_hole, x + getWidth(list[i]), y, i+1, list);
    }
}

module _row(is_hole, y, i, list) {
    if (i >= 0) {
        _col(is_hole, 0, y, 0, list[i]);

        _row(is_hole, y + U1, i-1, list);
    }
}

module GenerateHole(list) {
    _row(1, 0, len(KEYS) - 1, KEYS);
}

module GenerateKey(list) {
    _row(0, 0, len(KEYS) - 1, KEYS);
}

module Keyboard(border, keymap) {
    height = border * 2 + len(keymap) * getHeight();

    translate([0,0,0])
        difference() {
            translate([0,0,0])
            cube([100, height, panelDepth]);

            translate([border, border, 0])
                GenerateHole(keymap);
    };

    translate([border, border, 0])
        GenerateKey(keymap);
}

Keyboard(5, KEYS);