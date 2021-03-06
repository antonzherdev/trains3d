#import "TRScore.h"

#import "TRTrain.h"
#import "TRLevel.h"
#import "CNReact.h"
#import "CNFuture.h"
#import "TRStrings.h"
#import "CNChain.h"
@implementation TRScoreRules
static CNClassType* _TRScoreRules_type;
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
    if(self == [TRScoreRules class]) _TRScoreRules_type = [CNClassType classTypeWithCls:[TRScoreRules class]];
}

+ (TRScoreRules*)aDefaultInitialScore:(NSInteger)initialScore {
    return [TRScoreRules scoreRulesWithInitialScore:initialScore railCost:1000 railRemoveCost:1000 arrivedPrize:^NSInteger(TRTrain* train) {
        return 1000 + [train carsCount] * 500;
    } destructionFine:^NSInteger(TRTrain* train) {
        return 5000 + [train carsCount] * 2500;
    } delayPeriod:60.0 delayFine:^NSInteger(TRTrain* train, NSInteger i) {
        return 1000 + i * 1000;
    } repairCost:1000];
}

+ (TRScoreRules*)aDefault {
    return [TRScoreRules aDefaultInitialScore:10000];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ScoreRules(%ld, %ld, %ld, %f, %ld)", (long)_initialScore, (long)_railCost, (long)_railRemoveCost, _delayPeriod, (long)_repairCost];
}

- (CNClassType*)type {
    return [TRScoreRules type];
}

+ (CNClassType*)type {
    return _TRScoreRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRScoreState
static CNClassType* _TRScoreState_type;
@synthesize money = _money;
@synthesize trains = _trains;

+ (instancetype)scoreStateWithMoney:(NSInteger)money trains:(NSArray*)trains {
    return [[TRScoreState alloc] initWithMoney:money trains:trains];
}

- (instancetype)initWithMoney:(NSInteger)money trains:(NSArray*)trains {
    self = [super init];
    if(self) {
        _money = money;
        _trains = trains;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRScoreState class]) _TRScoreState_type = [CNClassType classTypeWithCls:[TRScoreState class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ScoreState(%ld, %@)", (long)_money, _trains];
}

- (CNClassType*)type {
    return [TRScoreState type];
}

+ (CNClassType*)type {
    return _TRScoreState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRScore
static CNClassType* _TRScore_type;
@synthesize rules = _rules;
@synthesize notifications = _notifications;
@synthesize money = _money;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    return [[TRScore alloc] initWithRules:rules notifications:notifications];
}

- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications {
    self = [super init];
    if(self) {
        _rules = rules;
        _notifications = notifications;
        _money = [CNVar applyInitial:numi(rules->_initialScore)];
        __trains = ((NSArray*)((@[])));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRScore class]) _TRScore_type = [CNClassType classTypeWithCls:[TRScore class]];
}

- (CNFuture*)railBuilt {
    return [self promptF:^id() {
        [_money updateF:^id(id _) {
            return numi(unumi(_) - _rules->_railCost);
        }];
        [_notifications notifyNotification:[[TRStr Loc] railBuiltCost:_rules->_railCost]];
        return nil;
    }];
}

- (CNFuture*)state {
    return [self promptF:^TRScoreState*() {
        return [TRScoreState scoreStateWithMoney:unumi([_money value]) trains:__trains];
    }];
}

- (CNFuture*)restoreState:(TRScoreState*)state {
    return [self promptF:^id() {
        [_money setValue:numi(state->_money)];
        __trains = state->_trains;
        return nil;
    }];
}

- (CNFuture*)railRemoved {
    return [self promptF:^id() {
        [_money updateF:^id(id _) {
            return numi(unumi(_) - _rules->_railCost);
        }];
        [_notifications notifyNotification:[[TRStr Loc] railRemovedCost:_rules->_railRemoveCost]];
        return nil;
    }];
}

- (CNFuture*)runTrain:(TRTrain*)train {
    return [self promptF:^id() {
        __trains = [__trains addItem:[TRTrainScore applyTrain:train]];
        return nil;
    }];
}

- (CNFuture*)arrivedTrain:(TRTrain*)train {
    return [self promptF:^CNFuture*() {
        NSInteger prize = _rules->_arrivedPrize(train);
        [_money updateF:^id(id _) {
            return numi(unumi(_) + prize);
        }];
        [_notifications notifyNotification:[[TRStr Loc] trainArrivedTrain:train cost:prize]];
        return [self removeTrain:train];
    }];
}

- (CNFuture*)destroyedTrain:(TRTrain*)train {
    return [self promptF:^CNFuture*() {
        NSInteger fine = _rules->_destructionFine(train);
        [_money updateF:^id(id _) {
            return numi(unumi(_) - fine);
        }];
        [_notifications notifyNotification:[[TRStr Loc] trainDestroyedCost:fine]];
        return [self removeTrain:train];
    }];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    return [self promptF:^id() {
        __trains = [[[__trains chain] filterWhen:^BOOL(TRTrainScore* _) {
            return !([((TRTrainScore*)(_))->_train isEqual:train]);
        }] toArray];
        return nil;
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
        __trains = [[[__trains chain] mapF:^TRTrainScore*(TRTrainScore* ts) {
            TRTrainScore* t = [((TRTrainScore*)(ts)) updateWithDelta:delta];
            if([t needFineWithDelayPeriod:_rules->_delayPeriod]) {
                NSInteger fine = _rules->_delayFine(t->_train, ((NSInteger)(t->_fineTime)));
                [_money updateF:^id(id _) {
                    return numi(unumi(_) - fine);
                }];
                [_notifications notifyNotification:[[TRStr Loc] trainDelayedFineTrain:((TRTrainScore*)(ts))->_train cost:fine]];
                return [t fine];
            } else {
                return t;
            }
        }] toArray];
        return nil;
    }];
}

- (void)repairerCalled {
}

- (CNFuture*)damageFixed {
    return [self promptF:^id() {
        if(_rules->_repairCost > 0) {
            [_money updateF:^id(id _) {
                return numi(unumi(_) - _rules->_repairCost);
            }];
            [_notifications notifyNotification:[[TRStr Loc] damageFixedPaymentCost:_rules->_repairCost]];
        }
        return nil;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Score(%@, %@)", _rules, _notifications];
}

- (CNClassType*)type {
    return [TRScore type];
}

+ (CNClassType*)type {
    return _TRScore_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainScore
static CNClassType* _TRTrainScore_type;
@synthesize train = _train;
@synthesize delayTime = _delayTime;
@synthesize fineTime = _fineTime;

+ (instancetype)trainScoreWithTrain:(TRTrain*)train delayTime:(CGFloat)delayTime fineTime:(NSUInteger)fineTime {
    return [[TRTrainScore alloc] initWithTrain:train delayTime:delayTime fineTime:fineTime];
}

- (instancetype)initWithTrain:(TRTrain*)train delayTime:(CGFloat)delayTime fineTime:(NSUInteger)fineTime {
    self = [super init];
    if(self) {
        _train = train;
        _delayTime = delayTime;
        _fineTime = fineTime;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainScore class]) _TRTrainScore_type = [CNClassType classTypeWithCls:[TRTrainScore class]];
}

- (TRTrainScore*)updateWithDelta:(CGFloat)delta {
    return [TRTrainScore trainScoreWithTrain:_train delayTime:_delayTime + (delta * _train->_speed) / 30.0 fineTime:_fineTime];
}

- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod {
    return _delayTime >= delayPeriod;
}

- (TRTrainScore*)fine {
    return [TRTrainScore trainScoreWithTrain:_train delayTime:0.0 fineTime:_fineTime + 1];
}

+ (TRTrainScore*)applyTrain:(TRTrain*)train delayTime:(CGFloat)delayTime {
    return [TRTrainScore trainScoreWithTrain:train delayTime:delayTime fineTime:0];
}

+ (TRTrainScore*)applyTrain:(TRTrain*)train fineTime:(NSUInteger)fineTime {
    return [TRTrainScore trainScoreWithTrain:train delayTime:0.0 fineTime:fineTime];
}

+ (TRTrainScore*)applyTrain:(TRTrain*)train {
    return [TRTrainScore trainScoreWithTrain:train delayTime:0.0 fineTime:0];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainScore(%@, %f, %lu)", _train, _delayTime, (unsigned long)_fineTime];
}

- (CNClassType*)type {
    return [TRTrainScore type];
}

+ (CNClassType*)type {
    return _TRTrainScore_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

