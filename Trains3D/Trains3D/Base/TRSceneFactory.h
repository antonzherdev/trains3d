#import "objd.h"
#import "PGVec.h"
#import "PGScene.h"
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
+ (PGScene*)sceneForLevel:(TRLevel*)level;
+ (PGScene*)sceneForLevelWithNumber:(NSUInteger)number;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainLayers : PGLayers {
@public
    PGLayer* _levelLayer;
    PGLayer* _menuLayer;
    PGLayer* _pauseMenuLayer;
}
@property (nonatomic, readonly) PGLayer* levelLayer;
@property (nonatomic, readonly) PGLayer* menuLayer;
@property (nonatomic, readonly) PGLayer* pauseMenuLayer;

+ (instancetype)trainLayersWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSArray*)layers;
- (NSArray*)viewportsWithViewSize:(PGVec2)viewSize;
- (NSString*)description;
+ (CNClassType*)type;
@end


