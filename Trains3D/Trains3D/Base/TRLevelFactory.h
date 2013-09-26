#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRScoreRules;
@class TRTrain;
@class TRForestRules;
@class TRTreeType;
@class TRLevelRules;
@class TRLevel;
@class EGGlobal;
@class EGDirector;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRScore;
@class TRNotifications;
@class TRRailroad;
@class EGMapSso;
@class TRLevelView;
@class TRLevelProcessor;
@class TRLevelMenuView;
@class TRLevelPauseMenuView;

@class TRLevelFactory;
@class TRTrainLayers;

@interface TRLevelFactory : NSObject
+ (id)levelFactory;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (void)restartLevel;
+ (TRLevel*)levelWithNumber:(NSUInteger)number;
+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
+ (TRScore*)score;
+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize;
+ (TRScoreRules*)scoreRules;
+ (TRForestRules*)treeRules;
+ (ODClassType*)type;
@end


@interface TRTrainLayers : EGLayers
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGLayer* levelLayer;
@property (nonatomic, readonly) EGLayer* menuLayer;
@property (nonatomic, readonly) EGLayer* pauseMenuLayer;

+ (id)trainLayersWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNSeq>)layers;
- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


