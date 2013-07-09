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
        TRRailroad * railroad = [TRRailroad railroadWithMapSize:EGISizeMake(10, 7)];

        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(0, 0) form:[TRRailForm leftRight]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(1, 0) form:[TRRailForm leftBottom]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(1, -1) form:[TRRailForm topRight]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, -1) form:[TRRailForm leftTop]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, 0) form:[TRRailForm bottomTop]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, 1) form:[TRRailForm bottomRight]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(3, 1) form:[TRRailForm leftTop]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(3, 2) form:[TRRailForm leftBottom]]];
        [railroad tryAddRail:[TRRail railWithTile:EGIPointMake(2, 2) form:[TRRailForm leftRight]]];
        it(@"should move point", ^{
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
    });
SPEC_END