#import "TRScore.h"

#import "TRTrain.h"
@implementation TRScoreRules{
    NSInteger _initialScore;
    NSInteger _railCost;
    NSInteger(^_arrivedPrize)(TRTrain*);
    NSInteger(^_destructionFine)(TRTrain*);
    double _delayPeriod;
    NSInteger(^_delayFine)(TRTrain*, NSInteger);
    NSInteger _repairCost;
}
@synthesize initialScore = _initialScore;
@synthesize railCost = _railCost;
@synthesize arrivedPrize = _arrivedPrize;
@synthesize destructionFine = _destructionFine;
@synthesize delayPeriod = _delayPeriod;
@synthesize delayFine = _delayFine;
@synthesize repairCost = _repairCost;

+ (id)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(double)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
    return [[TRScoreRules alloc] initWithInitialScore:initialScore railCost:railCost arrivedPrize:arrivedPrize destructionFine:destructionFine delayPeriod:delayPeriod delayFine:delayFine repairCost:repairCost];
}

- (id)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(double)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
    self = [super init];
    if(self) {
        _initialScore = initialScore;
        _railCost = railCost;
        _arrivedPrize = arrivedPrize;
        _destructionFine = destructionFine;
        _delayPeriod = delayPeriod;
        _delayFine = delayFine;
        _repairCost = repairCost;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRScore{
    TRScoreRules* _rules;
    NSInteger __score;
    NSArray* _trains;
}
@synthesize rules = _rules;

+ (id)scoreWithRules:(TRScoreRules*)rules {
    return [[TRScore alloc] initWithRules:rules];
}

- (id)initWithRules:(TRScoreRules*)rules {
    self = [super init];
    if(self) {
        _rules = rules;
        __score = _rules.initialScore;
        _trains = (@[]);
    }
    
    return self;
}

- (NSInteger)score {
    return __score;
}

- (void)railBuilt {
    __score -= _rules.railCost;
}

- (void)runTrain:(TRTrain*)train {
    _trains = [_trains arrayByAddingObject:[TRTrainScore trainScoreWithTrain:train]];
}

- (void)arrivedTrain:(TRTrain*)train {
    __score += _rules.arrivedPrize(train);
    _trains = [[_trains filter:^BOOL(TRTrainScore* _) {
        return !([_.train isEqual:train]);
    }] toArray];
}

- (void)destroyedTrain:(TRTrain*)train {
    __score -= _rules.destructionFine(train);
}

- (void)updateWithDelta:(double)delta {
    [_trains forEach:^void(TRTrainScore* train) {
        [train updateWithDelta:delta];
        if([train needFineWithDelayPeriod:_rules.delayPeriod]) __score -= [train fineWithRule:_rules.delayFine];
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRTrainScore{
    TRTrain* _train;
    double _delayTime;
    NSInteger _fineCount;
}
@synthesize train = _train;

+ (id)trainScoreWithTrain:(TRTrain*)train {
    return [[TRTrainScore alloc] initWithTrain:train];
}

- (id)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        _delayTime = 0.0;
        _fineCount = 0;
    }
    
    return self;
}

- (void)updateWithDelta:(double)delta {
    _delayTime += delta;
}

- (BOOL)needFineWithDelayPeriod:(double)delayPeriod {
    return _delayTime >= delayPeriod;
}

- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule {
    _fineCount++;
    _delayTime = 0;
    return rule(_train, _fineCount);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


