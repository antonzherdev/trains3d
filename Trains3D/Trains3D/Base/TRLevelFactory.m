#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTrain.h"
#import "TRLevel.h"
#import "TRCar.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "TRLevelMenuView.h"
#import "TRLevelMenuProcessor.h"
@implementation TRLevelFactory
static TRScoreRules* _TRLevelFactory_scoreRules;
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
    _TRLevelFactory_rules = (@[[TRLevelRules levelRulesWithMapSize:GEVec2iMake(5, 3) scoreRules:_TRLevelFactory_scoreRules repairerSpeed:30 events:(@[tuple(@1.0, [TRLevelFactory trainCars:intTo(2, 4) speed:[intTo(50, 60) setStep:10]]), tuple(@15.0, [TRLevelFactory createNewCity])])]]);
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithBackgroundColor:geVec4DivI(GEVec4Make(21.0, 40.0, 10.0, 255.0), 255) controller:level layers:[TRTrainLayers trainLayersWithLevel:level]];
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
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:mapSize scoreRules:_TRLevelFactory_scoreRules repairerSpeed:30 events:(@[])]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRLevelFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules];
}

+ (TRRailroad*)railroadWithMapSize:(GEVec2i)mapSize {
    return [TRRailroad railroadWithMap:[EGMapSso mapSsoWithSize:mapSize] score:[TRLevelFactory score]];
}

- (ODClassType*)type {
    return [TRLevelFactory type];
}

+ (TRScoreRules*)scoreRules {
    return _TRLevelFactory_scoreRules;
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
}
static ODClassType* _TRTrainLayers_type;
@synthesize level = _level;
@synthesize levelLayer = _levelLayer;
@synthesize menuLayer = _menuLayer;

+ (id)trainLayersWithLevel:(TRLevel*)level {
    return [[TRTrainLayers alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _levelLayer = [EGLayer layerWithView:[TRLevelView levelViewWithLevel:_level] processor:[CNOption applyValue:[TRLevelProcessor levelProcessorWithLevel:_level]]];
        _menuLayer = [EGLayer layerWithView:[TRLevelMenuView levelMenuViewWithLevel:_level] processor:[CNOption applyValue:[TRLevelMenuProcessor levelMenuProcessorWithLevel:_level]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainLayers_type = [ODClassType classTypeWithCls:[TRTrainLayers class]];
}

- (id<CNSeq>)layers {
    return (@[_levelLayer, _menuLayer]);
}

- (id<CNSeq>)viewportsWithViewSize:(GEVec2)viewSize {
    return (@[tuple(_levelLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, 0.0, viewSize.x, viewSize.y - 46))), tuple(_menuLayer, wrap(GERect, geRectApplyXYWidthHeight(0.0, viewSize.y - 46, viewSize.x, 46.0)))]);
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


