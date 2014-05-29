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
- (CNClassType*)type;
+ (EGScene*)sceneForLevel:(TRLevel*)level;
+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainLayers : EGLayers {
@protected
    EGLayer* _levelLayer;
    EGLayer* _menuLayer;
    EGLayer* _pauseMenuLayer;
}
@property (nonatomic, readonly) EGLayer* levelLayer;
@property (nonatomic, readonly) EGLayer* menuLayer;
@property (nonatomic, readonly) EGLayer* pauseMenuLayer;

+ (instancetype)trainLayersWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)layers;
- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


