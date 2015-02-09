#import "TRDemo.h"

#import "TRLevels.h"
#import "TRLevelFactory.h"
#import "TRWeather.h"
#import "PGDirector.h"
#import "TRSceneFactory.h"
#import "TRRailroad.h"
#import "CNFuture.h"
@implementation TRDemo
static TRLevelRules* _TRDemo_demoLevel0;
static TRLevelRules* _TRDemo_demoLevel1;
static TRLevelRules* _TRDemo_demoLevel2;
static TRLevelRules* _TRDemo_demoLevel3;
static CNClassType* _TRDemo_type;

+ (instancetype)demo {
    return [[TRDemo alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDemo class]) {
        _TRDemo_type = [CNClassType classTypeWithCls:[TRDemo class]];
        _TRDemo_demoLevel0 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_leafForest trainComingPeriod:5 scoreRules:[TRLevels scoreRulesWithInitialScore:1000000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.05 blastness:0.01 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, [TRDemo createCitiesCount:2]), tuple(@10.0, [TRLevels createNewCity]), tuple(@100000.0, [TRLevels verySlowTrain])])];
        _TRDemo_demoLevel1 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_leafForest trainComingPeriod:3 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, ([TRDemo createCitiesCities:(@[tuple3(@1, @-2, @4), tuple3(@4, @3, @3), tuple3(@-1, @0, @4), tuple3(@3, @4, @2), tuple3(@3, @-2, @3)])])), tuple(@0.0, ([TRDemo buildRailroadRails:(@[tuple3(@3, @3, @5), tuple3(@3, @3, @6), tuple3(@3, @3, @4), tuple3(@3, @2, @4), tuple3(@3, @1, @3), tuple3(@2, @1, @5), tuple3(@2, @1, @2), tuple3(@2, @1, @1), tuple3(@1, @1, @2), tuple3(@2, @0, @4), tuple3(@0, @1, @2), tuple3(@0, @1, @5), tuple3(@2, @-1, @4), tuple3(@2, @-1, @3), tuple3(@2, @-1, @1), tuple3(@1, @0, @1), tuple3(@2, @-2, @6), tuple3(@1, @-1, @5), tuple3(@1, @-1, @6), tuple3(@1, @-1, @4), tuple3(@-1, @1, @5), tuple3(@0, @0, @6), tuple3(@0, @1, @1)])])), tuple(@0.0, ([TRDemo setSwitchesStateSwitches:(@[tuple4(@3, @3, @3, @0), tuple4(@1, @-1, @2, @1), tuple4(@3, @3, @4, @1), tuple4(@2, @1, @4, @1), tuple4(@0, @1, @4, @1), tuple4(@1, @-1, @3, @1), tuple4(@2, @-1, @1, @1), tuple4(@1, @-1, @4, @1), tuple4(@2, @-1, @2, @1), tuple4(@2, @1, @1, @1), tuple4(@3, @3, @2, @0), tuple4(@0, @1, @1, @1), tuple4(@2, @-1, @3, @0), tuple4(@0, @1, @2, @1), tuple4(@2, @1, @2, @1)])])), tuple(@0.0, [TRDemo trainCars:2 speed:60 from:TRCityColor_beige to:TRCityColor_orange]), tuple(@3.0, [TRDemo trainCars:3 speed:60 from:TRCityColor_pink to:TRCityColor_green]), tuple(@9.0, ([TRDemo setSwitchesStateSwitches:(@[tuple4(@2, @1, @4, @0)])])), tuple(@3.0, ([TRDemo setSwitchesStateSwitches:(@[tuple4(@3, @3, @2, @1)])]))])];
        _TRDemo_demoLevel2 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_forest trainComingPeriod:3 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, ([TRDemo createCitiesCities:(@[tuple3(@-1, @2, @1), tuple3(@1, @4, @2), tuple3(@5, @0, @4), tuple3(@3, @4, @2), tuple3(@-1, @0, @1)])])), tuple(@0.0, ([TRDemo buildRailroadRails:(@[tuple3(@3, @3, @4), tuple3(@2, @2, @5), tuple3(@2, @2, @6), tuple3(@1, @2, @3), tuple3(@1, @3, @6), tuple3(@1, @3, @4), tuple3(@0, @0, @2), tuple3(@2, @1, @3), tuple3(@2, @1, @6), tuple3(@0, @1, @6), tuple3(@1, @3, @5), tuple3(@2, @3, @1), tuple3(@3, @2, @3), tuple3(@5, @1, @1), tuple3(@4, @1, @2), tuple3(@3, @1, @2), tuple3(@2, @1, @2), tuple3(@1, @1, @2), tuple3(@1, @1, @1), tuple3(@0, @2, @1), tuple3(@0, @2, @2), tuple3(@1, @1, @5), tuple3(@1, @0, @3), tuple3(@2, @2, @4), tuple3(@0, @2, @5)])])), tuple(@0.0, ([TRDemo setSwitchesStateSwitches:(@[tuple4(@2, @2, @4, @1), tuple4(@1, @3, @3, @1), tuple4(@2, @1, @3, @1), tuple4(@1, @3, @4, @1), tuple4(@2, @1, @4, @0), tuple4(@1, @1, @1, @1), tuple4(@1, @1, @2, @0), tuple4(@0, @2, @1, @1), tuple4(@0, @2, @2, @1), tuple4(@2, @2, @2, @1), tuple4(@2, @1, @1, @1), tuple4(@2, @2, @3, @1), tuple4(@1, @3, @2, @1), tuple4(@1, @1, @4, @0), tuple4(@0, @2, @4, @1)])])), tuple(@0.0, [TRDemo trainCars:3 speed:60 from:TRCityColor_purple to:TRCityColor_green]), tuple(@1.0, [TRDemo trainCars:2 speed:60 from:TRCityColor_beige to:TRCityColor_pink]), tuple(@0.0, [TRDemo trainCars:3 speed:60 from:TRCityColor_pink to:TRCityColor_orange]), tuple(@13.0, [TRDemo end])])];
        _TRDemo_demoLevel3 = [TRLevelRules levelRulesWithMapSize:PGVec2iMake(5, 3) theme:TRLevelTheme_palm trainComingPeriod:5 scoreRules:[TRLevels scoreRulesWithInitialScore:60000] rewindRules:[TRLevelFactory rewindRules] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.2 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:nil] repairerSpeed:20 sporadicDamagePeriod:0 events:(@[tuple(@0.0, ([TRDemo createCitiesCities:(@[tuple3(@0, @-1, @4), tuple3(@1, @4, @1), tuple3(@4, @3, @3), tuple3(@3, @-2, @3), tuple3(@5, @0, @3)])])), tuple(@0.0, ([TRDemo buildRailroadRails:(@[tuple3(@2, @4, @1), tuple3(@3, @2, @3), tuple3(@2, @-2, @6), tuple3(@2, @1, @3), tuple3(@2, @1, @4), tuple3(@3, @3, @5), tuple3(@3, @3, @2), tuple3(@4, @0, @2), tuple3(@3, @0, @2), tuple3(@0, @0, @5), tuple3(@2, @3, @4), tuple3(@2, @0, @4), tuple3(@2, @0, @5), tuple3(@1, @-1, @6), tuple3(@1, @1, @5), tuple3(@2, @0, @6), tuple3(@2, @3, @6), tuple3(@2, @-1, @1), tuple3(@2, @-1, @3), tuple3(@1, @0, @3), tuple3(@1, @0, @1), tuple3(@2, @2, @5), tuple3(@2, @2, @4), tuple3(@2, @-1, @4), tuple3(@2, @1, @1), tuple3(@3, @3, @1), tuple3(@1, @0, @4)])])), tuple(@0.0, ([TRDemo setSwitchesStateSwitches:(@[tuple4(@2, @1, @3, @1), tuple4(@3, @3, @4, @1), tuple4(@2, @0, @2, @1), tuple4(@2, @0, @3, @0), tuple4(@2, @3, @3, @1), tuple4(@2, @-1, @1, @1), tuple4(@3, @3, @1, @1), tuple4(@2, @0, @4, @0), tuple4(@2, @-1, @2, @1), tuple4(@1, @0, @1, @1), tuple4(@2, @2, @2, @1), tuple4(@2, @1, @1, @1), tuple4(@3, @3, @2, @1), tuple4(@2, @-1, @3, @1), tuple4(@1, @0, @2, @1), tuple4(@1, @0, @3, @1), tuple4(@2, @1, @2, @1)])])), tuple(@0.0, [TRDemo trainCars:3 speed:60 from:TRCityColor_purple to:TRCityColor_pink]), tuple(@1.0, [TRDemo trainCars:2 speed:60 from:TRCityColor_orange to:TRCityColor_green]), tuple(@4.0, [TRDemo expressCars:4 speed:200 from:TRCityColor_green to:TRCityColor_orange]), tuple(@10.0, [TRDemo end])])];
    }
}

+ (CNTuple*)createCitiesCount:(NSInteger)count {
    return tuple([TRLevelEventType value:TRLevelEventType_twoCities], ^void(TRLevel* level) {
        NSInteger i = count;
        while(i > 0) {
            [level createNewCity];
            i--;
        }
        return ;
    });
}

+ (void)startNumber:(NSInteger)number {
    if(number == 1) {
        [[PGDirector current] setScene:^PGScene*() {
            return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:1 rules:_TRDemo_demoLevel1]];
        }];
    } else {
        if(number == 2) {
            [[PGDirector current] setScene:^PGScene*() {
                return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:2 rules:_TRDemo_demoLevel2]];
            }];
        } else {
            if(number == 3) [[PGDirector current] setScene:^PGScene*() {
                return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:3 rules:_TRDemo_demoLevel3]];
            }];
            else [[PGDirector current] setScene:^PGScene*() {
                return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:0 rules:_TRDemo_demoLevel0]];
            }];
        }
    }
}

+ (void)restartLevel {
    [[PGDirector current] setScene:^PGScene*() {
        return [TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:0 rules:_TRDemo_demoLevel0]];
    }];
}

+ (CNTuple*)end {
    return tuple([TRLevelEventType value:TRLevelEventType_twoCities], ^void(TRLevel* level) {
        [level end];
    });
}

+ (CNTuple*)buildRailroadRails:(NSArray*)rails {
    return tuple([TRLevelEventType value:TRLevelEventType_build], (^void(TRLevel* level) {
        for(CNTuple3* rail in rails) {
            NSInteger form = unumi(((CNTuple3*)(rail))->_c) - 1;
            [level->_railroad tryAddRail:[TRRail railWithTile:PGVec2iMake(unumi(((CNTuple3*)(rail))->_a), unumi(((CNTuple3*)(rail))->_b)) form:((TRRailFormR)(form + 1))]];
        }
    }));
}

+ (CNTuple*)createCitiesCities:(NSArray*)cities {
    return tuple([TRLevelEventType value:TRLevelEventType_twoCities], (^void(TRLevel* level) {
        for(CNTuple3* city in cities) {
            NSInteger form = unumi(((CNTuple3*)(city))->_c) - 1;
            [level createCityTile:PGVec2iMake(unumi(((CNTuple3*)(city))->_a), unumi(((CNTuple3*)(city))->_b)) direction:((TRCityAngleR)(form + 1))];
        }
        return ;
    }));
}

+ (CNTuple*)setSwitchesStateSwitches:(NSArray*)switches {
    return tuple([TRLevelEventType value:TRLevelEventType_twoCities], (^void(TRLevel* level) {
        [[level->_railroad state] onCompleteF:^void(CNTry* t) {
            if([t isSuccess]) {
                TRRailroadState* state = [t get];
                for(CNTuple4* sw in switches) {
                    PGVec2i tile = PGVec2iMake(unumi(((CNTuple4*)(sw))->_a), unumi(((CNTuple4*)(sw))->_b));
                    BOOL active = unumi(((CNTuple4*)(sw))->_d) == 1;
                    TRRailConnectorR connector = ((TRRailConnectorR)(unumi(((CNTuple4*)(sw))->_c) - 1 + 1));
                    for(TRSwitchState* sws in [((TRRailroadState*)(state)) switches]) {
                        if(pgVec2iIsEqualTo(((TRSwitchState*)(sws))->_switch->_tile, tile)) {
                            if(((TRSwitchState*)(sws))->_switch->_connector == connector) {
                                if(((TRSwitchState*)(sws))->_firstActive != active) [level tryTurnASwitch:((TRSwitchState*)(sws))->_switch];
                            }
                        }
                    }
                }
            }
        }];
        return ;
    }));
}

+ (CNTuple*)trainCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_simple carsCount:intTo(cars, cars) speed:intTo(speed, speed) carTypes:(@[[TRCarType value:TRCarType_car], [TRCarType value:TRCarType_engine]])] color:to fromCity:from];
    }));
}

+ (CNTuple*)crazyCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_crazy carsCount:intTo(cars, cars) speed:intTo(speed, speed) carTypes:(@[[TRCarType value:TRCarType_car], [TRCarType value:TRCarType_engine]])] color:to fromCity:from];
    }));
}

+ (CNTuple*)expressCars:(NSInteger)cars speed:(NSInteger)speed from:(TRCityColorR)from to:(TRCityColorR)to {
    return tuple([TRLevelEventType value:TRLevelEventType_train], (^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType_fast carsCount:intTo(cars, cars) speed:intTo(speed, speed) carTypes:(@[[TRCarType value:TRCarType_expressCar], [TRCarType value:TRCarType_expressEngine]])] color:to fromCity:from];
    }));
}

- (NSString*)description {
    return @"Demo";
}

- (CNClassType*)type {
    return [TRDemo type];
}

+ (TRLevelRules*)demoLevel0 {
    return _TRDemo_demoLevel0;
}

+ (TRLevelRules*)demoLevel1 {
    return _TRDemo_demoLevel1;
}

+ (TRLevelRules*)demoLevel2 {
    return _TRDemo_demoLevel2;
}

+ (TRLevelRules*)demoLevel3 {
    return _TRDemo_demoLevel3;
}

+ (CNClassType*)type {
    return _TRDemo_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

