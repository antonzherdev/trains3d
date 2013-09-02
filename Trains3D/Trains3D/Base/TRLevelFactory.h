#import "objd.h"
@class CNRange;
@class CNRangeIterator;
#import "EGTypes.h"
@class EGScene;
@class EGLayer;
@class EGMapSso;
@class EGMapSsoView;
@class TRTrainType;
@class TRTrain;
@class TREngineType;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;
@class TRLevelRules;
@class TRLevel;
@class TRLevelView;
@class TRLevelMenuView;
@class TRLevelProcessor;
@class TRLevelMenuProcessor;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelFactory;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(EGSizeI)mapSize;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(EGSizeI)mapSize;
+ (TRScoreRules*)scoreRules;
+ (ODClassType*)type;
@end


