#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRLevelMenuView;
@class TRLevelSound;
@class TRLevel;
@class EGDirector;
@class TRLevelFactory;
@class TRLevelView;
@class TRLevelPauseMenuView;

@class TRSceneFactory;
@class TRTrainLayers;

@interface TRSceneFactory : NSObject
+ (id)sceneFactory;
- (id)init;
- (ODClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (void)restartLevel;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
+ (void)chooseLevel;
+ (void)nextLevel;
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
- (CGFloat)scaleWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


