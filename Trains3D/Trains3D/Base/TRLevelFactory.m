#import "TRLevelFactory.h"

#import "EGScene.h"
#import "EGLayer.h"
#import "TRTrain.h"
#import "TRLevel.h"
#import "TRLevelView.h"
#import "TRLevelProcessor.h"
#import "TRScore.h"
@implementation TRLevelFactory
static NSArray* _rules;

+ (id)levelFactory {
    return [[TRLevelFactory alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _rules = (@[[TRLevelRules levelRulesWithMapSize:EGSizeIMake(5, 3) scoreRules:[TRScoreRules scoreRulesWithInitialScore:100000 railCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
    return [train.cars count] * 2000;
} destructionFine:^NSInteger(TRTrain* train) {
    return [train.cars count] * 3000;
} delayPeriod:10 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
    return i * 1000;
} repairCost:2000]]]);
}

+ (EGScene*)sceneForLevel:(TRLevel*)level {
    return [EGScene sceneWithController:level layers:(@[[EGLayer layerWithView:[TRLevelView levelViewWithLevel:level] processor:[CNOption opt:[TRLevelProcessor levelProcessorWithLevel:level]]]])];
}

+ (TRLevel*)levelWithNumber:(NSUInteger)number {
    return [TRLevel levelWithRules:((TRLevelRules*)_rules[number - 1])];
}

+ (EGScene*)sceneForLevelWithNumber:(NSUInteger)number {
    return [TRLevelFactory sceneForLevel:[TRLevelFactory levelWithNumber:number]];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


