#import "Kiwi.h"
#import "TRLevel.h"
#import "TRRailroad.h"

#define checkCorrection [[theValue(TRRailPointCorrectionEq(r, e)) should] beTrue]
#define rpm(tx, ty, form, x, back) TRRailPointMake(EGIPointMake(tx, ty), [TRRailForm form].ordinal, x, back)
#define cor(p, e) TRRailPointCorrectionMake(p, e)
#define zcor(p) TRRailPointCorrectionMake(p, 0)
#define zrpm(tx, ty, form, x, back) zcor(TRRailPointMake(EGIPointMake(tx, ty), [TRRailForm form].ordinal, x, back))

SPEC_BEGIN(TRRailroadSpec)
    describe(@"TRRailroad", ^{
        it(@"should move point", ^{
            TRRailroad * railroad = [TRRailroad railroadWithMapSize:EGISizeMake(10, 7)];

            [railroad tryAddRail:[TRRail railWithTile:egip(0, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(1, 0) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(1, -1) form:[TRRailForm topRight]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(2, -1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(2, 0) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(2, 1) form:[TRRailForm bottomRight]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(3, 1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(3, 2) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:egip(2, 2) form:[TRRailForm leftRight]]];

            TRRailPoint p0 = rpm(0, 0, leftRight, 0, NO);
            TRRailPointCorrection r = [railroad moveForLength:0.5 point:p0];
            TRRailPointCorrection e = zcor(trRailPointAdd(p0, 0.5));
            checkCorrection;

            r = [railroad moveForLength:1.2 point:p0];
            e = zrpm(1, 0, leftBottom, 0.2, NO);
            checkCorrection;

            r = [railroad moveForLength:1.0 + 3*M_PI_4 + 1.0 + 3*M_PI_4 + 0.2 point:p0];
            e = zrpm(2, 2, leftRight, 0.2, YES);
            checkCorrection;

            r = [railroad moveForLength:1.0 point:r.point];
            e = cor(rpm(2, 2, leftRight, 1.0, YES), 0.2);
            checkCorrection;

            p0 = rpm(2, 2, leftRight, 0, NO);
            r = [railroad moveForLength:1.0 + 3*M_PI_4 + 1.0 + 3*M_PI_4 + 1.2 point:p0];
            e = cor(rpm(0, 0, leftRight, 1.0, YES), 0.2);
            checkCorrection;
        });
        it(@"should add switches", ^{
            TRRailroad * railroad = [TRRailroad railroadWithMapSize:EGISizeMake(10, 7)];

            TRRail *xRail = [TRRail railWithTile:egip(2, 0) form:[TRRailForm leftRight]];
            [railroad tryAddRail:xRail];
            TRRail *yRail = [TRRail railWithTile:egip(2, 0) form:[TRRailForm bottomTop]];
            [railroad tryAddRail:yRail];
            [[theValue([[railroad rails] count]) should] equal:@2];
            [[theValue([[railroad switches] count]) should] equal:@0];

            TRRail *turnRail = [TRRail railWithTile:egip(2, 0) form:[TRRailForm leftTop]];
            [railroad tryAddRail:turnRail];
            [[theValue([[railroad rails] count]) should] equal:@3];
            [[theValue([[railroad switches] count]) should] equal:@2];
            
            TRSwitch * theSwitch = railroad.switches[0];
            [[theValue(EGIPointEq(theSwitch.tile, egip(2, 0))) should] beTrue];
            [[theSwitch.connector should] equal:[TRRailConnector left]];
            [[theSwitch.rail1 should] equal:xRail];
            [[theSwitch.rail2 should] equal:turnRail];

            theSwitch = railroad.switches[1];
            [[theValue(EGIPointEq(theSwitch.tile, egip(2, 0))) should] beTrue];
            [[theSwitch.connector should] equal:[TRRailConnector top]];
            [[theSwitch.rail1 should] equal:yRail];
            [[theSwitch.rail2 should] equal:turnRail];
        });
    });
SPEC_END