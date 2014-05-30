#import "TRTrainCollisionsTest.h"

#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "CNDispatchQueue.h"
#import "CNFuture.h"
#import "TRTrainCollisions.h"
#import "CNChain.h"
#import "TRRailroad.h"
@implementation TRTrainCollisionsTest
static CGFloat _TRTrainCollisionsTest_carLen;
static CGFloat _TRTrainCollisionsTest_carWidth;
static CGFloat _TRTrainCollisionsTest_carConLen;
static CNClassType* _TRTrainCollisionsTest_type;

+ (instancetype)trainCollisionsTest {
    return [[TRTrainCollisionsTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainCollisionsTest class]) {
        _TRTrainCollisionsTest_type = [CNClassType classTypeWithCls:[TRTrainCollisionsTest class]];
        _TRTrainCollisionsTest_carLen = [TRCarType value:TRCarType_engine].fullLength;
        _TRTrainCollisionsTest_carWidth = [TRCarType value:TRCarType_engine].width;
        _TRTrainCollisionsTest_carConLen = [TRCarType value:TRCarType_engine].startToFront;
    }
}

- (TRLevel*)newLevel {
    return [TRLevelFactory levelWithMapSize:GEVec2iMake(5, 3)];
}

- (id<CNSet>)aCheckLevel:(TRLevel*)level {
    [CNThread sleepPeriod:0.05];
    return [[[((NSArray*)([[level detectCollisions] getResultAwait:2.0])) chain] flatMapF:^NSArray*(TRCarsCollision* _) {
        return ((TRCarsCollision*)(_)).trains;
    }] toSet];
}

- (void)testStraight {
    [self repeatTimes:100 f:^void() {
        TRLevel* level = [self newLevel];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm_leftRight]];
        [self doTest1ForLevel:level form:TRRailForm_leftRight big:NO];
    }];
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm_leftRight]];
    [self doTest1ForLevel:level form:TRRailForm_leftRight big:YES];
}

- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailFormR)form big:(BOOL)big {
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_green carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:0];
    TRRailPoint p = trRailPointApplyTileFormXBack((GEVec2iMake(0, 0)), form, 0.0, NO);
    TRRailPoint p2 = [((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRTrainCollisionsTest_carLen point:p].point;
    [level testRunTrain:t1 fromPoint:p2];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_orange carTypes:(@[[TRCarType value:TRCarType_engine], [TRCarType value:TRCarType_engine]]) speed:0];
    p2 = [((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRTrainCollisionsTest_carLen * 3 point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self aCheckLevel:level];
    assertTrue([cols isEmpty]);
    p2 = trRailPointAddX(p2, -2 * _TRTrainCollisionsTest_carConLen + 0.1);
    [t2 setHead:p2];
    cols = [self aCheckLevel:level];
    assertTrue([cols isEmpty]);
    p2 = trRailPointAddX(p2, -0.2);
    [t2 setHead:p2];
    cols = [self aCheckLevel:level];
    assertEquals(cols, ([(@[t1, t2]) toSet]));
    if(big) {
        assertEquals(numui([((NSArray*)([[level trains] getResultAwait:1.0])) count]), @2);
        assertEquals(numui([((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])).damages.points count]), @0);
        [level processCollisions];
        [CNThread sleepPeriod:0.5];
        assertEquals(numui([((NSArray*)([[level trains] getResultAwait:1.0])) count]), @0);
        [level updateWithDelta:5.1];
        [CNThread sleepPeriod:0.5];
        assertEquals(numui([((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])).damages.points count]), @1);
    }
}

- (void)testTurn {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm_leftTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 1) form:TRRailForm_bottomRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:TRRailForm_leftRight]];
    [self doTest1ForLevel:level form:TRRailForm_leftTop big:YES];
}

- (void)testCross {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm_bottomTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 1) form:TRRailForm_leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_bottomTop]];
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_green carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:0];
    TRRailPoint p = trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm_bottomTop, 0.0, NO);
    TRRailPoint p1 = [((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:(0.5 - _TRTrainCollisionsTest_carWidth) - 0.001 point:p].point;
    [level testRunTrain:t1 fromPoint:p1];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_orange carTypes:(@[[TRCarType value:TRCarType_engine], [TRCarType value:TRCarType_engine]]) speed:0];
    p = trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm_leftRight, 0.0, NO);
    TRRailPoint p2 = [((TRRailroadState*)([[level.railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRTrainCollisionsTest_carLen * 2 point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self aCheckLevel:level];
    assertTrue([cols isEmpty]);
    [t1 setHead:trRailPointAddX(p2, -0.002)];
    cols = [self aCheckLevel:level];
    assertEquals(cols, ([(@[t1, t2]) toSet]));
}

- (void)emulateLevel:(TRLevel*)level seconds:(CGFloat)seconds {
    {
        id<CNIterator> __il__0i = [intTo(1, ((NSInteger)(30 * seconds))) iterator];
        while([__il__0i hasNext]) {
            id ii = [__il__0i next];
            [[level _updateWithDelta:1.0 / 30.0] getResultAwait:1.0];
        }
    }
    [CNThread sleepPeriod:0.05 * seconds];
    NSInteger i = 0;
    while(i < 10) {
        [[level dummy] getResultAwait:2.0];
        [[level.collisions dummy] getResultAwait:2.0];
        [((NSArray*)([[level trains] getResultAwait:2.0])) forEach:^void(TRTrain* _) {
            [[((TRTrain*)(_)) dummy] getResultAwait:2.0];
        }];
        [[level dummy] getResultAwait:2.0];
        i++;
    }
}

- (void)testSimulation {
    [self repeatTimes:100 f:^void() {
        TRLevel* level = [self newLevel];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 2) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 2) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 2) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 2) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 3) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 3) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 3) form:TRRailForm_leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 3) form:TRRailForm_leftRight]];
        TRTrain* c1 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_green carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:100];
        TRRailPoint p = trRailPointApplyTileFormXBack((GEVec2iMake(0, 0)), TRRailForm_leftRight, c1.length, NO);
        [[level testRunTrain:c1 fromPoint:p] getResultAwait:1.0];
        TRTrain* c2 = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_green carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:100];
        p = trRailPointApplyTileFormXBack((GEVec2iMake(3, 0)), TRRailForm_leftRight, c2.length, YES);
        [[level testRunTrain:c2 fromPoint:p] getResultAwait:1.0];
        assertEquals(numui([((NSArray*)([[level trains] getResultAwait:1.0])) count]), @2);
        assertEquals(numui([((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) count]), @0);
        [self emulateLevel:level seconds:1.0];
        assertEquals(numui([((NSArray*)([[level trains] getResultAwait:1.0])) count]), @2);
        assertEquals(numui([((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) count]), @0);
        [self emulateLevel:level seconds:1.0];
        assertEquals(numui([((NSArray*)([[level trains] getResultAwait:1.0])) count]), @0);
        assertEquals(numui([((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) count]), @2);
        NSArray* st1 = [[[[((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) chain] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] futureF:^NSArray*(CNChain* _) {
            return [_ toArray];
        }] getResultAwait:1.0];
        NSArray* st11 = [[[[((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) chain] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] futureF:^NSArray*(CNChain* _) {
            return [_ toArray];
        }] getResultAwait:1.0];
        assertTrue([st1 isEqual:st11]);
        [self emulateLevel:level seconds:0.1];
        NSArray* st2 = [[[[((id<CNSeq>)([[level dyingTrains] getResultAwait:1.0])) chain] mapF:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] futureF:^NSArray*(CNChain* _) {
            return [_ toArray];
        }] getResultAwait:1.0];
        assertTrue(!([st1 isEqual:st2]));
    }];
}

- (NSString*)description {
    return @"TrainCollisionsTest";
}

- (CNClassType*)type {
    return [TRTrainCollisionsTest type];
}

+ (CGFloat)carLen {
    return _TRTrainCollisionsTest_carLen;
}

+ (CGFloat)carWidth {
    return _TRTrainCollisionsTest_carWidth;
}

+ (CGFloat)carConLen {
    return _TRTrainCollisionsTest_carConLen;
}

+ (CNClassType*)type {
    return _TRTrainCollisionsTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

