#import "objd.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRForestRules;
@class TRTreeType;
@class TRWeatherRules;
@class TRStr;
@protocol TRStrings;
@class TRLevelRules;
@class TRTrain;
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
@class TRCityColor;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
- (ODClassType*)type;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (void(^)(TRLevel*))slowTrain;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (void(^)(TRLevel*))showTrainHelp;
+ (void(^)(TRLevel*))showTrainHelpWithSwitches;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (ODClassType*)type;
@end


