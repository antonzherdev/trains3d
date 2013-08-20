#import "TRDamageTest.h"

#import "EGMapIso.h"
#import "TRRailroad.h"
#import "TRScore.h"
#import "TRLevelFactory.h"
#import "TRRailPoint.h"
@implementation TRDamageTest

+ (id)damageTest {
    return [[TRDamageTest alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (void)testMain {
    TRRailroad* railroad = [TRRailroad railroadWithMap:[EGMapSso mapSsoWithSize:EGSizeIMake(4, 3)] score:[TRScore scoreWithRules:TRLevelFactory.scoreRules]];
    [railroad tryAddRail:[TRRail railWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight]];
    [railroad addDamageAtPoint:[TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight x:0.2 back:NO]];
    [railroad addDamageAtPoint:[TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight x:0.6 back:YES]];
    __block id<CNList> damagesCount = (@[]);
    TRRailPoint* p0 = [TRRailPoint railPointWithTile:EGPointIMake(1, 1) form:TRRailForm.leftRight x:0 back:NO];
    TRRailPointCorrection* p1 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount arrayByAddingObject:numf(o.point.x)];
        return YES;
    } forLength:1 point:p0];
    [self assertEqualsA:damagesCount b:(@[@0.2, @0.4])];
    [self assertEqualsA:numf(p1.error) b:@0];
    [self assertEqualsA:numf(p1.point.x) b:@1];
    damagesCount = (@[]);
    TRRailPointCorrection* p00 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount arrayByAddingObject:numf(o.point.x)];
        return YES;
    } forLength:1 point:[p1.point invert]];
    [self assertEqualsA:damagesCount b:(@[@0.6, @0.8])];
    [self assertEqualsA:numf(p00.error) b:@0];
    [self assertEqualsA:numf(p00.point.x) b:@1];
    damagesCount = (@[]);
    TRRailPointCorrection* p01 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount arrayByAddingObject:numf(o.point.x)];
        return NO;
    } forLength:1 point:[p1.point invert]];
    [self assertEqualsA:damagesCount b:(@[@0.6])];
    [self assertEqualsA:numf(p01.error) b:@0.4];
    [self assertEqualsA:numf(p01.point.x) b:@0.6];
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

