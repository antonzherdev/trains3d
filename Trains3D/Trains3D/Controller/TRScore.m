#import "TRScore.h"

#import "TRNotification.h"
#import "TRStrings.h"
#import "TRTrain.h"
@implementation TRScoreRules{
    NSInteger _initialScore;
    NSInteger _railCost;
    NSInteger _railRemoveCost;
    NSInteger(^_arrivedPrize)(TRTrain*);
    NSInteger(^_destructionFine)(TRTrain*);
    CGFloat _delayPeriod;
    NSInteger(^_delayFine)(TRTrain*, NSInteger);
    NSInteger _repairCost;
}
static ODClassType* _TRScoreRules_type;
@synthesize initialScore = _initialScore;
@synthesize railCost = _railCost;
@synthesize railRemoveCost = _railRemoveCost;
@synthesize arrivedPrize = _arrivedPrize;
@synthesize destructionFine = _destructionFine;
@synthesize delayPeriod = _delayPeriod;
@synthesize delayFine = _delayFine;
@synthesize repairCost = _repairCost;

+ (instancetype)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
    return [[TRScoreRules alloc] initWithInitialScore:initialScore railCost:railCost railRemoveCost:railRemoveCost arrivedPrize:arrivedPrize destructionFine:destructionFine delayPeriod:delayPeriod delayFine:delayFine repairCost:repairCost];
}

- (instancetype)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost {
    self = [super init];
    if(self) {
        _initialScore = initialScore;
        _railCost = railCost;
        _railRemoveCost = railRemoveCost;
        _arrivedPrize = [arrivedPrize copy];
        _destructionFine = [destructionFine copy];
        _delayPeriod = delayPeriod;
        _delayFine = [delayFine copy];
        _repairCost = repairCost;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRScoreRules class]) _TRScoreRules_type = [ODClassType classTypeWithCls:[TRScoreRules class]];
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
    return self.initialScore == o.initialScore && self.railCost == o.railCost && self.railRemoveCost == o.railRemoveCost && [self.arrivedPrize isEqual:o.arrivedPrize] && [self.destructionFine isEqual:o.destructionFine] && eqf(self.delayPeriod, o.delayPeriod) && [self.delayFine isEqual:o.delayFine] && self.repairCost == o.repairCost;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.initialScore;
    hash = hash * 31 + self.railCost;
    hash = hash * 31 + self.railRemoveCost;
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
    [description appendFormat:@", railRemoveCost=%ld", (long)self.railRemoveCost];
    [description appendFormat:@", delayPeriod=%f", self.delayPeriod];
    [description appendFormat:@", repairCost=%ld", (long)self.repairCost];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRScore{
    TRScoreRules* _rules;
    TRNotifications* _notifications;
    CNVar* _money;
    id<CNImSeq> __trains;
}
static ODClassType* _TRScore_type;
@synthesize rules = _rules;
@synthesize notifications = _notifications;
@synthesize money = _money;
@synthesize _trains = __trains;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    return [[TRScore alloc] initWithRules:rules notifications:notifications];
}

- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    self = [super init];
    if(self) {
        _rules = rules;
        _notifications = notifications;
        _money = [CNVar applyInitial:numi(_rules.initialScore)];
        __trains = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRScore class]) _TRScore_type = [ODClassType classTypeWithCls:[TRScore class]];
}

- (CNFuture*)railBuilt {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^id() {
        [_weakSelf.money updateF:^id(id _) {
            return numi(unumi(_) - _weakSelf.rules.railCost);
        }];
        [_weakSelf.notifications notifyNotification:[TRStr.Loc railBuiltCost:_weakSelf.rules.railCost]];
        return nil;
    }];
}

- (CNFuture*)railRemoved {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^id() {
        [_weakSelf.money updateF:^id(id _) {
            return numi(unumi(_) - _weakSelf.rules.railCost);
        }];
        [_weakSelf.notifications notifyNotification:[TRStr.Loc railRemovedCost:_weakSelf.rules.railRemoveCost]];
        return nil;
    }];
}

- (CNFuture*)runTrain:(TRTrain*)train {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^id() {
        _weakSelf._trains = [_weakSelf._trains addItem:[TRTrainScore trainScoreWithTrain:train]];
        return nil;
    }];
}

- (CNFuture*)arrivedTrain:(TRTrain*)train {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^CNFuture*() {
        NSInteger prize = _weakSelf.rules.arrivedPrize(train);
        [_weakSelf.money updateF:^id(id _) {
            return numi(unumi(_) + prize);
        }];
        [_weakSelf.notifications notifyNotification:[TRStr.Loc trainArrivedTrain:train cost:prize]];
        return [_weakSelf removeTrain:train];
    }];
}

- (CNFuture*)destroyedTrain:(TRTrain*)train {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^CNFuture*() {
        NSInteger fine = _weakSelf.rules.destructionFine(train);
        [_weakSelf.money updateF:^id(id _) {
            return numi(unumi(_) - fine);
        }];
        [_weakSelf.notifications notifyNotification:[TRStr.Loc trainDestroyedCost:fine]];
        return [_weakSelf removeTrain:train];
    }];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^id() {
        _weakSelf._trains = [[[_weakSelf._trains chain] filter:^BOOL(TRTrainScore* _) {
            return !([((TRTrainScore*)(_)).train isEqual:train]);
        }] toArray];
        return nil;
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    __weak TRScore* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf._trains forEach:^void(TRTrainScore* ts) {
            [((TRTrainScore*)(ts)) updateWithDelta:delta];
            if([((TRTrainScore*)(ts)) needFineWithDelayPeriod:_weakSelf.rules.delayPeriod]) {
                NSInteger fine = [((TRTrainScore*)(ts)) fineWithRule:_weakSelf.rules.delayFine];
                [_weakSelf.money updateF:^id(id _) {
                    return numi(unumi(_) - fine);
                }];
                [_weakSelf.notifications notifyNotification:[TRStr.Loc trainDelayedFineTrain:((TRTrainScore*)(ts)).train cost:fine]];
            }
        }];
        return nil;
    }];
}

- (void)repairerCalled {
}

- (CNFuture*)damageFixed {
    __weak TRScore* _weakSelf = self;
    return [self promptF:^id() {
        if(_weakSelf.rules.repairCost > 0) {
            [_weakSelf.money updateF:^id(id _) {
                return numi(unumi(_) - _weakSelf.rules.repairCost);
            }];
            [_weakSelf.notifications notifyNotification:[TRStr.Loc damageFixedPaymentCost:_weakSelf.rules.repairCost]];
        }
        return nil;
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
    CGFloat _delayK;
}
static ODClassType* _TRTrainScore_type;
@synthesize train = _train;

+ (instancetype)trainScoreWithTrain:(TRTrain*)train {
    return [[TRTrainScore alloc] initWithTrain:train];
}

- (instancetype)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        _delayTime = 0.0;
        _fineCount = 0;
        _delayK = _train.speed / 30.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainScore class]) _TRTrainScore_type = [ODClassType classTypeWithCls:[TRTrainScore class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    _delayTime += delta * _delayK;
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


