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


@interface TRTrainLayers : EGLayers {
@private
    TRLevel* _level;
    EGLayer* _levelLayer;
    EGLayer* _menuLayer;
    EGLayer* _pauseMenuLayer;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGLayer* levelLayer;
@property (nonatomic, readonly) EGLayer* menuLayer;
@property (nonatomic, readonly) EGLayer* pauseMenuLayer;

+ (instancetype)trainLayersWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (NSArray*)layers;
- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize;
+ (ODClassType*)type;
@end


