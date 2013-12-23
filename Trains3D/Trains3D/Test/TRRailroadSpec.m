#import "Kiwi.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"

#define checkCorrection [[theValue(TRRailPointCorrectionEq(r, e)) should] beTrue]
#define rpm(tx, ty, fform, xx, bback) trRailPointApplyTileFormXBack(GEVec2iMake(tx, ty), [TRRailForm fform], xx, bback)
#define cor(p, e) TRRailPointCorrectionMake(p, e)
#define zcor(p) TRRailPointCorrectionMake(p, 0)
#define zrpm(tx, ty, fform, xx, bback) zcor(trRailPointApplyTileFormXBack(GEVec2iMake(tx, ty), [TRRailForm fform], xx, bback))
#define move(p, len) [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {return NO;} forLength:len point:p]
SPEC_BEGIN(TRRailroadSpec)
    describe(@"TRRailroad", ^{
        it(@"should move point", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(10, 7)];

            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, -1) form:[TRRailForm topRight]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, -1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:[TRRailForm bottomRight]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 2) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 2) form:[TRRailForm leftRight]]];

            TRRailPoint p0 = rpm(0, 0, leftRight, 0, NO);
            TRRailPointCorrection r = move(p0, 0.5);
            TRRailPointCorrection e = zcor(trRailPointAddX(p0, 0.5));
            checkCorrection;

            r = move(p0, 1.2);
            e = zrpm(1, 0, leftBottom, 0.2, NO);
            checkCorrection;

            r = move(p0, 1.0 + 3*M_PI_4 + 1.0 + 3*M_PI_4 + 0.2);
            e = zrpm(2, 2, leftRight, 0.2, YES);
            checkCorrection;

            r = move(r.point, 1.0);
            e = cor(rpm(2, 2, leftRight, 1.0, YES), 0.2);
            checkCorrection;

            p0 = rpm(2, 2, leftRight, 0, NO);
            r = move(p0, 1.0 + 3*M_PI_4 + 1.0 + 3*M_PI_4 + 1.2);
            e = cor(rpm(0, 0, leftRight, 1.0, YES), 0.2);
            checkCorrection;
        });
        it(@"should add switches", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(10, 7)];

            TRRail *xRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftRight]];
            [railroad tryAddRail:xRail];
            TRRail *yRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm bottomTop]];
            [railroad tryAddRail:yRail];
            [[theValue([[railroad rails] count]) should] equal:@2];
            [[theValue([[railroad switches] count]) should] equal:@0];

            TRRail *turnRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftTop]];
            [railroad tryAddRail:turnRail];
            [[theValue([[railroad rails] count]) should] equal:@3];
            [[theValue([[railroad switches] count]) should] equal:@2];
            
            TRSwitch * theSwitch = [[[railroad.switches chain] findWhere:^BOOL(id x) {
                return [x connector] == [TRRailConnector left];
            }] get];
            [[theValue(GEVec2iEq(theSwitch.tile, GEVec2iMake(2, 0))) should] beTrue];
            [[theSwitch.rail1 should] equal:xRail];
            [[theSwitch.rail2 should] equal:turnRail];

            theSwitch = [[[railroad.switches chain] findWhere:^BOOL(id x) {
                return [x connector] == [TRRailConnector top];
            }] get];
            [[theValue(GEVec2iEq(theSwitch.tile, GEVec2iMake(2, 0))) should] beTrue];
            [[theSwitch.rail1 should] equal:yRail];
            [[theSwitch.rail2 should] equal:turnRail];
        });
        it(@"should choose active switch and should lock moving through closing switch", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(10, 7)];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:[TRRailForm leftRight]]];

            TRRailPoint p0 = rpm(2, 0, leftRight, 0, NO);
            TRRailPointCorrection r = move(p0, 1.2);
            TRRailPointCorrection e = zrpm(3, 0, leftTop, 0.2, NO);
            checkCorrection;

            TRSwitch * theSwitch = railroad.switches[0];
            theSwitch.firstActive = NO;

            r = move(p0, 1.2);
            e = zrpm(3, 0, leftRight, 0.2, NO);
            checkCorrection;

            theSwitch.firstActive = YES;
            p0 = rpm(3, 0, leftRight, 0, YES);
            r = move(p0, 1.2);
            e = cor(rpm(3, 0, leftRight, 1.0, YES), 0.2);
            checkCorrection;
        });
        it(@"should create light near a city", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(1, 1)];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(-1, 0) form:[TRRailForm leftRight]]];

            NSArray * lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:0];

            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:[TRRailForm leftRight]]];
            lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:1];
            TRRailLight * light = railroad.lights[0];
            [[theValue(GEVec2iEq(light.tile, GEVec2iMake(-1, 0))) should] beTrue];
            [[light.connector should] equal:[TRRailConnector right]];
        });
        it(@"should create lights near turn rails", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(3, 3)];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 2) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 1) form:[TRRailForm bottomRight]]];
            NSArray * lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:0];

            [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:[TRRailForm leftTop]]];
            lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:3];
        });
    });
SPEC_END