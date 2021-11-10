module roundedCube(xx, yy, height, radius) {
    difference() {
        cube([xx,yy,height]);

        difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([xx,0,0]) rotate(90) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([xx,yy,0]) rotate(180) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }

        translate([0,yy,0]) rotate(270) difference() {
            translate([-.5,-.5,-.2]) cube([radius+.5,radius+.5,height+.5]);
            translate([radius,radius,height/2]) cylinder(height,radius,radius,true);
        }
    }
}

// ----------------------------------------------------------------

/* Sunfounder 10.1 inch Display kit */
GlassWidth = 257;
GlassHeight = 169;
GlassDepth = 2;

MainPanelWidth = 236;
MainPanelHeight = 160;
MainPanelDepth = 5;

TopMargin = -1;

SupportAreaWidth = 217;
SupportAreaHeight = 94;
SupportAreaDepth = 4;
DebugSupportArea = 1;

SupportBlockWidth = 7;
SupportBlockHeight = 14;
SupportBlockDepth = 4;
SupportHoleRadius = 3;

module sunfounder_10_1() {
    BottomWidth = MainPanelWidth;
    BottomHeight = 34;
    BottomDepth = 11;

    SideBottomWidth = MainPanelWidth;
    SideBottomHeight = 4;
    SideLRWidth = 8;
    SideLRHeight = 126;

    translate([-GlassWidth / 2, -GlassHeight / 2, 0]) {
        /* Glass */
        color("black") roundedCube(GlassWidth, GlassHeight, GlassDepth, 5);

        translate([0, 0, GlassDepth]) {
            translate([(GlassWidth - MainPanelWidth) / 2,
                       (GlassHeight - MainPanelHeight) / 2 - TopMargin, 0]) {
                /* Main & Bottom */
                color("gray") {
                    cube([MainPanelWidth, MainPanelHeight, MainPanelDepth]);
                    cube([BottomWidth, BottomHeight, BottomDepth]);
                }

                /* DisplayBoard connector */
                color("orange") translate([25, BottomHeight, MainPanelDepth])
                    cube([35, 80, SupportBlockDepth * 2]);

                /* Support Area */
                translate([(MainPanelWidth - SupportAreaWidth) / 2,
                           (MainPanelHeight - SupportAreaHeight) / 2 + 16,
                           MainPanelDepth]) {
                    if (DebugSupportArea) {
                        color("gray", alpha=0.2) {
                            cube([SupportAreaWidth, SupportAreaHeight, SupportAreaDepth]);
                        }
                    }

                    color("red") {
                        /* DisplayBoard LB */
                        cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                        translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                            cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);

                        /* DisplayBoard LT */
                        translate([0, SupportAreaHeight-SupportBlockHeight, 0]) {
                            cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                            translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                                cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);
                        }

                        /* DisplayBoard RB */
                        translate([60, 0, 0]) {
                            cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                                translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                                    cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);
                        }

                        /* DisplayBoard RT */
                        translate([60, SupportAreaHeight-SupportBlockHeight, 0]) {
                            cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                                translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                                    cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);
                        }

			/* RpiBoard Vertical Rail */
                        translate([80, SupportAreaHeight - 93, 0]) {
                            cube([10, 92, SupportBlockDepth * 2]);
                        }

                        /* RpiBoard space */
                        translate([80, SupportAreaHeight - 88, 0]) {
                            cube([99, 80, SupportBlockDepth * 2]);
                        }

			/* Right Bottom */
                        translate([SupportAreaWidth - SupportBlockWidth, 0, 0]) {
                            cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                            translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                                cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);
                        }

                        /* Right Top */
                        translate([SupportAreaWidth - SupportBlockWidth,
                                   SupportAreaHeight - SupportBlockHeight, 0]) {
                            cube([SupportBlockWidth, SupportBlockHeight, SupportBlockDepth]);
                            translate([SupportBlockWidth/2, SupportBlockHeight/2, 0])
                                cylinder(SupportBlockDepth * 2, r=SupportHoleRadius);
                        }
                    }

                    /* Touch Connector */
                    color("orange") {
                        translate([179, SupportAreaHeight - 71, 0])
                            cube([26, 90, 5]);
                        translate([179, SupportAreaHeight - 71 + 90 - 5, -MainPanelDepth])
                            cube([30, 5, MainPanelDepth + 5]);
                    }
                }
            }

            /* Side - Left/Right/Bottom */
            color("gray") {
                translate([(GlassWidth - MainPanelWidth) / 2 - SideLRWidth,
                           (GlassHeight - MainPanelHeight) / 2 + BottomHeight - TopMargin, 0])
                    cube([SideLRWidth, SideLRHeight, 1]);

                translate([(GlassWidth - MainPanelWidth) / 2 + MainPanelWidth,
                           (GlassHeight - MainPanelHeight) / 2 + BottomHeight - TopMargin, 0])
                    cube([SideLRWidth, SideLRHeight, 1]);

                translate([(GlassWidth - MainPanelWidth) / 2,
                           (GlassHeight - MainPanelHeight) / 2 - SideBottomHeight - TopMargin, 0])
                    cube([BottomWidth, SideBottomHeight, 1]);
            }
        }
    }
}

// ----------------------------------------------------------------

sunfounder_10_1();
