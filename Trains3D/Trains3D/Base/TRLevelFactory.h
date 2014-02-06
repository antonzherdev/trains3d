#import "objd.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRForestRules;
@class TRForestType;
@class TRWeatherRules;
@class TRTrain;
@class TRLevel;
@class TRLevelTheme;
@class TRLevelRules;
@class TRScore;
@class TRNotifications;
@class TRRailroad;
@class EGMapSso;
@class TRWeather;
@class TRForest;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
- (ODClassType*)type;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (ODClassType*)type;
@end


