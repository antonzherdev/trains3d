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

- (void)testLock {
    [self repeatTimes:10 f:^void() {
        TRLevel* level = [TRLevelFactory levelWithMapSize:GEVec2iMake(5, 5)];
        TRRailroad* railroad = level.railroad;
        TRRail* r0 = [TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm.leftRight];
        [railroad tryAddRail:r0];
        TRRail* r1 = [TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftRight];
        [railroad tryAddRail:r1];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm.leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:TRRailForm.leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm.leftBottom]];
        assertEquals(numui([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] count]), @1);
        TRSwitchState* sw = [[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head];
        assertEquals((wrap(GEVec2i, sw.aSwitch.rail1.tile)), (wrap(GEVec2i, (GEVec2iMake(1, 0)))));
        assertEquals(sw.aSwitch.rail1.form, TRRailForm.leftRight);
        assertTrue(sw.firstActive);
        TRTrain* train = [TRTrain trainWithLevel:level trainType:TRTrainType.simple color:TRCityColor.grey carTypes:(@[TRCarType.engine]) speed:30];
        [[level testRunTrain:train fromPoint:trRailPointApplyTileFormXBack((GEVec2iMake(1, 0)), TRRailForm.leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw.aSwitch] getResultAwait:1.0];
        sw = [[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head];
        assertTrue(sw.firstActive);
        assertTrue(unumb([((CNTry*)([[[level isLockedRail:r0] waitResultPeriod:1.0] get])) get]));
        [[train setHead:trRailPointApplyTileFormXBack((GEVec2iMake(3, 0)), TRRailForm.leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw.aSwitch] getResultAwait:1.0];
        sw = [[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head];
        assertFalse(sw.firstActive);
        assertFalse(unumb([((CNTry*)([[[level isLockedRail:r0] waitResultPeriod:1.0] get])) get]));
    }];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


