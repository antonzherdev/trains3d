#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRLevelSound;
@class TRLevel;
@class TRLevelFactory;
@class TRLevelView;
@class TRLevelMenuView;
@class TRLevelPauseMenuView;
@class EGGlobal;
@class EGContext;

@class TRSceneFactory;
@class TRTrainLayers;

@interface TRSceneFactory : NSObject
+ (id)sceneFactory;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
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


