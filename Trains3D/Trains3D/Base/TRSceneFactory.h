#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRLevelSound;
@class TRLevel;
@class TRLevels;
@class TRLevelView;
@class TRLevelMenuView;
@class TRLevelPauseMenuView;

@class TRSceneFactory;
@class TRTrainLayers;

@interface TRSceneFactory : NSObject
+ (instancetype)sceneFactory;
- (instancetype)init;
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

+ (instancetype)trainLayersWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (id<CNImSeq>)layers;
- (id<CNImSeq>)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


