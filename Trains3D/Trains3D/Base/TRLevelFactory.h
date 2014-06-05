#import "objd.h"
#import "TRTree.h"
#import "TRHistory.h"
#import "TRLevel.h"
#import "PGVec.h"
@class TRScoreRules;
@class TRWeatherRules;
@class TRScore;
@class TRRailroad;
@class PGMapSso;
@class TRWeather;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (instancetype)levelFactory;
- (instancetype)init;
- (CNClassType*)type;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (TRLevel*)levelWithMapSize:(PGVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(PGVec2i)mapSize;
- (NSString*)description;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (TRRewindRules)rewindRules;
+ (CNClassType*)type;
@end


