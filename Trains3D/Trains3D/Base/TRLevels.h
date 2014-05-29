#import "objd.h"
#import "GEVec.h"
#import "TRLevel.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRWeather.h"
#import "TRCity.h"
@class TRLevelFactory;
@class TRStr;
@class TRStrings;
@class TRGameDirector;
@class TRScoreRules;
@class CNFuture;
@class EGPlatform;
@class TRRailroad;
@class TRRailroadState;

@class TRLevels;

@interface TRLevels : NSObject
+ (instancetype)levels;
- (instancetype)init;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


