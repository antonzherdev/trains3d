#import "TRScore.h"

#import "TRNotification.h"
#import "TRStrings.h"
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
static ODClassType* _TRScoreRules_type;
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

+ (void)initialize {
    [super initialize];
    _TRScoreRules_type = [ODClassType classTypeWithCls:[TRScoreRules class]];
}

- (ODClassType*)type {
    return [TRScoreRules type];
}

+ (ODClassType*)type {
    return _TRScoreRules_type;
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
    [description appendFormat:@"initialScore=%ld", (long)self.initialScore];
    [description appendFormat:@", railCost=%ld", (long)self.railCost];
    [description appendFormat:@", delayPeriod=%f", self.delayPeriod];
    [description appendFormat:@", repairCost=%ld", (long)self.repairCost];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRScore{
    TRScoreRules* _rules;
    TRNotifications* _notifications;
    NSInteger __score;
    id<CNSeq> _trains;
}
static ODClassType* _TRScore_type;
@synthesize rules = _rules;
@synthesize notifications = _notifications;

+ (id)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    return [[TRScore alloc] initWithRules:rules notifications:notifications];
}

- (id)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    self = [super init];
    if(self) {
        _rules = rules;
        _notifications = notifications;
        __score = _rules.initialScore;
        _trains = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRScore_type = [ODClassType classTypeWithCls:[TRScore class]];
}

- (NSInteger)score {
    return __score;
}

- (void)railBuilt {
    __score -= _rules.railCost;
    [_notifications notifyNotification:[TRStr.Loc railBuiltCost:_rules.railCost]];
}

- (void)runTrain:(TRTrain*)train {
    _trains = [_trains addItem:[TRTrainScore trainScoreWithTrain:train]];
}

- (void)arrivedTrain:(TRTrain*)train {
    NSInteger prize = _rules.arrivedPrize(train);
    __score += prize;
    [_notifications notifyNotification:[TRStr.Loc trainArrivedCost:prize]];
    [self removeTrain:train];
}

- (void)destroyedTrain:(TRTrain*)train {
    NSInteger fine = _rules.destructionFine(train);
    __score -= fine;
    [_notifications notifyNotification:[TRStr.Loc trainDestroyedCost:fine]];
    [self removeTrain:train];
}

- (void)removeTrain:(TRTrain*)train {
    _trains = [[[_trains chain] filter:^BOOL(TRTrainScore* _) {
        return !([((TRTrainScore*)(_)).train isEqual:train]);
    }] toArray];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_trains forEach:^void(TRTrainScore* train) {
        [((TRTrainScore*)(train)) updateWithDelta:delta];
        if([((TRTrainScore*)(train)) needFineWithDelayPeriod:_rules.delayPeriod]) {
            NSInteger fine = [((TRTrainScore*)(train)) fineWithRule:_rules.delayFine];
            __score -= fine;
            [_notifications notifyNotification:[TRStr.Loc trainDelayedFineCost:fine]];
        }
    }];
}

- (ODClassType*)type {
    return [TRScore type];
}

+ (ODClassType*)type {
    return _TRScore_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRScore* o = ((TRScore*)(other));
    return [self.rules isEqual:o.rules] && self.notifications == o.notifications;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rules hash];
    hash = hash * 31 + [self.notifications hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendFormat:@", notifications=%@", self.notifications];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainScore{
    TRTrain* _train;
    CGFloat _delayTime;
    NSInteger _fineCount;
}
static ODClassType* _TRTrainScore_type;
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

+ (void)initialize {
    [super initialize];
    _TRTrainScore_type = [ODClassType classTypeWithCls:[TRTrainScore class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    _delayTime += delta;
}

- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod {
    return _delayTime >= delayPeriod;
}

- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule {
    _fineCount++;
    _delayTime = 0.0;
    return rule(_train, _fineCount);
}

- (ODClassType*)type {
    return [TRTrainScore type];
}

+ (ODClassType*)type {
    return _TRTrainScore_type;
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


