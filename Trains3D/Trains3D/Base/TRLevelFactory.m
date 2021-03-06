#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRWeather.h"
#import "TRRailroad.h"
#import "PGMapIso.h"
@implementation TRLevelFactory
static TRScoreRules* _TRLevelFactory_scoreRules;
static TRForestRules* _TRLevelFactory_forestRules;
static TRWeatherRules* _TRLevelFactory_weatherRules;
static TRRewindRules _TRLevelFactory_rewindRules;
static CNClassType* _TRLevelFactory_type;

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
        _TRLevelFactory_type = [CNClassType classTypeWithCls:[TRLevelFactory class]];
        _TRLevelFactory_scoreRules = [TRLevelFactory scoreRulesWithInitialScore:100000];
        _TRLevelFactory_forestRules = [TRForestRules forestRulesWithForestType:TRForestType_Pine thickness:1.0];
        _TRLevelFactory_weatherRules = [TRWeatherRules aDefault];
        _TRLevelFactory_rewindRules = trRewindRulesDefault();
    }
}

+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore {
    return [TRScoreRules aDefaultInitialScore:initialScore];
}

+ (TRLevel*)levelWithMapSize:(PGVec2i)mapSize {
    return [TRLevel levelWithNumber:0 rules:[TRLevelRules levelRulesWithMapSize:mapSize theme:TRLevelTheme_forest trainComingPeriod:10 scoreRules:_TRLevelFactory_scoreRules rewindRules:_TRLevelFactory_rewindRules weatherRules:_TRLevelFactory_weatherRules repairerSpeed:30 sporadicDamagePeriod:0 events:((NSArray*)((@[])))]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules notifications:[TRNotifications notifications]];
}

+ (TRRailroad*)railroadWithMapSize:(PGVec2i)mapSize {
    PGMapSso* map = [PGMapSso mapSsoWithSize:mapSize];
    return [TRRailroad railroadWithMap:map score:[TRLevelFactory score] forest:[TRForest forestWithMap:map rules:_TRLevelFactory_forestRules weather:[TRWeather weatherWithRules:_TRLevelFactory_weatherRules]]];
}

- (NSString*)description {
    return @"LevelFactory";
}

- (CNClassType*)type {
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

+ (TRRewindRules)rewindRules {
    return _TRLevelFactory_rewindRules;
}

+ (CNClassType*)type {
    return _TRLevelFactory_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

