#import "objd.h"
#import "PGVec.h"
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
@class PGPlatform;
@class TRRailroad;
@class TRRailroadState;

@class TRLevels;

@interface TRLevels : NSObject
+ (instancetype)levels;
- (instancetype)init;
- (CNClassType*)type;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (CNTuple*)createNewCity;
+ (CNTuple*)create2Cities;
+ (TRPrecipitation*)lightRain;
+ (TRPrecipitation*)rain;
+ (TRPrecipitation*)snow;
+ (CNTuple*)slowTrain;
+ (CNTuple*)train;
+ (CNTuple*)verySlowTrain;
+ (CNTuple*)expressTrain;
+ (CNTuple*)crazyTrain;
+ (TRScoreRules*)scoreRulesWithInitialScore:(NSInteger)initialScore;
+ (CNTuple*)showTrainHelp;
+ (CNTuple*)showTrainHelpWithSwitches;
+ (CNTuple*)awaitBy:(CNFuture*(^)(TRLevel*))by;
+ (CNFuture*(^)(TRLevel*))noTrains;
+ (CNTuple*)awaitCitiesConnectedA:(unsigned int)a b:(unsigned int)b;
- (NSString*)description;
+ (CNClassType*)type;
@end


