#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRScoreRules;
@class TRTrain;
@class TRLevelRules;
@class TRLevel;
@class TRTrainType;
@class TRCarType;
@class TRTrainGenerator;
@class TRScore;
@class TRRailroad;
@class EGMapSso;
@class TRLevelView;
@class TRLevelProcessor;
@class TRLevelMenuView;
@class TRLevelMenuProcessor;

@class TRLevelFactory;
@class TRTrainLayers;

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


@interface TRTrainLayers : EGLayers
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGLayer* levelLayer;
@property (nonatomic, readonly) EGLayer* menuLayer;

+ (id)trainLayersWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNSeq>)layers;
- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


