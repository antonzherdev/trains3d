#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTree.h"
#import "TRWeather.h"
#import "TRLevel.h"
#import "TRStrings.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRCity.h"
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
    _TRLevelFactory_scoreRules = [TRLevelFactory scoreRulesWithInitialScore:100000];
    _TRLevelFactory_forestRules = [TRForestRules forestRulesWithTreeType:TRTreeType.Pine thickness:1.0];
    _TRLevelFactory_weatherRules = [TRWeatherRules weatherRulesWithSunny:1.0 windStrength:1.0 blastness:0.1 blastMinLength:5.0 blastMaxLength:10.0 blastStrength:10.0 precipitation:[CNOption none]];
    _TRLevelFactory_rules = (@[[TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest scoreRules:[TRLevelFactory scoreRulesWithInitialScore:20000] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:[CNOption none]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@1.0, [TRLevelFactory showHelpText:[TRStr.Loc helpConnectTwoCities]]), tuple(@30.0, [TRLevelFactory trainCars:[CNRange applyI:2] speed:[CNRange applyI:30]]), tuple(numf(((CGFloat)(TRLevel.trainComingPeriod + 3))), [TRLevelFactory showTrainHelp]), tuple(@40.0, [TRLevelFactory createNewCity]), tuple(@1.0, [TRLevelFactory showHelpText:[TRStr.Loc helpNewCity]]), tuple(@20.0, [TRLevelFactory trainCars:[CNRange applyI:1] speed:[CNRange applyI:20]]), tuple(numf(((CGFloat)(TRLevel.trainComingPeriod + 3))), [TRLevelFactory showTrainHelpWithSwitches]), tuple(@50.0, [TRLevelFactory trainCars:[CNRange applyI:3] speed:[CNRange applyI:30]])])], [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest scoreRules:[TRLevelFactory scoreRulesWithInitialScore:20000] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:[CNOption none]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain])])], [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest scoreRules:[TRLevelFactory scoreRulesWithInitialScore:30000] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.3 blastMinLength:1.0 blastMaxLength:5.0 blastStrength:0.6 precipitation:[CNOption applyValue:[TRLevelFactory rain]]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain])])], [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) theme:TRLevelTheme.forest scoreRules:[TRLevelFactory scoreRulesWithInitialScore:40000] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.1 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.3 precipitation:[CNOption none]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@35.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@0.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@5.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@5.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain])])], [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.winter scoreRules:[TRLevelFactory scoreRulesWithInitialScore:60000] weatherRules:[TRWeatherRules weatherRulesWithSunny:0.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:[CNOption none]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@17.0, [TRLevelFactory slowTrain]), tuple(@30.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@22.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@5.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@40.0, [TRLevelFactory slowTrain]), tuple(@5.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@50.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@10.0, [TRLevelFactory slowTrain]), tuple(@5.0, [TRLevelFactory slowTrain]), tuple(@60.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@25.0, [TRLevelFactory slowTrain]), tuple(@20.0, [TRLevelFactory slowTrain]), tuple(@15.0, [TRLevelFactory slowTrain])])], [TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 5) theme:TRLevelTheme.winter scoreRules:[TRLevelFactory scoreRulesWithInitialScore:60000] weatherRules:[TRWeatherRules weatherRulesWithSunny:1.0 windStrength:0.3 blastness:0.05 blastMinLength:1.0 blastMaxLength:3.0 blastStrength:0.1 precipitation:[CNOption applyValue:[TRLevelFactory snow]]] repairerSpeed:20 events:(@[tuple(@0.0, [TRLevelFactory create2Cities]), tuple(@10.0, [TRLevelFactory train]), tuple(@17.0, [TRLevelFactory train]), tuple(@30.0, [TRLevelFactory train]), tuple(@15.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@20.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@15.0, [TRLevelFactory train]), tuple(@22.0, [TRLevelFactory train]), tuple(@20.0, [TRLevelFactory train]), tuple(@40.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory train]), tuple(@15.0, [TRLevelFactory train]), tuple(@40.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory train]), tuple(@15.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory createNewCity]), tuple(@20.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@40.0, [TRLevelFactory train]), tuple(@5.0, [TRLevelFactory train]), tuple(@15.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@40.0, [TRLevelFactory train]), tuple(@5.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory train]), tuple(@50.0, [TRLevelFactory train]), tuple(@20.0, [TRLevelFactory train]), tuple(@10.0, [TRLevelFactory train]), tuple(@5.0, [TRLevelFactory train]), tuple(@60.0, [TRLevelFactory train]), tuple(@20.0, [TRLevelFactory train]), tuple(@25.0, [TRLevelFactory train]), tuple(@20.0, [TRLevelFactory train]), tuple(@15.0, [TRLevelFactory expressTrain])])]]);
}

+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore {
    return [TRScoreRules scoreRulesWithInitialScore:initialScore railCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 1000));
    } destructionFine:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 5000));
    } delayPeriod:45.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return i * 1000;
    } repairCost:1000];
}

+ (void(^)(TRLevel*))trainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.simple carsCount:cars speed:speed carTypes:(@[TRCarType.car, TRCarType.engine])]];
    };
}

+ (void(^)(TRLevel*))expressTrainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.simple carsCount:cars speed:speed carTypes:(@[TRCarType.expressCar, TRCarType.expressEngine])]];
    };
}

+ (void(^)(TRLevel*))showHelpText:(NSString*)text {
    return ^void(TRLevel* level) {
        [level showHelpText:text];
    };
}

+ (void(^)(TRLevel*))createNewCity {
    return ^void(TRLevel* level) {
        [level createNewCity];
    };
}

+ (void(^)(TRLevel*))create2Cities {
    return ^void(TRLevel* level) {
        [level createNewCity];
        [level createNewCity];
    };
}

+ (void(^)(TRLevel*))createCityWithTile:(GEVec2i)tile direction:(TRCityAngle*)direction {
    return ^void(TRLevel* level) {
        [level createCityWithTile:tile direction:direction];
    };
}

+ (TRPrecipitation*)rain {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType.rain strength:1.0];
}

+ (TRPrecipitation*)snow {
    return [TRPrecipitation precipitationWithTp:TRPrecipitationType.snow strength:1.0];
}

+ (void(^)(TRLevel*))slowTrain {
    return [TRLevelFactory trainCars:intTo(1, 4) speed:intTo(25, 35)];
}

+ (void(^)(TRLevel*))train {
    return [TRLevelFactory trainCars:intTo(1, 5) speed:intTo(25, 50)];
}

+ (void(^)(TRLevel*))expressTrain {
    return [TRLevelFactory expressTrainCars:intTo(1, 4) speed:intTo(75, 100)];
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    if(number > [_TRLevelFactory_rules count]) return [TRLevel levelWithNumber:[_TRLevelFactory_rules count] rules:[_TRLevelFactory_rules applyIndex:[_TRLevelFactory_rules count] - 1]];
    else return [TRLevel levelWithNumber:number rules:[_TRLevelFactory_rules applyIndex:number - 1]];
}

+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize {
    return [TRLevel levelWithNumber:0 rules:[TRLevelRules levelRulesWithMapSize:mapSize theme:TRLevelTheme.forest scoreRules:_TRLevelFactory_scoreRules weatherRules:_TRLevelFactory_weatherRules repairerSpeed:30 events:(@[])]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules notifications:[TRNotifications notifications]];
}

+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize {
    EGMapSso* map = [EGMapSso mapSsoWithSize:mapSize];
    return [TRRailroad railroadWithMap:map score:[TRLevelFactory score] forest:[TRForest forestWithMap:map rules:_TRLevelFactory_forestRules weather:[TRWeather weatherWithRules:_TRLevelFactory_weatherRules]]];
}

+ (void(^)(TRLevel*))showTrainHelp {
    return ^void(TRLevel* level) {
        [level showHelpText:[TRStr.Loc helpTrainTo:((TRTrain*)([[level trains] head])).color.localName]];
    };
}

+ (void(^)(TRLevel*))showTrainHelpWithSwitches {
    return ^void(TRLevel* level) {
        [level showHelpText:[TRStr.Loc helpTrainWithSwitchesTo:((TRTrain*)([[level trains] head])).color.localName]];
    };
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


