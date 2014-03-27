#import "objd.h"
#import "ATActor.h"
#import "EGScene.h"
@class TRNotifications;
@class ATVar;
@class TRStr;
@class TRStrings;
@class TRTrain;

@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@interface TRScoreRules : NSObject {
@private
    NSInteger _initialScore;
    NSInteger _railCost;
    NSInteger _railRemoveCost;
    NSInteger(^_arrivedPrize)(TRTrain*);
    NSInteger(^_destructionFine)(TRTrain*);
    CGFloat _delayPeriod;
    NSInteger(^_delayFine)(TRTrain*, NSInteger);
    NSInteger _repairCost;
}
@property (nonatomic, readonly) NSInteger initialScore;
@property (nonatomic, readonly) NSInteger railCost;
@property (nonatomic, readonly) NSInteger railRemoveCost;
@property (nonatomic, readonly) NSInteger(^arrivedPrize)(TRTrain*);
@property (nonatomic, readonly) NSInteger(^destructionFine)(TRTrain*);
@property (nonatomic, readonly) CGFloat delayPeriod;
@property (nonatomic, readonly) NSInteger(^delayFine)(TRTrain*, NSInteger);
@property (nonatomic, readonly) NSInteger repairCost;

+ (instancetype)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (instancetype)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRScore : ATActor {
@private
    TRScoreRules* _rules;
    TRNotifications* _notifications;
    ATVar* _money;
    id<CNImSeq> __trains;
}
@property (nonatomic, readonly) TRScoreRules* rules;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) ATVar* money;
@property (nonatomic) id<CNImSeq> _trains;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (ODClassType*)type;
- (CNFuture*)railBuilt;
- (CNFuture*)railRemoved;
- (CNFuture*)runTrain:(TRTrain*)train;
- (CNFuture*)arrivedTrain:(TRTrain*)train;
- (CNFuture*)destroyedTrain:(TRTrain*)train;
- (CNFuture*)removeTrain:(TRTrain*)train;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)repairerCalled;
- (CNFuture*)damageFixed;
+ (ODClassType*)type;
@end


@interface TRTrainScore : NSObject<EGUpdatable> {
@private
    TRTrain* _train;
    CGFloat _delayTime;
    NSInteger _fineCount;
    CGFloat _delayK;
}
@property (nonatomic, readonly) TRTrain* train;

+ (instancetype)trainScoreWithTrain:(TRTrain*)train;
- (instancetype)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod;
- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule;
+ (ODClassType*)type;
@end


