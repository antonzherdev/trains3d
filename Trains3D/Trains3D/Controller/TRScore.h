#import "objd.h"
#import "ATActor.h"
@class TRTrain;
@class TRNotifications;
@class ATVar;
@class TRStr;
@class TRStrings;

@class TRScoreRules;
@class TRScoreState;
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
+ (TRScoreRules*)aDefaultInitialScore:(NSInteger)initialScore;
+ (TRScoreRules*)aDefault;
+ (ODClassType*)type;
@end


@interface TRScoreState : NSObject {
@private
    NSInteger _money;
    NSArray* _trains;
}
@property (nonatomic, readonly) NSInteger money;
@property (nonatomic, readonly) NSArray* trains;

+ (instancetype)scoreStateWithMoney:(NSInteger)money trains:(NSArray*)trains;
- (instancetype)initWithMoney:(NSInteger)money trains:(NSArray*)trains;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRScore : ATActor {
@private
    TRScoreRules* _rules;
    TRNotifications* _notifications;
    ATVar* _money;
    NSArray* __trains;
}
@property (nonatomic, readonly) TRScoreRules* rules;
@property (nonatomic, readonly) TRNotifications* notifications;
@property (nonatomic, readonly) ATVar* money;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (ODClassType*)type;
- (CNFuture*)railBuilt;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRScoreState*)state;
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


@interface TRTrainScore : NSObject {
@private
    TRTrain* _train;
    CGFloat _delayTime;
    NSUInteger _fineTime;
}
@property (nonatomic, readonly) TRTrain* train;
@property (nonatomic, readonly) CGFloat delayTime;
@property (nonatomic, readonly) NSUInteger fineTime;

+ (instancetype)trainScoreWithTrain:(TRTrain*)train delayTime:(CGFloat)delayTime fineTime:(NSUInteger)fineTime;
- (instancetype)initWithTrain:(TRTrain*)train delayTime:(CGFloat)delayTime fineTime:(NSUInteger)fineTime;
- (ODClassType*)type;
- (TRTrainScore*)updateWithDelta:(CGFloat)delta;
- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod;
- (TRTrainScore*)fine;
+ (TRTrainScore*)applyTrain:(TRTrain*)train delayTime:(CGFloat)delayTime;
+ (TRTrainScore*)applyTrain:(TRTrain*)train fineTime:(NSUInteger)fineTime;
+ (TRTrainScore*)applyTrain:(TRTrain*)train;
+ (ODClassType*)type;
@end


