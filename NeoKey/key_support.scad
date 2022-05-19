include <key_definitions.scad>

/**
 * NeoKey PCB + PIN Header slot
 *
 *   |<-------------- 19.0 --------------->|
 *      |<---------- 18(1U) ----------->|
 *
 * Bottom view
 *
 *  0.5 +-------------------------------+ 0.5 +--
 *      |       +---------------+       |     |
 *      |       |      8.7      |       |     |
 *      |       +---------------+       |     |
 *      |               ⌃               |     |
 *      |               |               |     |
 *      |  2.8          |               |     |
 *      | +---+         |         +---+ |     |
 *      | +   + <----  13.2 ----> +   + |     |
 *      | +   +         |         +   + |     |
 *      | +   +         |         +   + |     |
 *      | +---+         ⌄         +---+ |     |
 *      |       +---------------+       |     |
 *      |       |               |       |     |
 *      |       +---------------+       |     |
 *      +-------------------------------+     +--
 *
 *
 * Side view
 *
 *                  +-------+
 *                  |       |
 *            /-----+-------+-----\
 *            |                   |        Switch
 *            |                   |
 *            |                   |
 *      [ . ] |     [ . . . ]     | [ . ]  Soldering margin for pinheader
 *      [-----+------- PCB -------+-----]
 *      +---+                       +---+  ---  ---
 *      | 2 |                       | 2 |   ⌃    ↕  Corner support for pcb
 *      +---+-----------------------+---+   |   ---
 *      |               ⌃               |   |
 *      |               |               |   | Pin-header 8mm (female)
 *      |               6               |   |
 *      |               |               |   |
 *      |               ⌄               |   ⌄
 *      +-------------------------------+  ---
 *
 */

// ----
NeoKeyMargin = 1.0; /* (0.5 * 2) */

SupportDepth = 2.0;
PCBDepth = 1.7;

pinHeaderWidth = 2.8;
pinHeaderHeight = 8.7;
PinHeaderDistance = 13.2;

// ----
useCableFrame = 1;
_cfHeight = 12;
_cfOffset = -4;
_cfDepth = 3;
cableFramePinHeaderDepth = 2;

// ----
bottomFrameDepth = 1.5;
bottomFramePinHeaderDepth = 1.2;
bottomPlateDepth = 3.0;

// ----
SwitchDepth = 4.5;
SwitchHoleSize = 15.0; //15.0;
SwitchHolderDepth = 1.5;
SwitchHoleHolderSize = 14.2; //15.0;
topPlateDepth = SwitchDepth + SupportDepth;

// ---
centerScrewHoleAllowWidth = 100;

// ---
bodyDepth = 8.0;

// ----
GuidelineCOL = 1;
GuidelineVIN = 0;
GuidelineROW = 1;
GuidelineGND = 0;

// ----
function getKeyWidth(u_size = U1) = u_size + NeoKeyMargin;
function getKeyHeight() = U1 + NeoKeyMargin;
function getTopPlateDepth() = topPlateDepth;
function getBottomPlateDepth() = bottomPlateDepth;
function getBodyDepth() = bodyDepth;

// ----
function getCableFrameHeight() = useCableFrame * _cfHeight;
function getCableFrameOffset() = useCableFrame * _cfOffset;
function getCableFrameDepth() = useCableFrame * _cfDepth;

/**
 * Full area of one (switch + pcb) for masking
 */
module KeyArea(u_size = U1, pin_height = 6) {
    w = u_size + NeoKeyMargin;
    h = U1 + NeoKeyMargin;

    cube([w, h, pin_height + SupportDepth]);
}

/**
 * PCB support for soldering margin
 *
 */
module PCBSupport(width, height, zPosition) {
    SupportHeight = 2.8;
    SupportMargin = 0.4;
    Distance = 0.8;

    SupportWidth = width / 2 - pinHeaderHeight / 2 - Distance;

    // Left-Bottom Support
    translate([0, 0, zPosition])
        cube([SupportWidth, SupportHeight, SupportDepth]);

    // Right-Bottom Support
    translate([width - SupportWidth, 0, zPosition])
        cube([SupportWidth, SupportHeight, SupportDepth]);

    // Left-Top Support
    translate([0, height - (SupportHeight - 0.2), zPosition])
        cube([SupportWidth, SupportHeight - 0.2, SupportDepth]);

    // Right-Top Support
    translate([width - SupportWidth, height - (SupportHeight + 0.3), zPosition])
        cube([SupportWidth, SupportHeight + 0.3, SupportDepth]);
}

/**
 * Switch Support
 *                             +-----+
 *  SwitchDepth      4.5mm     |     |
 *  SupportDepth     2.0mm  [] |     | []  (Soldering margin)
 *  PCBDepth         1.7mm  [--- PCB ---]
 */
module SwitchSupport(u_size = U1) {
    w = u_size + NeoKeyMargin;
    h = U1 + NeoKeyMargin;

    cx = w / 2;
    cy = h / 2;

    difference() {
        union () {
            translate([0, 0, SupportDepth + PCBDepth])
                cube([w, h, SwitchDepth - PCBDepth]);

            PCBSupport(w, h, PCBDepth);
        }

        // Hole for switch
        holderZ = SwitchDepth + SupportDepth - SwitchHolderDepth;
        translate([cx - (SwitchHoleSize / 2),
                   cy - (SwitchHoleSize / 2), 0])
            cube([SwitchHoleSize, SwitchHoleSize, holderZ]);
        translate([cx - (SwitchHoleHolderSize / 2),
                   cy - (SwitchHoleHolderSize / 2), holderZ])
            cube([SwitchHoleHolderSize, SwitchHoleHolderSize, SwitchHolderDepth]);
    }
}

/**
 * Key Slot
 *
 *      [--- PCB ---]
 *      || |   |   || pin-header (female)
 *      || |   |   ||
 *      ++ +---+   ++
 */
module KeySlot(u_size = U1, pin_height = 6, with_support = true, with_guideline = true,
               with_guidetext_vc = false, with_guidetext_rg = false,
               row_num = 0, col_num = 0) {
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

    difference() {
        cube([w, h, pin_height]);

        left = cx - PinHeaderDistance / 2 - pinHeaderWidth;

        // Center hole
        center_hole_size = PinHeaderDistance - 5.2;
        translate([cx - (center_hole_size / 2), cy - (center_hole_size / 2), 0])
            cube([center_hole_size, center_hole_size, pin_height]);

        // Left PinHeader hole
        translate([left, cy - pinHeaderHeight / 2 - 2.4, -1])
            cube([pinHeaderWidth, pinHeaderHeight, pin_height+2]);

        // Right PinHeader hole
        translate([cx + PinHeaderDistance / 2, cy - pinHeaderHeight / 2 - 2.4, -1])
            cube([pinHeaderWidth, pinHeaderHeight, pin_height+2]);

        // Bottom PinHeader hole
        translate([cx - pinHeaderHeight / 2, cy - PinHeaderDistance / 2 - pinHeaderWidth, -1])
            cube([pinHeaderHeight, pinHeaderWidth, pin_height+2]);

        // Top PinHeader hole
        translate([cx - pinHeaderHeight / 2, cy + PinHeaderDistance / 2, -1])
            cube([pinHeaderHeight, pinHeaderWidth, pin_height+2]);

        if (with_guideline) {
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
                translate([pin3, h / 2 - VGuidelineHeight / 2, -1])
                    cube([VGuidelineWidth, VGuidelineHeight, 2]);
            }
        }

        if (with_guidetext_vc) {
            translate([w / 2 + pinHeaderHeight/2 + 1.5, h - 0.5, -1]) {
                mirror([0, 1, 0]) linear_extrude(height = 2) {
                    text("+", size=4, font="Arial Narrow:style=Bold");
                }
            }
            translate([w / 2 - pinHeaderHeight/2 - 3, h - 1, -1]) {
                mirror([0, 1, 0]) linear_extrude(height = 2) {
                    text(str(col_num), size=3, font="Arial Narrow:style=Bold");
                }
            }
        }

        if (with_guidetext_rg) {
            translate([left + 0.5,  cy - pinHeaderHeight / 2 - 3.5, -1]) {
                mirror([0, 1, 0]) linear_extrude(height = 2) {
                    text("-", size=4, font="Arial Narrow:style=Bold");
                }
            }
            translate([left,  cy + pinHeaderHeight / 2 + 1, -1]) {
                mirror([0, 1, 0]) linear_extrude(height = 2) {
                    text(str(row_num), size=3, font="Arial Narrow:style=Bold");
                }
            }
        }
    }

    if (with_support)
        PCBSupport(w, h, pin_height);
}

module _RecursiveCol(is_hole, is_switch, x, y, i, row_num, max_row,
                     list, is_test, depth, guide_text) {
    if (i < len(list)) {
        if (i == len(list) - 1) {
            if (list[i] >= 0)
                echo("row=", row_num, "/", max_row, "max width=", x + getKeyWidth(list[i]));
            else
                echo("row=", row_num, "/", max_row, "max width=", x + (-1 * list[i]));
        }

        if (is_hole)
            translate([x, y, 0])
                KeyArea(u_size = list[i], pin_height = depth);
        else {
            if (is_test) {
                translate([x, y, 0])
                    KeySlot(u_size = list[i], pin_height = depth,
                        with_support = false, with_guideline = false);
            } else if (is_switch) {
                translate([x, y, 0])
                    SwitchSupport(u_size = list[i]);
            } else {
                if (i == 0 && (row_num == 0 || row_num == max_row)) {
                    translate([x, y, 0]) KeySlot(u_size = list[i],
                        row_num = row_num, col_num = i,
                        with_guidetext_vc = guide_text,
                        with_guidetext_rg = guide_text);
                } else if (i == 0) {
                    translate([x, y, 0]) KeySlot(u_size = list[i],
                        row_num = row_num, col_num = i,
                        with_guidetext_rg = guide_text);
                } else if (row_num == 0 || row_num == max_row) {
                    translate([x, y, 0]) KeySlot(u_size = list[i],
                        row_num = row_num, col_num = i,
                        with_guidetext_vc = guide_text);
                } else {
                    translate([x, y, 0]) KeySlot(u_size = list[i]);
                }
            }
        }

        if (list[i] >= 0)
            _RecursiveCol(is_hole, is_switch, x + getKeyWidth(list[i]), y, i+1,
                row_num, max_row, list, is_test, depth);
        else
            _RecursiveCol(is_hole, is_switch, x + (-1 * list[i]), y, i+1,
                row_num, max_row, list, is_test, depth);
    }
}

module _RecursiveRow(is_hole, is_switch, y, i, max_i, list, is_test, depth, guide_text) {
    if (i >= 0) {
        _RecursiveCol(is_hole, is_switch, 0, y, 0,
                    i, max_i, list[i], is_test, depth, guide_text);

        _RecursiveRow(is_hole, is_switch, y + getKeyHeight(), i - 1,
                    max_i, list, is_test, depth, guide_text);
    }
}

module GenerateHole(list, depth = 6) {
    _RecursiveRow(true, false, 0, len(list) - 1, len(list) - 1,
        list, false, depth, false);
}

module GenerateSwitchHole(list, depth = 6) {
    _RecursiveRow(false, true, 0, len(list) - 1, len(list) - 1,
        list, false, depth, false);
}

module GenerateKey(list, guide_text = false, is_test = false, depth = 3) {
    _RecursiveRow(false, false, 0, len(list) - 1, len(list) - 1,
        list, is_test, depth, guide_text);
}

/**
 *
 */
function getKeyboardHeight(border, keymap)
    = border * 2 + len(keymap) * getKeyHeight();

/**
 *
 */
module KeyboardBody(border, width, keymap, guide_text = false) {
    height = getKeyboardHeight(border, keymap);

    difference() {
        union() {
            translate([0,0,0])
                cube([width, height, bodyDepth]);
            if (useCableFrame) {
                translate([border, height + getCableFrameOffset(), 0]) /* Cable frame */
                    cube([width - border * 2, getCableFrameHeight(), getCableFrameDepth()]);
                translate([border, height + getCableFrameOffset() + getCableFrameHeight() - 2, getCableFrameDepth()]) /* Card holder */
                    cube([width - border * 2, 2, bodyDepth - getCableFrameDepth() + topPlateDepth]);
            }
        }

        if (useCableFrame) {
            /* Screw area hole to card holder */
            translate([width / 2 - border, height, getCableFrameDepth()])
                cube([border * 2, getCableFrameHeight(), bodyDepth - getCableFrameDepth() + topPlateDepth]);

            translate([border * 2, height + getCableFrameOffset(), 0])
                cube([width - border * 4, getCableFrameHeight(), bottomPlateDepth - cableFramePinHeaderDepth]);
        }

        translate([border, border, 0])
            GenerateHole(keymap, bodyDepth);
    };


    /* Center support for screw hole */
    margin = 2;
    translate([width/2 - (border+margin)/2, height + getCableFrameOffset(), 0])
        cube([border+margin, getCableFrameHeight(), 2]);

    translate([border, border, 0])
        GenerateKey(keymap, guide_text);
}

/**
 *
 */
module KeyboardProto(border, width, keymap) {
    height = getKeyboardHeight(border, keymap);
    depth = 2;

    difference() {
        translate([0,0,0])
            cube([width, height, depth]);

        translate([border, border, 0])
            GenerateHole(keymap);
    };

    translate([border, border, 0])
        GenerateKey(keymap, is_test = true, depth = depth);
}

/**
 *
 */
module KeyboardTopPlate(border, width, keymap) {
    height = getKeyboardHeight(border, keymap);

    difference() {
        translate([0,0,0])
            cube([width, height, topPlateDepth]);

        translate([border, border, 0])
            GenerateHole(keymap);
    };

    translate([border, border, 0])
        GenerateSwitchHole(keymap);
}

module _plate_support_corner(border, width, height, depth) {
    translate([0, 0, 0])
        cube([border+1, border+1, depth]);
    translate([width - border-1, 0, 0])
        cube([border+1, border+1, depth]);
    translate([0, height - border-1, 0])
        cube([border+1, border+1, depth]);
    translate([width - border-1, height - border-1, 0])
        cube([border+1, border+1, depth]);
}

/**
 *
 */
module _BottomCableFrame(border, width, height) {
    translate([0, 0, 0])
        _plate_support_corner(border, width, height, bottomFrameDepth);

    /* Main frame */
    translate([0, 0, 0]) /* Bottom */
        cube([width, border * 0.7, bottomFrameDepth]);
    translate([0, 0, 0])  /* Left */
        cube([border*0.7, height, bottomFrameDepth]);
    translate([width - border * 0.7, 0, 0]) /* Right */
        cube([border*0.7, height, bottomFrameDepth]);
    translate([0, height - border, 0]) /* Top-Left */
        cube([border * 2, border, bottomFrameDepth]);
    translate([width - border * 2, height - border, 0]) /* Top-Right */
        cube([border * 2, border, bottomFrameDepth]);

    /* Cable frame */
    if (useCableFrame == true) {
        translate([border, height + getCableFrameOffset(), 0])
            cube([border, getCableFrameHeight(), bottomFrameDepth]);
        translate([width - border * 2, height + getCableFrameOffset(), 0])
            cube([border, getCableFrameHeight(), bottomFrameDepth]);

        translate([border * 2, height + getCableFrameOffset(), 0])
            cube([width - border * 4, getCableFrameHeight(), bottomFrameDepth - bottomFramePinHeaderDepth]);
    }

    /* Center support for screw hole */
    margin = 2;
    translate([width/2 - (border+margin)/2, height + getCableFrameOffset(), 0])
        cube([border+margin, getCableFrameHeight(), bottomFrameDepth]);
    translate([width/2 - (border+margin)/2, 0, 0])
        cube([border+margin, border, bottomFrameDepth]);
}

/**
 *
 */
module KeyboardBottomPlate(border, width, keymap) {
    height = getKeyboardHeight(border, keymap);
    plateDepth = bottomPlateDepth - bottomFrameDepth;
    cube([width, height, plateDepth]);

    translate([border, height + getCableFrameOffset(), 0])
        cube([width - border * 2, getCableFrameHeight(), plateDepth]);

    if (useCableFrame) {
        translate([0, 0, bottomFrameDepth])
            _BottomCableFrame(border, width, height);
    }
}

/**
 *
 */
module screwHole(border, width, keymap,
                 holeDepth = bodyDepth, holeSize = 2.5, cornerDepth = 0,
                 screwPositionTop = true) {
    height = getKeyboardHeight(border, keymap);
    topCenterHeight = height + getCableFrameOffset() + getCableFrameHeight();
    union() {
        if (cornerDepth != 0) {
            if (screwPositionTop) {
                translate([0, 0, cornerDepth]) /* Bottom-Left */
                    cube([border, border, holeDepth - cornerDepth]);
                translate([0, height - border, cornerDepth]) /* Top-Left */
                    cube([border, border, holeDepth - cornerDepth]);
                translate([width - border, 0, cornerDepth]) /* Bottom-Right */
                    cube([border, border, holeDepth - cornerDepth]);
                translate([width - border, height - border, cornerDepth]) /* Top-right */
                    cube([border, border, holeDepth - cornerDepth]);
                if (width > centerScrewHoleAllowWidth) {
                    translate([width/2 - border/2, 0, cornerDepth]) /* Bottom-Center */
                        cube([border, border, holeDepth - cornerDepth]);
                }
            } else {
                translate([0, 0, 0]) /* Bottom-Left */
                    cube([border, border, cornerDepth]);
                translate([0, height - border, 0]) /* Top-Left */
                    cube([border, border, cornerDepth]);
                translate([width - border, 0, 0]) /* Bottom-Right */
                    cube([border, border, cornerDepth]);
                translate([width - border, height - border, 0]) /* Top-right */
                    cube([border, border, cornerDepth]);
                translate([width/2 - border/2, topCenterHeight - border, 0]) /* Top-Center */
                    cube([border, border, cornerDepth]);
                if (width > centerScrewHoleAllowWidth) {
                    translate([width/2 - border/2, 0, 0]) /* Bottom-Center */
                        cube([border, border, cornerDepth]);
                }
            }
        }

        // Screw hole
        translate([border/2, border/2, 0]) /* Bottom-Left */
            cylinder(h = holeDepth, r = holeSize/2);
        translate([border/2, height - border/2, 0]) /* Top-Left */
            cylinder(h = holeDepth, r = holeSize/2);
        translate([width - border/2, border/2, 0]) /* Bottom-Right */
            cylinder(h = holeDepth, r = holeSize/2);
        translate([width - border/2, height - border/2, 0]) /* Top-right */
            cylinder(h = holeDepth, r = holeSize/2);
        translate([width/2, topCenterHeight - border/2, 0]) /* Top-Center */
            cylinder(h = holeDepth, r = holeSize/2);
        if (width > centerScrewHoleAllowWidth) {
            translate([width/2, border/2, 0]) /* Bottom-Center */
                cylinder(h = holeDepth, r = holeSize/2);
        }
    }
}
