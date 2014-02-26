#import "objd.h"
#import "EGScene.h"
@class TRNotifications;
@class TRStr;
@class TRStrings;
@class TRTrainActor;

@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@interface TRScoreRules : NSObject
@property (nonatomic, readonly) NSInteger initialScore;
@property (nonatomic, readonly) NSInteger railCost;
@property (nonatomic, readonly) NSInteger railRemoveCost;
@property (nonatomic, readonly) NSInteger(^arrivedPrize)(TRTrainActor*);
@property (nonatomic, readonly) NSInteger(^destructionFine)(TRTrainActor*);
@property (nonatomic, readonly) CGFloat delayPeriod;
@property (nonatomic, readonly) NSInteger(^delayFine)(TRTrainActor*, NSInteger);
@property (nonatomic, readonly) NSInteger repairCost;

+ (instancetype)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrainActor*))arrivedPrize destructionFine:(NSInteger(^)(TRTrainActor*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrainActor*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (instancetype)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrainActor*))arrivedPrize destructionFine:(NSInteger(^)(TRTrainActor*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrainActor*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRScore : NSObject<EGUpdatable>
@property (nonatomic, readonly) TRScoreRules* rules;
@property (nonatomic, readonly) TRNotifications* notifications;

+ (instancetype)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (instancetype)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (ODClassType*)type;
- (NSInteger)score;
- (void)railBuilt;
- (void)railRemoved;
- (void)runTrain:(TRTrainActor*)train;
- (void)arrivedTrain:(TRTrainActor*)train;
- (void)destroyedTrain:(TRTrainActor*)train;
- (void)removeTrain:(TRTrainActor*)train;
- (void)updateWithDelta:(CGFloat)delta;
- (void)repairerCalled;
- (void)damageFixed;
+ (CNNotificationHandle*)changedNotification;
+ (ODClassType*)type;
@end


@interface TRTrainScore : NSObject<EGUpdatable>
@property (nonatomic, readonly) TRTrainActor* train;

+ (instancetype)trainScoreWithTrain:(TRTrainActor*)train;
- (instancetype)initWithTrain:(TRTrainActor*)train;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod;
- (NSInteger)fineWithRule:(NSInteger(^)(TRTrainActor*, NSInteger))rule;
+ (ODClassType*)type;
@end


