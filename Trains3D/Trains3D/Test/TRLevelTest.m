#import "TRLevelTest.h"

#import "TRLevelFactory.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "CNFuture.h"
#import "CNDispatchQueue.h"
#import "CNChain.h"
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
        TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(5, 5)];
        TRRailroad* railroad = level->_railroad;
        TRRail* r0 = [TRRail railWithTile:PGVec2iMake(0, 0) form:TRRailForm_leftRight];
        [railroad tryAddRail:r0];
        TRRail* r1 = [TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_leftRight];
        [railroad tryAddRail:r1];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(2, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(3, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_leftBottom]];
        assertEquals(numui([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] count]), @1);
        TRSwitchState* sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertEquals((wrap(PGVec2i, sw->_switch->_rail1->_tile)), (wrap(PGVec2i, (PGVec2iMake(1, 0)))));
        assertEquals([TRRailForm value:sw->_switch->_rail1->_form], [TRRailForm value:TRRailForm_leftRight]);
        assertTrue(sw->_firstActive);
        TRTrain* train = [TRTrain trainWithLevel:level trainType:TRTrainType_simple color:TRCityColor_grey carTypes:(@[[TRCarType value:TRCarType_engine]]) speed:30];
        [[level testRunTrain:train fromPoint:trRailPointApplyTileFormXBack((PGVec2iMake(1, 0)), TRRailForm_leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw->_switch] getResultAwait:1.0];
        sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertTrue(sw->_firstActive);
        assertTrue(unumb([[level isLockedRail:r0] getResultAwait:1.0]));
        [[train setHead:trRailPointApplyTileFormXBack((PGVec2iMake(3, 0)), TRRailForm_leftRight, 0.0, NO)] getResultAwait:1.0];
        [[level tryTurnASwitch:sw->_switch] getResultAwait:1.0];
        sw = ((TRSwitchState*)(nonnil([[((TRRailroadState*)([[railroad state] getResultAwait:1.0])) switches] head])));
        assertFalse(sw->_firstActive);
        assertFalse(unumb([[level isLockedRail:r0] getResultAwait:1.0]));
    }];
}

- (void)testCity {
    [self repeatTimes:10 f:^void() {
        TRLevel* level = [TRLevelFactory levelWithMapSize:PGVec2iMake(2, 1)];
        TRRailroad* railroad = level->_railroad;
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(0, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(0, 0) form:TRRailForm_leftTop]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(0, 0) form:TRRailForm_topRight]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_leftRight]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_leftTop]];
        [railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(1, 0) form:TRRailForm_topRight]];
        [level createNewCity];
        [level createNewCity];
        [CNThread sleepPeriod:0.1];
        NSArray* cities = [[level cities] getResultAwait:1.0];
        assertEquals(@2, numi(((NSInteger)([cities count]))));
        [[[cities chain] mapF:^TRCity*(TRCityState* _) {
            return ((TRCityState*)(_))->_city;
        }] forEach:^void(TRCity* city) {
            assertTrue((pgVec2iIsEqualTo(((TRCity*)(city))->_tile, (PGVec2iMake(0, 1))) || pgVec2iIsEqualTo(((TRCity*)(city))->_tile, (PGVec2iMake(1, 1)))));
            assertEquals([TRCityAngle value:TRCityAngle_angle90], [TRCityAngle value:((TRCity*)(city))->_angle]);
        }];
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

