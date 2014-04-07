#import "TRSceneFactory.h"

#import "TRLevelSound.h"
#import "TRLevel.h"
#import "TRLevels.h"
#import "TRLevelView.h"
#import "TRLevelMenuView.h"
#import "TRLevelPauseMenuView.h"
@implementation TRSceneFactory
static ODClassType* _TRSceneFactory_type;

+ (instancetype)sceneFactory {
    return [[TRSceneFactory alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSceneFactory class]) _TRSceneFactory_type = [ODClassType classTypeWithCls:[TRSceneFactory class]];
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithBackgroundColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) controller:level layers:[TRTrainLayers trainLayersWithLevel:level] soundPlayer:[TRLevelSound levelSoundWithLevel:level]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRSceneFactory sceneForLevel:[TRLevels levelWithNumber:number]];
}

- (ODClassType*)type {
    return [TRSceneFactory type];
}

+ (ODClassType*)type {
    return _TRSceneFactory_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainLayers
static ODClassType* _TRTrainLayers_type;
@synthesize level = _level;
@synthesize levelLayer = _levelLayer;
@synthesize menuLayer = _menuLayer;
@synthesize pauseMenuLayer = _pauseMenuLayer;

+ (instancetype)trainLayersWithLevel:(TRLevel*)level {
    return [[TRTrainLayers alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _levelLayer = [EGLayer applyView:[TRLevelView levelViewWithLevel:_level]];
        _menuLayer = [EGLayer applyView:[TRLevelMenuView levelMenuViewWithLevel:_level]];
        _pauseMenuLayer = [EGLayer applyView:[TRLevelPauseMenuView levelPauseMenuViewWithLevel:_level]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainLayers class]) _TRTrainLayers_type = [ODClassType classTypeWithCls:[TRTrainLayers class]];
}

- (NSArray*)layers {
    return (@[_levelLayer, _menuLayer, _pauseMenuLayer]);
}

- (NSArray*)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_levelLayer, (wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y))))), tuple(_menuLayer, (wrap(GERect, (geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y))))), tuple(_pauseMenuLayer, (wrap(GERect, (GERectMake((GEVec2Make(0.0, 0.0)), viewSize)))))]);
}

- (ODClassType*)type {
    return [TRTrainLayers type];
}

+ (ODClassType*)type {
    return _TRTrainLayers_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


