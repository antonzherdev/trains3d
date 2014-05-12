#import "objd.h"
#import "GEVec.h"
@class TRLevelRules;
@class TRLevelTheme;
@class TRLevelFactory;
@class TRWeatherRules;
@class TRStr;
@class TRStrings;
@class TRLevel;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRGameDirector;
@class TRPrecipitation;
@class TRPrecipitationType;
@class TRScoreRules;
@class TRTrain;
@class TRCityColor;
@class EGPlatform;
@class TRRailroad;
@class TRCityState;
@class TRCity;
@class TRRailroadState;

@class TRLevels;

@interface TRLevels : NSObject
+ (instancetype)levels;
- (instancetype)init;
- (ODClassType*)type;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (void(^)(TRLevel*))slowTrain;
+ (void(^)(TRLevel*))train;
+ (void(^)(TRLevel*))verySlowTrain;
+ (void(^)(TRLevel*))expressTrain;
+ (void(^)(TRLevel*))crazyTrain;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (void(^)(TRLevel*))showTrainHelp;
+ (void(^)(TRLevel*))showTrainHelpWithSwitches;
+ (void(^)(TRLevel*))awaitBy:(CNFuture*(^)(TRLevel*))by;
+ (CNFuture*(^)(TRLevel*))noTrains;
+ (void(^)(TRLevel*))awaitCitiesConnectedA:(unsigned int)a b:(unsigned int)b;
+ (ODClassType*)type;
@end


