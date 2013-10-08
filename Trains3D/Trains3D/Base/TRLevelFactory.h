#import "objd.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRTrain;
@class TRForestRules;
@class TRTreeType;
@class TRWeatherRules;
@class TRLevelRules;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRLevel;
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
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (ODClassType*)type;
@end


