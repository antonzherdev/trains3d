#import "TRSceneFactory.h"

#import "TRLevelMenuView.h"
#import "TRLevelSound.h"
#import "TRLevel.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "TRLevelFactory.h"
#import "TRLevelView.h"
#import "TRLevelPauseMenuView.h"
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
    return [EGScene sceneWithBackgroundColor:TRLevelMenuView.backgroundColor controller:level layers:[TRTrainLayers trainLayersWithLevel:level] soundPlayer:[CNOption applyValue:[TRLevelSound levelSoundWithLevel:level]]];
}

+ (void)restartLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGGlobal director] scene] get])).controller] forEach:^void(TRLevel* level) {
        [[EGGlobal director] setScene:[TRSceneFactory sceneForLevel:[TRLevel levelWithNumber:((TRLevel*)(level)).number rules:((TRLevel*)(level)).rules]]];
    }];
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
    if(viewSize.y > 1279) return (@[tuple(_levelLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y - 92))), tuple(_menuLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, viewSize.y - 92, viewSize.x, 92.0))), tuple(_pauseMenuLayer, wrap(GERect, GERectMake(GEVec2Make(0.0, 0.0), viewSize)))]);
    else return (@[tuple(_levelLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y - 46))), tuple(_menuLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, viewSize.y - 46, viewSize.x, 46.0))), tuple(_pauseMenuLayer, wrap(GERect, GERectMake(GEVec2Make(0.0, 0.0), viewSize)))]);
}

- (CGFloat)scaleWithViewSize:(GEVec2)viewSize {
    if(viewSize.y > 1279) return 2.0;
    else return 1.0;
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


