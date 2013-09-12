#import "TRLevelFactory.h"

#import "TRScore.h"
#import "TRTrain.h"
#import "TRLevel.h"
#import "EGScene.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "EGLayer.h"
#import "TRLevelMenuView.h"
#import "TRLevelMenuProcessor.h"
#import "TRRailroad.h"
#import "EGMapIso.h"
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
    _TRLevelFactory_rules = (@[[TRLevelRules levelRulesWithMapSize:EGVec2IMake(5, 3) scoreRules:_TRLevelFactory_scoreRules repairerSpeed:30 events:(@[tuple(@1.0, [TRLevelFactory trainCars:intTo(2, 5) speed:[intTo(30, 60) setStep:10]]), tuple(@10.0, [TRLevelFactory trainCars:intTo(1, 5) speed:[intTo(30, 60) setStep:10]]), tuple(@15.0, [TRLevelFactory createNewCity])])]]);
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithController:level layers:(@[[EGLayer layerWithView:[TRLevelView levelViewWithLevel:level] processor:[CNOption opt:[TRLevelProcessor levelProcessorWithLevel:level]]], [EGLayer layerWithView:[TRLevelMenuView levelMenuViewWithLevel:level] processor:[CNOption opt:[TRLevelMenuProcessor levelMenuProcessorWithLevel:level]]]])];
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

+ (TRLevel*)levelWithMapSize:(EGVec2I)mapSize {
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:mapSize scoreRules:_TRLevelFactory_scoreRules repairerSpeed:30 events:(@[])]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRLevelFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_TRLevelFactory_scoreRules];
}

+ (TRRailroad*)railroadWithMapSize:(EGVec2I)mapSize {
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


