#import "TRSceneFactory.h"

#import "TRLevelSound.h"
#import "TRLevel.h"
#import "TRLevels.h"
#import "TRLevelView.h"
#import "TRLevelMenuView.h"
#import "TRLevelPauseMenuView.h"
@implementation TRSceneFactory
static CNClassType* _TRSceneFactory_type;

+ (instancetype)sceneFactory {
    return [[TRSceneFactory alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSceneFactory class]) _TRSceneFactory_type = [CNClassType classTypeWithCls:[TRSceneFactory class]];
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithBackgroundColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) controller:level layers:[TRTrainLayers trainLayersWithLevel:level] soundPlayer:[TRLevelSound levelSoundWithLevel:level]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRSceneFactory sceneForLevel:[TRLevels levelWithNumber:number]];
}

- (NSString*)description {
    return @"SceneFactory";
}

- (CNClassType*)type {
    return [TRSceneFactory type];
}

+ (CNClassType*)type {
    return _TRSceneFactory_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainLayers
static CNClassType* _TRTrainLayers_type;
@synthesize levelLayer = _levelLayer;
@synthesize menuLayer = _menuLayer;
@synthesize pauseMenuLayer = _pauseMenuLayer;

+ (instancetype)trainLayersWithLevel:(TRLevel*)level {
    return [[TRTrainLayers alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _levelLayer = [EGLayer applyView:[TRLevelView levelViewWithLevel:level]];
        _menuLayer = [EGLayer applyView:[TRLevelMenuView levelMenuViewWithLevel:level]];
        _pauseMenuLayer = [EGLayer applyView:[TRLevelPauseMenuView levelPauseMenuViewWithLevel:level]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainLayers class]) _TRTrainLayers_type = [CNClassType classTypeWithCls:[TRTrainLayers class]];
}

- (NSArray*)layers {
    return (@[_levelLayer, _menuLayer, _pauseMenuLayer]);
}

- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_levelLayer, (wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y))))), tuple(_menuLayer, (wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y))))), tuple(_pauseMenuLayer, (wrap(GERect, (GERectMake((GEVec2Make(0.0, 0.0)), viewSize)))))]);
}

- (NSString*)description {
    return @"TrainLayers";
}

- (CNClassType*)type {
    return [TRTrainLayers type];
}

+ (CNClassType*)type {
    return _TRTrainLayers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

