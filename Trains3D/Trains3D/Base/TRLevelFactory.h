#import "objd.h"
#import "EGTypes.h"
@class EGScene;
@class EGLayer;
@class TRTrain;
@class TRCar;
@class TRLevelRules;
@class TRLevel;
@class TRLevelView;
@class TRLevelProcessor;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
@end


