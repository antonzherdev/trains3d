#import "Kiwi.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"

#define checkCorrection [[r should] equal:e]
#define rpm(tx, ty, fform, xx, bback) [[TRRailPoint alloc] initWithTile:EGPointIMake(tx, ty) form:[TRRailForm fform] x:xx back:bback]
#define cor(p, e) [TRRailPointCorrection railPointCorrectionWithPoint:p error:e]
#define zcor(p) [TRRailPointCorrection railPointCorrectionWithPoint:p error:0]
#define zrpm(tx, ty, fform, xx, bback) zcor([[TRRailPoint alloc] initWithTile:EGPointIMake(tx, ty) form:[TRRailForm fform] x:xx back:bback])
#define move(p, len) [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {return NO;} forLength:len point:p]
SPEC_BEGIN(TRRailroadSpec)
    describe(@"TRRailroad", ^{
        it(@"should move point", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:EGSizeIMake(10, 7)];

            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, -1) form:[TRRailForm topRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, -1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 1) form:[TRRailForm bottomRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 1) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 2) form:[TRRailForm leftBottom]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 2) form:[TRRailForm leftRight]]];

            TRRailPoint* p0 = rpm(0, 0, leftRight, 0, NO);
            TRRailPointCorrection* r = move(p0, 0.5);
            TRRailPointCorrection* e = zcor([p0 addX:0.5]);
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
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:EGSizeIMake(10, 7)];

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
            
            TRSwitch * theSwitch = [[[railroad.switches chain] find:^BOOL(id x) {
                return [x connector] == [TRRailConnector left];
            }] get];
            [[theValue(EGPointIEq(theSwitch.tile, EGPointIMake(2, 0))) should] beTrue];
            [[theSwitch.rail1 should] equal:xRail];
            [[theSwitch.rail2 should] equal:turnRail];

            theSwitch = [[[railroad.switches chain] find:^BOOL(id x) {
                return [x connector] == [TRRailConnector top];
            }] get];
            [[theValue(EGPointIEq(theSwitch.tile, EGPointIMake(2, 0))) should] beTrue];
            [[theSwitch.rail1 should] equal:yRail];
            [[theSwitch.rail2 should] equal:turnRail];
        });
        it(@"should choose active switch and should lock moving through closing switch", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:EGSizeIMake(10, 7)];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:[TRRailForm leftRight]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 0) form:[TRRailForm leftTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 0) form:[TRRailForm leftRight]]];

            TRRailPoint* p0 = rpm(2, 0, leftRight, 0, NO);
            TRRailPointCorrection* r = move(p0, 1.2);
            TRRailPointCorrection* e = zrpm(3, 0, leftTop, 0.2, NO);
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
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:EGSizeIMake(1, 1)];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(-1, 0) form:[TRRailForm leftRight]]];

            NSArray * lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:0];

            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:[TRRailForm leftRight]]];
            lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:1];
            TRLight * light = railroad.lights[0];
            [[theValue(EGPointIEq(light.tile, EGPointIMake(-1, 0))) should] beTrue];
            [[light.connector should] equal:[TRRailConnector right]];
        });
        it(@"should create lights near turn rails", ^{
            TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:EGSizeIMake(3, 3)];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 2) form:[TRRailForm bottomTop]]];
            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 1) form:[TRRailForm bottomRight]]];
            NSArray * lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:0];

            [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:[TRRailForm leftTop]]];
            lc = (NSArray *) railroad.lights;
            [[lc should] haveCountOf:3];
        });
    });
SPEC_END