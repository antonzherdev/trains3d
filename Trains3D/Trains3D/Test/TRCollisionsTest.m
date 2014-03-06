#import "TRCollisionsTest.h"

#import "TRCar.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRCollisions.h"
#import "TRRailroad.h"
#import "TRTrain.h"
#import "TRCity.h"
@implementation TRCollisionsTest
static CGFloat _TRCollisionsTest_carLen;
static CGFloat _TRCollisionsTest_carWidth;
static CGFloat _TRCollisionsTest_carConLen;
static ODClassType* _TRCollisionsTest_type;

+ (instancetype)collisionsTest {
    return [[TRCollisionsTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCollisionsTest class]) {
        _TRCollisionsTest_type = [ODClassType classTypeWithCls:[TRCollisionsTest class]];
        _TRCollisionsTest_carLen = TRCarType.engine.fullLength;
        _TRCollisionsTest_carWidth = TRCarType.engine.width;
        _TRCollisionsTest_carConLen = TRCarType.engine.startToFront;
    }
}

- (TRLevel*)newLevel {
    return [TRLevelFactory levelWithMapSize:GEVec2iMake(5, 3)];
}

- (id<CNSet>)checkLevel:(TRLevel*)level {
    return [[[((id<CNSeq>)([((CNTry*)([[[level detectCollisions] waitResultPeriod:10.0] get])) get])) chain] flatMap:^id<CNSet>(TRCarsCollision* _) {
        return ((TRCarsCollision*)(_)).trains;
    }] toSet];
}

- (void)testStraight {
    __weak TRCollisionsTest* _weakSelf = self;
    [self repeatTimes:100 f:^void() {
        TRLevel* level = [_weakSelf newLevel];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm.leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftRight]];
        [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm.leftRight]];
        [_weakSelf doTest1ForLevel:level form:TRRailForm.leftRight big:NO];
    }];
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm.leftRight]];
    [self doTest1ForLevel:level form:TRRailForm.leftRight big:YES];
}

- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailForm*)form big:(BOOL)big {
    TRTrain* t1 = [[TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.green carTypes:(@[TRCarType.engine]) speed:0] actor];
    TRRailPoint p = trRailPointApplyTileFormXBack((GEVec2iMake(0, 0)), form, 0.0, NO);
    TRRailPoint p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRCollisionsTest_carLen point:p].point;
    [level testRunTrain:t1 fromPoint:p2];
    TRTrain* t2 = [[TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.orange carTypes:(@[TRCarType.engine, TRCarType.engine]) speed:0] actor];
    p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRCollisionsTest_carLen * 3 point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    assertTrue([cols isEmpty]);
    p2 = trRailPointAddX(p2, -2 * _TRCollisionsTest_carConLen + 0.1);
    [t2 setHead:p2];
    cols = [self checkLevel:level];
    assertTrue([cols isEmpty]);
    p2 = trRailPointAddX(p2, -0.2);
    [t2 setHead:p2];
    cols = [self checkLevel:level];
    if(big) {
        assertEquals(numui([[level trainActors] count]), @2);
        assertEquals(numui([[level.railroad damagesPoints] count]), @0);
        [level processCollisions];
        [CNThread sleepPeriod:0.5];
        assertEquals(numui([[level trainActors] count]), @0);
        [level updateWithDelta:5.1];
        [CNThread sleepPeriod:0.5];
        assertEquals(numui([[level.railroad damagesPoints] count]), @1);
    }
}

- (void)testTurn {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm.leftTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 1) form:TRRailForm.bottomRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:TRRailForm.leftRight]];
    [self doTest1ForLevel:level form:TRRailForm.leftTop big:YES];
}

- (void)testCross {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm.bottomTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.bottomTop]];
    TRTrain* t1 = [[TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.green carTypes:(@[TRCarType.engine]) speed:0] actor];
    TRRailPoint p = trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm.bottomTop, 0.0, NO);
    TRRailPoint p1 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:(0.5 - _TRCollisionsTest_carWidth) - 0.001 point:p].point;
    [level testRunTrain:t1 fromPoint:p1];
    TRTrain* t2 = [[TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.orange carTypes:(@[TRCarType.engine, TRCarType.engine]) speed:0] actor];
    p = trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm.leftRight, 0.0, NO);
    TRRailPoint p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_TRCollisionsTest_carLen * 2 point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    assertTrue([cols isEmpty]);
    [t1 setHead:trRailPointAddX(p2, -0.002)];
    cols = [self checkLevel:level];
    assertEquals(cols, ([(@[t1, t2]) toSet]));
}

- (ODClassType*)type {
    return [TRCollisionsTest type];
}

+ (CGFloat)carLen {
    return _TRCollisionsTest_carLen;
}

+ (CGFloat)carWidth {
    return _TRCollisionsTest_carWidth;
}

+ (CGFloat)carConLen {
    return _TRCollisionsTest_carConLen;
}

+ (ODClassType*)type {
    return _TRCollisionsTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


