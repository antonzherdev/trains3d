#import "Kiwi.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGMapIso.h"

#define checkCorrection [[theValue(TRRailPointCorrectionEq(r, e)) should] beTrue]
#define rpm(tx, ty, form, x, back) TRRailPointMake(EGPointIMake(tx, ty), [TRRailForm form].ordinal, x, back)
#define cor(p, e) TRRailPointCorrectionMake(p, e)
#define zcor(p) TRRailPointCorrectionMake(p, 0)
#define zrpm(tx, ty, form, x, back) zcor(TRRailPointMake(EGPointIMake(tx, ty), [TRRailForm form].ordinal, x, back))

SPEC_BEGIN(TRRailroadSpec)
    describe(@"TRRailroad", ^{
        it(@"should move point", ^{
            EGMapSso *map = [EGMapSso mapSsoWithSize:EGSizeIMake(10, 7)];
            TRRailroad * railroad = [TRRailroad railroadWithMap:map];

            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, -1) form:[TRRailForm topRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, -1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 1) form:[TRRailForm bottomRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 2) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 2) form:[TRRailForm leftRight]]];

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
            EGMapSso *map = [EGMapSso mapSsoWithSize:EGSizeIMake(10, 7)];
            TRRailroad * railroad = [TRRailroad railroadWithMap:map];

            TRRail *xRail = [TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm leftRight]];
            [railroad tryAddRail:xRail];
            TRRail *yRail = [TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm bottomTop]];
            [railroad tryAddRail:yRail];
            [[theValue([[railroad rails] count]) should] equal:@2];
            [[theValue([[railroad switches] count]) should] equal:@0];

            TRRail *turnRail = [TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm leftTop]];
            [railroad tryAddRail:turnRail];
            [[theValue([[railroad rails] count]) should] equal:@3];
            [[theValue([[railroad switches] count]) should] equal:@2];
            
            TRSwitch * theSwitch = railroad.switches[0];
            [[theValue(EGPointIEq(theSwitch.tile, EGPointIMake(2, 0))) should] beTrue];
            [[theSwitch.connector should] equal:[TRRailConnector left]];
            [[theSwitch.rail1 should] equal:xRail];
            [[theSwitch.rail2 should] equal:turnRail];

            theSwitch = railroad.switches[1];
            [[theValue(EGPointIEq(theSwitch.tile, EGPointIMake(2, 0))) should] beTrue];
            [[theSwitch.connector should] equal:[TRRailConnector top]];
            [[theSwitch.rail1 should] equal:yRail];
            [[theSwitch.rail2 should] equal:turnRail];
        });
        it(@"should choose active switch and should lock moving through closing switch", ^{
            EGMapSso *map = [EGMapSso mapSsoWithSize:EGSizeIMake(10, 7)];
            TRRailroad * railroad = [TRRailroad railroadWithMap:map];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 0) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 0) form:[TRRailForm leftRight]]];

            TRRailPoint p0 = rpm(2, 0, leftRight, 0, NO);
            TRRailPointCorrection r = [railroad moveForLength:1.2 point:p0];
            TRRailPointCorrection e = zrpm(3, 0, leftTop, 0.2, NO);
            checkCorrection;

            TRSwitch * theSwitch = railroad.switches[0];
            theSwitch.firstActive = NO;

            r = [railroad moveForLength:1.2 point:p0];
            e = zrpm(3, 0, leftRight, 0.2, NO);
            checkCorrection;

            theSwitch.firstActive = YES;
            p0 = rpm(3, 0, leftRight, 0, YES);
            r = [railroad moveForLength:1.2 point:p0];
            e = cor(rpm(3, 0, leftRight, 1.0, YES), 0.2);
            checkCorrection;
        });
        it(@"should create light near a city", ^{
            EGMapSso *map = [EGMapSso mapSsoWithSize:EGSizeIMake(1, 1)];
            TRRailroad * railroad = [TRRailroad railroadWithMap:map];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(-1, 0) form:[TRRailForm leftRight]]];

            [[railroad.lights should] haveCountOf:1];
            TRLight * light = railroad.lights[0];
            [[theValue(EGPointIEq(light.tile, EGPointIMake(-1, 0))) should] beTrue];
            [[light.connector should] equal:[TRRailConnector right]];
        });
    });
SPEC_END