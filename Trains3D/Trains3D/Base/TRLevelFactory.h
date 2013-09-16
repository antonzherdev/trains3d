#import "objd.h"
#import "GEVec.h"
@class TRScoreRules;
@class TRTrain;
@class TRLevelRules;
@class EGScene;
@class TRLevelView;
@class TRLevelProcessor;
@class EGLayer;
@class TRLevelMenuView;
@class TRLevelMenuProcessor;
@class TRLevel;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRScore;
@class TRRailroad;
@class EGMapSso;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (TRScoreRules*)scoreRules;
+ (ODClassType*)type;
@end


