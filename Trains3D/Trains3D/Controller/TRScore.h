#import "objd.h"
#import "EGScene.h"
@class TRNotifications;
@class TRStr;
@class TRStrings;
@class TRTrain;

@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@interface TRScoreRules : NSObject
@property (nonatomic, readonly) NSInteger initialScore;
@property (nonatomic, readonly) NSInteger railCost;
@property (nonatomic, readonly) NSInteger railRemoveCost;
@property (nonatomic, readonly) NSInteger(^arrivedPrize)(TRTrain*);
@property (nonatomic, readonly) NSInteger(^destructionFine)(TRTrain*);
@property (nonatomic, readonly) CGFloat delayPeriod;
@property (nonatomic, readonly) NSInteger(^delayFine)(TRTrain*, NSInteger);
@property (nonatomic, readonly) NSInteger repairCost;

+ (id)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (id)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost railRemoveCost:(NSInteger)railRemoveCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(CGFloat)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRScore : NSObject<EGUpdatable>
@property (nonatomic, readonly) TRScoreRules* rules;
@property (nonatomic, readonly) TRNotifications* notifications;

+ (id)scoreWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (id)initWithRules:(TRScoreRules*)rules notifications:(TRNotifications*)notifications;
- (ODClassType*)type;
- (NSInteger)score;
- (void)railBuilt;
- (void)railRemoved;
- (void)runTrain:(TRTrain*)train;
- (void)arrivedTrain:(TRTrain*)train;
- (void)destroyedTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta;
- (void)repairerCalled;
- (void)damageFixed;
+ (ODClassType*)type;
@end


@interface TRTrainScore : NSObject<EGUpdatable>
@property (nonatomic, readonly) TRTrain* train;

+ (id)trainScoreWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)needFineWithDelayPeriod:(CGFloat)delayPeriod;
- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule;
+ (ODClassType*)type;
@end


