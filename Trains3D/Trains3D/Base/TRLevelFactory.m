#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTrain.h"
#import "TRTree.h"
#import "TRLevel.h"
#import "EGContext.h"
#import "EGDirector.h"
#import "TRCar.h"
#import "TRNotification.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "TRLevelMenuView.h"
#import "TRLevelPauseMenuView.h"
@implementation TRLevelFactory
static TRScoreRules* _TRLevelFactory_scoreRules;
static TRForestRules* _TRLevelFactory_forestRules;
static id<CNSeq> _TRLevelFactory_rules;
static ODClassType* _TRLevelFactory_type;

+ (id)levelFactory {
    return [[TRLevelFactory alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRLevelFactory_type = [ODClassType classTypeWithCls:[TRLevelFactory class]];
    _TRLevelFactory_scoreRules = [TRScoreRules scoreRulesWithInitialScore:100000 railCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 2000));
    } destructionFine:^NSInteger(TRTrain* train) {
        return ((NSInteger)([[train cars] count] * 3000));
    } delayPeriod:10.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return i * 1000;
    } repairCost:2000];
    _TRLevelFactory_forestRules = [TRForestRules forestRulesWithTypes:[TRTreeType values] thickness:1.0];
    _TRLevelFactory_rules = (@[[TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) scoreRules:_TRLevelFactory_scoreRules forestRules:[TRForestRules forestRulesWithTypes:(@[TRTreeType.pine]) thickness:2.0] repairerSpeed:30 events:(@[tuple(@1.0, [TRLevelFactory trainCars:intTo(2, 4) speed:[intTo(50, 60) setStep:10]]), tuple(@15.0, [TRLevelFactory createNewCity])])]]);
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithBackgroundColor:geVec4DivI(GEVec4Make(215.0, 230.0, 195.0, 255.0), 255) controller:level layers:[TRTrainLayers trainLayersWithLevel:level]];
}

+ (void)restartLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:[EGGlobal director].scene.controller] forEach:^void(TRLevel* level) {
        [EGGlobal director].scene = [TRLevelFactory sceneForLevel:[TRLevel levelWithRules:level.rules]];
    }];
}

+ (void(^)(TRLevel*))trainCars:(CNRange*)cars speed:(CNRange*)speed {
    return ^void(TRLevel* level) {
        [level runTrainWithGenerator:[TRTrainGenerator trainGeneratorWithTrainType:TRTrainType.simple carsCount:cars speed:speed carTypes:(@[TRCarType.car, TRCarType.engine])]];
    };
}

+ (void(^)(TRLevel*))createNewCity {
    return ^void(TRLevel* level) {
        [level createNewCity];
    };
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    return [TRLevel levelWithRules:((TRLevelRules*)([_TRLevelFactory_rules applyIndex:number - 1]))];
}

+ (TRLevel*)levelWithMapSize:(GEVec2i)mapSize {
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:mapSize scoreRules:_TRLevelFactory_scoreRules forestRules:_TRLevelFactory_forestRules repairerSpeed:30 events:(@[])]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRLevelFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules notifications:[TRNotifications notifications]];
}

+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize {
    EGMapSso* map = [EGMapSso mapSsoWithSize:mapSize];
    return [TRRailroad railroadWithMap:map score:[TRLevelFactory score] forest:[TRForest forestWithMap:map rules:_TRLevelFactory_forestRules]];
}

- (ODClassType*)type {
    return [TRLevelFactory type];
}

+ (TRScoreRules*)scoreRules {
    return _TRLevelFactory_scoreRules;
}

+ (TRForestRules*)forestRules {
    return _TRLevelFactory_forestRules;
}

+ (ODClassType*)type {
    return _TRLevelFactory_type;
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
        _levelLayer = [EGLayer layerWithView:[TRLevelView levelViewWithLevel:_level] processor:[CNOption applyValue:[TRLevelProcessor levelProcessorWithLevel:_level]]];
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


