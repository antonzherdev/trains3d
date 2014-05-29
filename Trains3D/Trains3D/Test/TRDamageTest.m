#import "TRDamageTest.h"

#import "TRLevelFactory.h"
#import "CNFuture.h"
@implementation TRDamageTest
static CNClassType* _TRDamageTest_type;

+ (instancetype)damageTest {
    return [[TRDamageTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDamageTest class]) _TRDamageTest_type = [CNClassType classTypeWithCls:[TRDamageTest class]];
}

- (void)testMain {
    TRRailroad* railroad = [TRLevelFactory railroadWithMapSize:GEVec2iMake(4, 3)];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 1) form:TRRailForm_leftRight]];
    [railroad addDamageAtPoint:trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm_leftRight, 0.3, NO)];
    [railroad addDamageAtPoint:trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm_leftRight, 0.6, YES)];
    __block NSArray* damagesCount = ((NSArray*)((@[])));
    TRRailPoint p0 = trRailPointApplyTileFormXBack((GEVec2iMake(1, 1)), TRRailForm_leftRight, 0.0, NO);
    TRRailPointCorrection p1 = [((TRRailroadState*)([[railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return YES;
    } forLength:1.0 point:p0];
    floatArrayEquals(damagesCount, ((@[@0.3, @0.35])));
    assertEquals(numf(p1.error), @0.0);
    assertEquals(numf(p1.point.x), @1.0);
    damagesCount = ((NSArray*)((@[])));
    TRRailPointCorrection p00 = [((TRRailroadState*)([[railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return YES;
    } forLength:1.0 point:trRailPointInvert(p1.point)];
    floatArrayEquals(damagesCount, ((@[@0.65, @0.7])));
    assertEquals(numf(p00.error), @0.0);
    assertEquals(numf(p00.point.x), @1.0);
    damagesCount = ((NSArray*)((@[])));
    TRRailPointCorrection p01 = [((TRRailroadState*)([[railroad state] getResultAwait:1.0])) moveWithObstacleProcessor:^BOOL(TRObstacle* o) {
        if(o.obstacleType == TRObstacleType_damage) damagesCount = [damagesCount addItem:numf(o.point.x)];
        return NO;
    } forLength:1.0 point:trRailPointInvert(p1.point)];
    floatArrayEquals(damagesCount, (@[@0.65]));
    assertTrue((eqf(p01.error, 0.35)));
    assertTrue((eqf(p01.point.x, 0.65)));
}

- (NSString*)description {
    return @"DamageTest";
}

- (CNClassType*)type {
    return [TRDamageTest type];
}

+ (CNClassType*)type {
    return _TRDamageTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

