#import "TRLevelTest.h"

#import "TRLevelFactory.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "CNFuture.h"
@implementation TRLevelTest
static CNClassType* _TRLevelTest_type;

+ (instancetype)levelTest {
    return [[TRLevelTest alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelTest class]) _TRLevelTest_type = [CNClassType classTypeWithCls:[TRLevelTest class]];
}

- (void)testLock {
    [self repeatTimes:10 f:^void() {
        TRLevel* level = [TRLevelFactory levelWithMapSize:GEVec2iMake(5, 5)];
        TRRailroad* railroad = level.railroad;
        TRRail* r0 = [TRRail railWithTile:GEVec2iMake(0, 0) form:TRRailForm_leftRight];
        [railroad tryAddRail:r0];
        TRRail* r1 = [TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_leftRight];
        [railroad tryAddRail:r1];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(2, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(3, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:GEVec2iMake(1, 0) form:TRRailForm_leftBottom]];
        assertEquals(numui([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] count]), @1);
        TRSwitchState* sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertEquals((wrap(GEVec2i, sw.aSwitch.rail1.tile)), (wrap(GEVec2i, (GEVec2iMake(1, 0)))));
        assertEquals([TRRailForm value:sw.aSwitch.rail1.form], [TRRailForm value:TRRailForm_leftRight]);
        assertTrue(sw.firstActive);
        TRTrain* train = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_grey carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:30];
        [[level testRunTrain:train fromPoint:trRailPointApplyTileFormXBack((GEVec2iMake(1, 0)), TRRailForm_leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw.aSwitch] getResultAwait:1.0];
        sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertTrue(sw.firstActive);
        assertTrue(unumb([[level isLockedRail:r0] getResultAwait:1.0]));
        [[train setHead:trRailPointApplyTileFormXBack((GEVec2iMake(3, 0)), TRRailForm_leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw.aSwitch] getResultAwait:1.0];
        sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertFalse(sw.firstActive);
        assertFalse(unumb([[level isLockedRail:r0] getResultAwait:1.0]));
    }];
}

- (NSString*)description {
    return @"LevelTest";
}

- (CNClassType*)type {
    return [TRLevelTest type];
}

+ (CNClassType*)type {
    return _TRLevelTest_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

