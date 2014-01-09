#import "objd.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRForestRules;
@class TRForestType;
@class TRWeatherRules;
@class TRLevelRules;
@class TRLevelTheme;
@class TRStr;
@class TRStrings;
@class EGPlatform;
@class TRLevel;
@class TRTrain;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRCityAngle;
@class TRPrecipitation;
@class TRPrecipitationType;
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
+ (void(^)(TRLevel*))train;
+ (void(^)(TRLevel*))verySlowTrain;
+ (void(^)(TRLevel*))expressTrain;
+ (void(^)(TRLevel*))crazyTrain;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (void(^)(TRLevel*))showTrainHelp;
+ (void(^)(TRLevel*))showTrainHelpWithSwitches;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)forestRules;
+ (TRWeatherRules*)weatherRules;
+ (CNNotificationHandle*)lineAdviceTimeNotification;
+ (CNNotificationHandle*)slowMotionHelpNotification;
+ (ODClassType*)type;
@end


