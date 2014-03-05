#import "TRLevelTest.h"

#import "TRLevelFactory.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "TRCar.h"
@implementation TRLevelTest
static ODClassType* _TRLevelTest_type;

+ (instancetype)levelTest {
    return [[TRLevelTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelTest class]) _TRLevelTest_type = [ODClassType classTypeWithCls:[TRLevelTest class]];
}

- (void)testSwitchLock {
    TRLevel* level = [TRLevelFactory levelWithMapSize:GEVec2iMake(5, 5)];
    TRRailroad* railroad = level.railroad;
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm.leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm.leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:TRRailForm.leftRight]];
    [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftBottom]];
    assertEquals(numui([[railroad switches] count]), @1);
    TRSwitch* sw = [[railroad switches] head];
    assertEquals((wrap(GEVec2i, sw.rail1.tile)), (wrap(GEVec2i, (GEVec2iMake(1, 0)))));
    assertEquals(sw.rail1.form, TRRailForm.leftRight);
    assertTrue(sw.firstActive);
    TRTrain* train = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.grey carTypes:(@[TRCarType.engine]) speed:30].actor;
    [level testRunTrain:train fromPoint:trRailPointApplyTileFormXBack((GEVec2iMake(1, 0)), TRRailForm.leftRight, 0.0, NO)];
    [level tryTurnTheSwitch:sw];
    [CNThread sleepPeriod:0.1];
    assertTrue(sw.firstActive);
    [train setHead:trRailPointApplyTileFormXBack((GEVec2iMake(2, 0)), TRRailForm.leftRight, 0.0, NO)];
    [level tryTurnTheSwitch:sw];
    [CNThread sleepPeriod:0.1];
    assertFalse(sw.firstActive);
}

- (ODClassType*)type {
    return [TRLevelTest type];
}

+ (ODClassType*)type {
    return _TRLevelTest_type;
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


