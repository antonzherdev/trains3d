#import "objd.h"
#import "TRTree.h"
#import "TRHistory.h"
#import "TRLevel.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRWeatherRules;
@class TRScore;
@class TRRailroad;
@class EGMapSso;
@class TRWeather;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (instancetype)levelFactory;
- (instancetype)init;
- (CNClassType*)type;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
- (NSString*)description;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (TRRewindRules)rewindRules;
+ (CNClassType*)type;
@end


