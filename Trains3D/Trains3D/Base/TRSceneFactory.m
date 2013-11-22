#import "TRSceneFactory.h"

#import "TRLevelSound.h"
#import "TRLevel.h"
#import "TRLevelFactory.h"
#import "TRLevelView.h"
#import "TRLevelMenuView.h"
#import "TRLevelPauseMenuView.h"
#import "EGContext.h"
@implementation TRSceneFactory
static ODClassType* _TRSceneFactory_type;

+ (id)sceneFactory {
    return [[TRSceneFactory alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSceneFactory_type = [ODClassType classTypeWithCls:[TRSceneFactory class]];
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithBackgroundColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) controller:level layers:[TRTrainLayers trainLayersWithLevel:level] soundPlayer:[CNOption applyValue:[TRLevelSound levelSoundWithLevel:level]]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRSceneFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainLayers{
    TRLevel* _level;
    EGLayer* _levelLayer;
    EGLayer* _menuLayer;
    EGLayer* _pauseMenuLayer;
}
static ODClassType* _TRTrainLayers_type;
@synthesize level = _level;
@synthesize levelLayer = _levelLayer;
@synthesize menuLayer = _menuLayer;
@synthesize pauseMenuLayer = _pauseMenuLayer;

+ (id)trainLayersWithLevel:(TRLevel*)level {
    return [[TRTrainLayers alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
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
    _TRTrainLayers_type = [ODClassType classTypeWithCls:[TRTrainLayers class]];
}

- (id<CNSeq>)layers {
    return (@[_levelLayer, _menuLayer, _pauseMenuLayer]);
}

- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_levelLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y))), tuple(_menuLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, viewSize.y - 46 * EGGlobal.context.scale, viewSize.x, ((float)(46 * EGGlobal.context.scale))))), tuple(_pauseMenuLayer, wrap(GERect, GERectMake(GEVec2Make(0.0, 0.0), viewSize)))]);
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainLayers* o = ((TRTrainLayers*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


