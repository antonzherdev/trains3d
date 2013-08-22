#import "TRCollisionsTest.h"

#import "EGCollisions.h"
#import "TRTypes.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"
#import "TRRailroad.h"
#import "TRTrain.h"
@implementation TRCollisionsTest
static CGFloat _carLen;
static CGFloat _carWidth;

+ (id)collisionsTest {
    return [[TRCollisionsTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _carLen = [TRCarType.car fullLength];
    _carWidth = TRCarType.car.width;
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

- (void)doTest1ForLevel:(TRLevel*)level delta:(CGFloat)delta form:(TRRailForm*)form {
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.green cars:(@[[TRCar carWithCarType:TRCarType.car]]) speed:((NSUInteger)(0))];
    TRRailPoint* p = [TRRailPoint railPointWithTile:EGPointIMake(0, 0) form:form x:((CGFloat)(0)) back:NO];
    TRRailPoint* p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen point:p].point;
    [level testRunTrain:t1 fromPoint:p2];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.orange cars:(@[[TRCar carWithCarType:TRCarType.car], [TRCar carWithCarType:TRCarType.car]]) speed:((NSUInteger)(0))];
    p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen * 3 + delta point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    [self assertTrueValue:[cols isEmpty]];
    p2 = [p2 addX:-delta - 0.001];
    [t2 setHead:p2];
    cols = [self checkLevel:level];
    [self assertEqualsA:cols b:[(@[t1, t2]) toSet]];
    [self assertEqualsA:numui([[level trains] count]) b:numui(((NSUInteger)(2)))];
    [self assertEqualsA:numui([[level.railroad damagesPoints] count]) b:numui(((NSUInteger)(0)))];
    [level processCollisions];
    [self assertEqualsA:numui([[level trains] count]) b:numui(((NSUInteger)(0)))];
    [self assertEqualsA:numui([[level.railroad damagesPoints] count]) b:numui(((NSUInteger)(1)))];
    TRRailPoint* damage = ((TRRailPoint*)([[level.railroad damagesPoints] applyIndex:0]));
    [self assertTrueValue:floatBetween(damage.x, 0.59, 0.6)];
}

- (void)testTurn {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 0) form:TRRailForm.leftTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(0, 1) form:TRRailForm.bottomRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight]];
    [self doTest1ForLevel:level delta:0.3 form:TRRailForm.leftTop];
}

- (void)testCross {
    TRLevel* level = [self newLevel];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.bottomTop]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(2, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(3, 1) form:TRRailForm.leftRight]];
    [level.railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 0) form:TRRailForm.bottomTop]];
    TRTrain* t1 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.green cars:(@[[TRCar carWithCarType:TRCarType.car]]) speed:((NSUInteger)(0))];
    TRRailPoint* p = [TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.bottomTop x:((CGFloat)(0)) back:NO];
    TRRailPoint* p1 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:0.5 - _carWidth - 0.001 point:p].point;
    [level testRunTrain:t1 fromPoint:p1];
    TRTrain* t2 = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRColor.orange cars:(@[[TRCar carWithCarType:TRCarType.car], [TRCar carWithCarType:TRCarType.car]]) speed:((NSUInteger)(0))];
    p = [TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight x:((CGFloat)(0)) back:NO];
    TRRailPoint* p2 = [level.railroad moveWithObstacleProcessor:^BOOL(TRObstacle* _) {
        return NO;
    } forLength:_carLen * 2 point:p].point;
    [level testRunTrain:t2 fromPoint:p2];
    id<CNSet> cols = [self checkLevel:level];
    [self assertTrueValue:[cols isEmpty]];
    [t1 setHead:[p2 addX:-0.002]];
    cols = [self checkLevel:level];
    [self assertEqualsA:cols b:[(@[t1, t2]) toSet]];
}

+ (CGFloat)carLen {
    return _carLen;
}

+ (CGFloat)carWidth {
    return _carWidth;
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


