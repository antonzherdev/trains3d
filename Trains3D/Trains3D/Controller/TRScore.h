#import "objd.h"
#import "EGTypes.h"
@class TRTrainType;
@class TRTrain;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;

@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@interface TRScoreRules : NSObject
@property (nonatomic, readonly) NSInteger initialScore;
@property (nonatomic, readonly) NSInteger railCost;
@property (nonatomic, readonly) NSInteger(^arrivedPrize)(TRTrain*);
@property (nonatomic, readonly) NSInteger(^destructionFine)(TRTrain*);
@property (nonatomic, readonly) float delayPeriod;
@property (nonatomic, readonly) NSInteger(^delayFine)(TRTrain*, NSInteger);
@property (nonatomic, readonly) NSInteger repairCost;

+ (id)scoreRulesWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(float)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
- (id)initWithInitialScore:(NSInteger)initialScore railCost:(NSInteger)railCost arrivedPrize:(NSInteger(^)(TRTrain*))arrivedPrize destructionFine:(NSInteger(^)(TRTrain*))destructionFine delayPeriod:(float)delayPeriod delayFine:(NSInteger(^)(TRTrain*, NSInteger))delayFine repairCost:(NSInteger)repairCost;
@end


@interface TRScore : NSObject<EGController>
@property (nonatomic, readonly) TRScoreRules* rules;

+ (id)scoreWithRules:(TRScoreRules*)rules;
- (id)initWithRules:(TRScoreRules*)rules;
- (NSInteger)score;
- (void)railBuilt;
- (void)runTrain:(TRTrain*)train;
- (void)arrivedTrain:(TRTrain*)train;
- (void)destroyedTrain:(TRTrain*)train;
- (void)removeTrain:(TRTrain*)train;
- (void)updateWithDelta:(float)delta;
@end


@interface TRTrainScore : NSObject<EGController>
@property (nonatomic, readonly) TRTrain* train;

+ (id)trainScoreWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (void)updateWithDelta:(float)delta;
- (BOOL)needFineWithDelayPeriod:(float)delayPeriod;
- (NSInteger)fineWithRule:(NSInteger(^)(TRTrain*, NSInteger))rule;
@end


