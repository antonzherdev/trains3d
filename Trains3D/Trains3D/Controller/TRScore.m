#import "TRScore.h"

#import "TRLevel.h"
#import "ATReact.h"
#import "TRStrings.h"
#import "TRTrain.h"
@implementation TRScoreRules
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


@implementation TRScore
static ODClassType* _TRScore_type;
@synthesize rules = _rules;
@synthesize notifications = _notifications;
@synthesize _trains = __trains;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    return [[TRScore alloc] initWithRules:rules notifications:notifications];
}

- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    self = [super init];
    if(self) {
        _rules = rules;
        _notifications = notifications;
        __money = [ATVar applyInitial:numi(_rules.initialScore)];
        __trains = (@[]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRScore class]) _TRScore_type = [ODClassType classTypeWithCls:[TRScore class]];
}

- (ATReact*)money {
    return __money;
}

- (CNFuture*)railBuilt {
    return [self promptF:^id() {
        [__money updateF:^id(id _) {
            return numi(unumi(_) - _rules.railCost);
        }];
        [_notifications notifyNotification:[TRStr.Loc railBuiltCost:_rules.railCost]];
        return nil;
    }];
}

- (CNFuture*)railRemoved {
    return [self promptF:^id() {
        [__money updateF:^id(id _) {
            return numi(unumi(_) - _rules.railCost);
        }];
        [_notifications notifyNotification:[TRStr.Loc railRemovedCost:_rules.railRemoveCost]];
        return nil;
    }];
}

- (CNFuture*)runTrain:(TRTrain*)train {
    return [self promptF:^id() {
        __trains = [__trains addItem:[TRTrainScore trainScoreWithTrain:train]];
        return nil;
    }];
}

- (CNFuture*)arrivedTrain:(TRTrain*)train {
    return [self promptF:^CNFuture*() {
        NSInteger prize = _rules.arrivedPrize(train);
        [__money updateF:^id(id _) {
            return numi(unumi(_) + prize);
        }];
        [_notifications notifyNotification:[TRStr.Loc trainArrivedTrain:train cost:prize]];
        return [self removeTrain:train];
    }];
}

- (CNFuture*)destroyedTrain:(TRTrain*)train {
    return [self promptF:^CNFuture*() {
        NSInteger fine = _rules.destructionFine(train);
        [__money updateF:^id(id _) {
            return numi(unumi(_) - fine);
        }];
        [_notifications notifyNotification:[TRStr.Loc trainDestroyedCost:fine]];
        return [self removeTrain:train];
    }];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    return [self promptF:^id() {
        __trains = [[[__trains chain] filter:^BOOL(TRTrainScore* _) {
            return !([((TRTrainScore*)(_)).train isEqual:train]);
        }] toArray];
        return nil;
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        [__trains forEach:^void(TRTrainScore* ts) {
            [((TRTrainScore*)(ts)) updateWithDelta:delta];
            if([((TRTrainScore*)(ts)) needFineWithDelayPeriod:_rules.delayPeriod]) {
                NSInteger fine = [((TRTrainScore*)(ts)) fineWithRule:_rules.delayFine];
                [__money updateF:^id(id _) {
                    return numi(unumi(_) - fine);
                }];
                [_notifications notifyNotification:[TRStr.Loc trainDelayedFineTrain:((TRTrainScore*)(ts)).train cost:fine]];
            }
        }];
        return nil;
    }];
}

- (void)repairerCalled {
}

- (CNFuture*)damageFixed {
    return [self promptF:^id() {
        if(_rules.repairCost > 0) {
            [__money updateF:^id(id _) {
                return numi(unumi(_) - _rules.repairCost);
            }];
            [_notifications notifyNotification:[TRStr.Loc damageFixedPaymentCost:_rules.repairCost]];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendFormat:@", notifications=%@", self.notifications];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainScore
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


