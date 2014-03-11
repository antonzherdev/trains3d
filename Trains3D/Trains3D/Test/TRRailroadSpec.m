#import "TRLevel.h"
#import "TRRailroad.h"
#import "TRLevelFactory.h"
#import "TSTestCase.h"

#define checkCorrection assertTrue(TRRailPointCorrectionEq(r, e))
#define rpm(tx, ty, fform, xx, bback) trRailPointApplyTileFormXBack(GEVec2iMake(tx, ty), [TRRailForm fform], xx, bback)
#define cor(p, e) TRRailPointCorrectionMake(p, e)
#define zcor(p) TRRailPointCorrectionMake(p, 0)
#define zrpm(tx, ty, fform, xx, bback) zcor(trRailPointApplyTileFormXBack(GEVec2iMake(tx, ty), [TRRailForm fform], xx, bback))
#define move(p, len) [railroad.state moveWithObstacleProcessor:^BOOL(TRObstacle* o) {return NO;} forLength:len point:p]


@interface TRRailroadSpec : TSTestCase
@end

@implementation TRRailroadSpec
-(void) testMovePoint {
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
}


-(void) testAddSwitches {
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(10, 7)];

    TRRail *xRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftRight]];
    [railroad tryAddRail:xRail];
    TRRail *yRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm bottomTop]];
    [railroad tryAddRail:yRail];
    assertEquals(numi([[railroad rails] count]), @2);
    assertEquals(numi([[railroad switches] count]), @0);

    TRRail *turnRail = [TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftTop]];
    [railroad tryAddRail:turnRail];
    assertEquals(numi([[railroad rails] count]), @3);
    assertEquals(numi([[railroad switches] count]), @2);

    TRSwitchState * theSwitch = [[[railroad.switches chain] findWhere:^BOOL(id x) {
        return [x connector] == [TRRailConnector left];
    }] get];
    assertTrue(GEVec2iEq(theSwitch.tile, GEVec2iMake(2, 0)));
    assertEquals(theSwitch.aSwitch.rail1, xRail);
    assertEquals(theSwitch.aSwitch.rail2, turnRail);

    theSwitch = [[[railroad.switches chain] findWhere:^BOOL(id x) {
        return [x connector] == [TRRailConnector top];
    }] get];
    assertTrue(GEVec2iEq(theSwitch.tile, GEVec2iMake(2, 0)));
    assertEquals(theSwitch.aSwitch.rail1, yRail);
    assertEquals(theSwitch.aSwitch.rail2, turnRail);
}
-(void) testSwitchLock {
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(10, 7)];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:[TRRailForm leftRight]]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:[TRRailForm leftTop]]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:[TRRailForm leftRight]]];

    TRRailPoint p0 = rpm(2, 0, leftRight, 0, NO);
    TRRailPointCorrection r = move(p0, 1.2);
    TRRailPointCorrection e = zrpm(3, 0, leftTop, 0.2, NO);
    checkCorrection;

    TRSwitchState * theSwitch = railroad.switches[0];
    [railroad turnASwitch:theSwitch.aSwitch];


    r = move(p0, 1.2);
    e = zrpm(3, 0, leftRight, 0.2, NO);
    checkCorrection;

    [railroad turnASwitch:theSwitch.aSwitch];
    p0 = rpm(3, 0, leftRight, 0, YES);
    r = move(p0, 1.2);
    e = cor(rpm(3, 0, leftRight, 1.0, YES), 0.2);
    checkCorrection;
}
-(void) testCreationLightNearCity {
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(1, 1)];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(-1, 0) form:[TRRailForm leftRight]]];

    NSArray * lc = (NSArray *) railroad.lights;
    assertEquals(numi(lc.count), @1);
    TRRailLight * light = railroad.lights[0];
    assertTrue(GEVec2iEq(light.tile, GEVec2iMake(-1, 0)));
    assertEquals(light.connector, [TRRailConnector right]);
}
@end