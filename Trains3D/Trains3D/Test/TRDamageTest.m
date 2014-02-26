#import "TRDamageTest.h"

#import "TRLevelFactory.h"
#import "TRRailroad.h"
@implementation TRDamageTest
static ODClassType* _TRDamageTest_type;

+ (instancetype)damageTest {
    return [[TRDamageTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDamageTest class]) _TRDamageTest_type = [ODClassType classTypeWithCls:[TRDamageTest class]];
}

- (void)testMain {
    TRRailroad* railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(4, 3)];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm.leftRight]];
    [railroad addDamageAtPoint:trRailPointApplyTileFormXBack(GEVec2iMake(1, 1), TRRailForm.leftRight, 0.3, NO)];
    [railroad addDamageAtPoint:trRailPointApplyTileFormXBack(GEVec2iMake(1, 1), TRRailForm.leftRight, 0.6, YES)];
    __block id<CNSeq> damagesCount = (@[]);
    TRRailPoint p0 = trRailPointApplyTileFormXBack(GEVec2iMake(1, 1), TRRailForm.leftRight, 0.0, NO);
    TRRailPointCorrection p1 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return YES;
    } forLength:1.0 point:p0];
    [self assertEqualsA:damagesCount b:(@[@0.3, @0.35])];
    [self assertEqualsA:numf(p1.error) b:@0.0];
    [self assertEqualsA:numf(p1.point.x) b:@1.0];
    damagesCount = (@[]);
    TRRailPointCorrection p00 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return YES;
    } forLength:1.0 point:trRailPointInvert(p1.point)];
    [self assertEqualsA:damagesCount b:(@[@0.65, @0.7])];
    [self assertEqualsA:numf(p00.error) b:@0.0];
    [self assertEqualsA:numf(p00.point.x) b:@1.0];
    damagesCount = (@[]);
    TRRailPointCorrection p01 = [railroad moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType.damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return NO;
    } forLength:1.0 point:trRailPointInvert(p1.point)];
    [self assertEqualsA:damagesCount b:(@[@0.65])];
    [self assertEqualsA:numf(p01.error) b:@0.35];
    [self assertEqualsA:numf(p01.point.x) b:@0.65];
}

- (ODClassType*)type {
    return [TRDamageTest type];
}

+ (ODClassType*)type {
    return _TRDamageTest_type;
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


