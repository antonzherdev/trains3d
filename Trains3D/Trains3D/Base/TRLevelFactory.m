#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTree.h"
#import "TRWeather.h"
#import "TRTrain.h"
#import "TRLevel.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
@implementation TRLevelFactory
static TRScoreRules* _TRLevelFactory_scoreRules;
static TRForestRules* _TRLevelFactory_forestRules;
static TRWeatherRules* _TRLevelFactory_weatherRules;
static ODClassType* _TRLevelFactory_type;

+ (instancetype)levelFactory {
    return [[TRLevelFactory alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLevelFactory class]) {
        _TRLevelFactory_type = [ODClassType classTypeWithCls:[TRLevelFactory class]];
        _TRLevelFactory_scoreRules = [TRLevelFactory scoreRulesWithInitialScore:100000];
        _TRLevelFactory_forestRules = [TRForestRules forestRulesWithForestType:TRForestType.Pine thickness:1.0];
        _TRLevelFactory_weatherRules = [TRWeatherRules weatherRulesWithSunny:1.0 windStrength:1.0 blastness:0.1 blastMinLength:5.0 blastMaxLength:10.0 blastStrength:10.0 precipitation:[CNOption none]];
    }
}

+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore {
    return [TRScoreRules scoreRulesWithInitialScore:initialScore railCost:1000 railRemoveCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return 1000 + [train carsCount] * 500;
    } destructionFine:^NSInteger(TRTrain* train) {
        return 5000 + [train carsCount] * 2500;
    } delayPeriod:60.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return 1000 + i * 1000;
    } repairCost:1000];
}

+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize {
    return [TRLevel levelWithNumber:0 rules:[TRLevelRules levelRulesWithMapSize:mapSize theme:TRLevelTheme.forest scoreRules:_TRLevelFactory_scoreRules weatherRules:_TRLevelFactory_weatherRules repairerSpeed:30 sporadicDamagePeriod:0 events:(@[])]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules notifications:[TRNotifications notifications]];
}

+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize {
    EGMapSso* map = [EGMapSso mapSsoWithSize:mapSize];
    return [[TRRailroad railroadWithMap:map score:[TRLevelFactory score] forest:[TRForest forestWithMap:map rules:_TRLevelFactory_forestRules weather:[TRWeather weatherWithRules:_TRLevelFactory_weatherRules]]] actor];
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


