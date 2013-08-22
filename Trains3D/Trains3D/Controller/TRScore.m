#import "TRScore.h"

#import "TRTrain.h"
@implementation TRScoreRules{
    NSInteger _initialScore;
    NSInteger _railCost;
    NSInteger(^_arrivedPrize)(TRTrain*);
    NSInteger(^_destructionFine)(TRTrain*);
    CGFloat _delayPeriod;
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

+ (id)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
    return [[TRScoreRules alloc] initWithInitialScore:initialScore railCost:railCost arrivedPrize:arrivedPrize destructionFine:destructionFine delayPeriod:delayPeriod delayFine:delayFine repairCost:repairCost];
}

- (id)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRScoreRules* o = ((TRScoreRules*)(other));
    return self.initialScore == o.initialScore && self.railCost == o.railCost && [self.arrivedPrize isEqual:o.arrivedPrize] && [self.destructionFine isEqual:o.destructionFine] && eqf(self.delayPeriod, o.delayPeriod) && [self.delayFine isEqual:o.delayFine] && self.repairCost == o.repairCost;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.initialScore;
    hash = hash * 31 + self.railCost;
    hash = hash * 31 + [self.arrivedPrize hash];
    hash = hash * 31 + [self.destructionFine hash];
    hash = hash * 31 + floatHash(self.delayPeriod);
    hash = hash * 31 + [self.delayFine hash];
    hash = hash * 31 + self.repairCost;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"initialScore=%li", self.initialScore];
    [description appendFormat:@", railCost=%li", self.railCost];
    [description appendFormat:@", delayPeriod=%f", self.delayPeriod];
    [description appendFormat:@", repairCost=%li", self.repairCost];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRScore{
    TRScoreRules* _rules;
    NSInteger __score;
    id<CNList> _trains;
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
    [self removeTrain:train];
}

- (void)destroyedTrain:(TRTrain*)train {
    __score -= _rules.destructionFine(train);
    [self removeTrain:train];
}

- (void)removeTrain:(TRTrain*)train {
    _trains = [[[_trains chain] filter:^BOOL(TRTrainScore* _) {
        return !([_.train isEqual:train]);
    }] toArray];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_trains forEach:^void(TRTrainScore* train) {
        [train updateWithDelta:delta];
        if([train needFineWithDelayPeriod:_rules.delayPeriod]) __score -= [train fineWithRule:_rules.delayFine];
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRScore* o = ((TRScore*)(other));
    return [self.rules isEqual:o.rules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainScore{
    TRTrain* _train;
    CGFloat _delayTime;
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

- (void)updateWithDelta:(CGFloat)delta {
    _delayTime += delta;
}

- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod {
    return _delayTime >= delayPeriod;
}

- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule {
    _fineCount++;
    _delayTime = ((CGFloat)(0));
    return rule(_train, _fineCount);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainScore* o = ((TRTrainScore*)(other));
    return [self.train isEqual:o.train];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


