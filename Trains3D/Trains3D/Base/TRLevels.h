#import "objd.h"
#import "GEVec.h"
@class TRLevelRules;
@class TRLevelTheme;
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
@class TRLevelFactory;
@class TRTrain;
@class TRCityColor;
@class EGPlatform;

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
+ (ODClassType*)type;
@end


