#import "TRLevel.h"
#import "TRRailroad.h"
#import "CNChain.h"
#import "TRLevelFactory.h"
#import "TSTestCase.h"
#import "CNFuture.h"

#define checkVec(s1, s2) (fabs(s1.x - s2.x) < 0.0001 && fabs(s1.y - s2.y) < 0.0001)
#define checkPoint(s1, s2) (pgVec2iIsEqualTo(s1.tile, s2.tile) && s1.form == s2.form && fabs(s1.x - s2.x) < 0.0001 && s1.back == s2.back && checkVec(s1.point, s2.point))
#define checkCorrection assertTrue(checkPoint(r.point, e.point) && eqf(r.error, e.error))
#define rpm(tx, ty, fform, xx, bback) trRailPointApplyTileFormXBack(PGVec2iMake(tx, ty), TRRailForm_##fform, xx, bback)
#define cor(p, e) TRRailPointCorrectionMake(p, e)
#define zcor(p) TRRailPointCorrectionMake(p, 0)
#define zrpm(tx, ty, fform, xx, bback) zcor(trRailPointApplyTileFormXBack(PGVec2iMake(tx, ty), TRRailForm_##fform, xx, bback))
#define move(p, len) [[railroad.state getResultAwait:1.0] moveWithObstacleProcessor:^BOOL(TRObstacle* o) {return NO;} forLength:len point:p]
#define lights() [[railroad.state getResultAwait:1.0] lights]
#define rails() [[railroad.state getResultAwait:1.0] rails]
#define switches() [[railroad.state getResultAwait:1.0] switches]

@interface TRRailroadSpec : TSTestCase
@end

@implementation TRRailroadSpec
-(void) testMovePoint {
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:PGVec2iMake(10, 7)];

    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(0, 0) form:TRRailForm_leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_leftBottom]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, -1) form:TRRailForm_topRight]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, -1) form:TRRailForm_leftTop]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_bottomTop]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, 1) form:TRRailForm_bottomRight]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(3, 1) form:TRRailForm_leftTop]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(3, 2) form:TRRailForm_leftBottom]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, 2) form:TRRailForm_leftRight]];

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
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:PGVec2iMake(10, 7)];

    TRRail *xRail = [TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_leftRight];
    [railroad tryAddRail:xRail];
    TRRail *yRail = [TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_bottomTop];
    [railroad tryAddRail:yRail];
    assertEquals(numi([rails() count]), @2);
    assertEquals(numi([switches() count]), @0);

    TRRail *turnRail = [TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_leftTop];
    [railroad tryAddRail:turnRail];
    assertEquals(numi([rails() count]), @3);
    assertEquals(numi([switches() count]), @2);

    TRSwitchState * theSwitch = [[switches() chain] findWhere:^BOOL(id x) {
        return [x connector] == TRRailConnector_left;
    }];
    assertTrue(pgVec2iIsEqualTo(theSwitch.tile, PGVec2iMake(2, 0)));
    assertEquals(theSwitch.aSwitch.rail1, xRail);
    assertEquals(theSwitch.aSwitch.rail2, turnRail);

    theSwitch = [[switches() chain] findWhere:^BOOL(id x) {
        return [x connector] == TRRailConnector_top;
    }];
    assertTrue(pgVec2iIsEqualTo(theSwitch.tile, PGVec2iMake(2, 0)));
    assertEquals(theSwitch.aSwitch.rail1, yRail);
    assertEquals(theSwitch.aSwitch.rail2, turnRail);
}
-(void) testSwitchLock {
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:PGVec2iMake(10, 7)];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(3, 0) form:TRRailForm_leftTop]];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(3, 0) form:TRRailForm_leftRight]];

    TRRailPoint p0 = rpm(2, 0, leftRight, 0, NO);
    TRRailPointCorrection r = move(p0, 1.2);
    TRRailPointCorrection e = zrpm(3, 0, leftTop, 0.2, NO);
    checkCorrection;

    TRSwitchState * theSwitch = switches()[0];
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
    TRRailroad * railroad = [TRLevelFactory railroadWithMapSize:PGVec2iMake(1, 1)];
    [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(-1, 0) form:TRRailForm_leftRight]];
    [CNThread sleepPeriod:0.1];
    NSArray * lc = (NSArray *) lights();
    assertEquals(numi(lc.count), @1);
    TRRailLight * light = lights()[0];
    assertTrue(pgVec2iIsEqualTo(light.tile, PGVec2iMake(-1, 0)));
    assertTrue(light.connector == TRRailConnector_right);
}
@end