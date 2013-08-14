#import "objd.h"
#import "EGTypes.h"
@class EGScene;
@class EGLayer;
@class EGMapSso;
@class EGSchedule;
@class TRTrain;
@class TRCar;
@class TRLevelRules;
@class TRLevel;
@class TRLevelView;
@class TRLevelMenuView;
@class TRLevelProcessor;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(EGSizeI)mapSize;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(EGSizeI)mapSize;
+ (TRScoreRules*)scoreRules;
@end


