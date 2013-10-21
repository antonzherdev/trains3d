#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTrain.h"
#import "TRTree.h"
#import "TRWeather.h"
#import "TRLevel.h"
#import "TRCar.h"
#import "TRNotification.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
@implementation TRLevelFactory
static TRScoreRules* _TRLevelFactory_scoreRules;
static TRForestRules* _TRLevelFactory_forestRules;
static TRWeatherRules* _TRLevelFactory_weatherRules;
static id<CNSeq> _TRLevelFactory_rules;
static ODClassType* _TRLevelFactory_type;

+ (id)levelFactory {
    return [[TRLevelFactory alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelFactory_type = [ODClassType classTypeWithCls:[TRLevelFactory class]];
    _TRLevelFactory_scoreRules = [TRScoreRules scoreRulesWithInitialScore:100000 railCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 2000));
    } destructionFine:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 3000));
    } delayPeriod:10.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return i * 1000;
    } repairCost:2000];
    _TRLevelFactory_forestRules = [TRForestRules forestRulesWithTypes:[TRTreeType values] thickness:1.0];
    _TRLevelFactory_weatherRules = [TRWeatherRules weatherRulesWithWindStrength:1.0 blastness:0.1 blastMinLength:5.0 blastMaxLength:10.0 blastStrength:10.0];
    _TRLevelFactory_rules = (@[[TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) scoreRules:_TRLevelFactory_scoreRules forestRules:[TRForestRules forestRulesWithTypes:(@[TRTreeType.pine]) thickness:2.0] weatherRules:[TRWeatherRules weatherRulesWithWindStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3] repairerSpeed:30 events:(@[tuple(@1.0, [TRLevelFactory trainCars:intTo(2, 4) speed:[intTo(50, 60) setStep:10]]), tuple(@10.0, [TRLevelFactory trainCars:intTo(2, 3) speed:[intTo(50, 60) setStep:10]]), tuple(@15.0, [TRLevelFactory createNewCity])])]]);
}

+ (void(^)(TRLevel*))trainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.simple carsCount:cars speed:speed carTypes:(@[TRCarType.car, TRCarType.engine])]];
    };
}

+ (void(^)(TRLevel*))createNewCity {
    return ^void(TRLevel* level) {
        [level createNewCity];
    };
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    return [TRLevel levelWithRules:[_TRLevelFactory_rules applyIndex:number - 1]];
}

+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize {
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:mapSize scoreRules:_TRLevelFactory_scoreRules forestRules:_TRLevelFactory_forestRules weatherRules:_TRLevelFactory_weatherRules repairerSpeed:30 events:(@[])]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules notifications:[TRNotifications notifications]];
}

+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize {
    EGMapSso* map = [EGMapSso mapSsoWithSize:mapSize];
    return [TRRailroad railroadWithMap:map score:[TRLevelFactory score] forest:[TRForest forestWithMap:map rules:_TRLevelFactory_forestRules weather:[TRWeather weatherWithRules:_TRLevelFactory_weatherRules]]];
}

- (ODClassType*)type {
    return [TRLevelFactory type];
}

+ (TRScoreRules*)scoreRules {
    return _TRLevelFactory_scoreRules;
}

+ (TRForestRules*)forestRules {
    return _TRLevelFactory_forestRules;
}

+ (TRWeatherRules*)weatherRules {
    return _TRLevelFactory_weatherRules;
}

+ (ODClassType*)type {
    return _TRLevelFactory_type;
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


