#import "TRCollisionsTest.h"

#import "EGCollisions.h"
#import "TRTypes.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRCollisionsTest
static double _carLen;
static double _carWidth;
static double _carsDelta;

+ (id)collisionsTest {
    return [[TRCollisionsTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _carLen = 0.6;
    _carWidth = 0.2;
    _carsDelta = 0.3;
}

- (TRLevel*)newLevel {
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:EGSizeIMake(5, 3) scoreRules:TRLevelFactory.scoreRules repairerSpeed:((NSUInteger)(30)) events:(@[])]];
}

- (id<CNSet>)checkLevel:(TRLevel*)level {
    return [[[[[level detectCollisions] chain] flatMap:^CNPair*(EGCollision* _) {
        return _.items;
    }] map:^TRTrain*(CNTuple* _) {
        return ((TRTrain*)(_.a));
    }] toSet];
}

- (void)testStraight {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 0) form:TRRailForm.leftRight]];
    [self doTest1ForLevel:level delta:0.001 form:TRRailForm.leftRight];
}

- (void)doTest1ForLevel:(TRLevel*)level delta:(double)delta form:(TRRailForm*)form {
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.green cars:(@[[ODObject object]]) speed:((NSUInteger)(0))];
    TRRailPoint* p = [TRRailPoint railPointWithTile:EGPointIMake(0, 0) form:form x:0 back:NO];
    TRRailPoint* p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen point:p].point;
    [level testRunTrain:t1 fromPoint:p2];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.orange cars:(@[[ODObject object], [ODObject object]]) speed:((NSUInteger)(0))];
    p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen * 3 + _carsDelta + delta point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    [self assertTrueValue:[cols isEmpty]];
    p2 = [p2 addX:-delta - 0.001];
    [t2 setHead:p2];
    cols = [self checkLevel:level];
    [self assertEqualsA:cols b:[(@[t1, t2]) toSet]];
    [self assertEqualsA:numi([[level trains] count]) b:numi(((NSUInteger)(2)))];
    [self assertEqualsA:numi([[level.railroad damagesPoints] count]) b:numi(((NSUInteger)(0)))];
    [level processCollisions];
    [self assertEqualsA:numi([[level trains] count]) b:numi(((NSUInteger)(0)))];
    [self assertEqualsA:numi([[level.railroad damagesPoints] count]) b:numi(((NSUInteger)(1)))];
    TRRailPoint* damage = ((TRRailPoint*)([[level.railroad damagesPoints] applyIndex:0]));
    [self assertTrueValue:floatBetween(damage.x, 0.59, 0.6)];
}

- (void)testTurn {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:TRRailForm.leftTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 1) form:TRRailForm.bottomRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight]];
    [self doTest1ForLevel:level delta:_carsDelta form:TRRailForm.leftTop];
}

- (void)testCross {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.bottomTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:TRRailForm.bottomTop]];
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.green cars:(@[[ODObject object]]) speed:((NSUInteger)(0))];
    TRRailPoint* p = [TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.bottomTop x:0 back:NO];
    TRRailPoint* p1 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:0.5 - _carWidth - 0.001 point:p].point;
    [level testRunTrain:t1 fromPoint:p1];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.orange cars:(@[[ODObject object], [ODObject object]]) speed:((NSUInteger)(0))];
    p = [TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight x:0 back:NO];
    TRRailPoint* p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen * 2 + _carsDelta point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    [self assertTrueValue:[cols isEmpty]];
    [t1 setHead:[p2 addX:-0.002]];
    cols = [self checkLevel:level];
    [self assertEqualsA:cols b:[(@[t1, t2]) toSet]];
}

+ (double)carLen {
    return _carLen;
}

+ (double)carWidth {
    return _carWidth;
}

+ (double)carsDelta {
    return _carsDelta;
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


