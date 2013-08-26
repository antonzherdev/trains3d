#import "TRLevelFactory.h"

#import "CNRange.h"
#import "EGScene.h"
#import "EGLayer.h"
#import "EGMapIso.h"
#import "TRTrain.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelMenuView.h"
#import "TRLevelProcessor.h"
#import "TRLevelMenuProcessor.h"
#import "TRScore.h"
#import "TRRailroad.h"
@implementation TRLevelFactory
static TRScoreRules* _scoreRules;
static id<CNSeq> _rules;

+ (id)levelFactory {
    return [[TRLevelFactory alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _scoreRules = [TRScoreRules scoreRulesWithInitialScore:100000 railCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return ((NSInteger)([train.cars count] * 2000));
    } destructionFine:^NSInteger(TRTrain* train) {
        return ((NSInteger)([train.cars count] * 3000));
    } delayPeriod:10.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return i * 1000;
    } repairCost:2000];
    _rules = (@[[TRLevelRules levelRulesWithMapSize:EGSizeIMake(5, 3) scoreRules:_scoreRules repairerSpeed:30 events:(@[tuple(@5.0, [TRLevelFactory trainCars:intTo(2, 5) speed:[intTo(30, 60) setStep:10]]), tuple(@15.0, [TRLevelFactory createNewCity])])]]);
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
    return [TRLevel levelWithRules:((TRLevelRules*)([_rules applyIndex:number - 1]))];
}

+ (TRLevel*)levelWithMapSize:(EGSizeI)mapSize {
    return [TRLevel levelWithRules:[TRLevelRules levelRulesWithMapSize:mapSize scoreRules:_scoreRules repairerSpeed:30 events:(@[])]];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRLevelFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
}

+ (TRScore*)score {
    return [TRScore scoreWithRules:_scoreRules];
}

+ (TRRailroad*)railroadWithMapSize:(EGSizeI)mapSize {
    return [TRRailroad railroadWithMap:[EGMapSso mapSsoWithSize:mapSize] score:[TRLevelFactory score]];
}

+ (TRScoreRules*)scoreRules {
    return _scoreRules;
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


