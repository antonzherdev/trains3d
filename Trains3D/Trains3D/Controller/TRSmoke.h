#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGParticleSystem.h"
@class TRTrain;
@class TRTrainType;
@class TRCarType;
@class TRWeather;
@class TRLevel;
@class TREngineType;
@class TRTrainState;
@class TRLiveTrainState;
@class TRLiveCarState;

@class TRSmoke;
@class TRSmokeParticle;

@interface TRSmoke : EGEmissiveBillboardParticleSystem
@property (nonatomic, readonly) TRTrain* train;
@property (nonatomic, retain) TRTrainState* _trainState;

+ (instancetype)smokeWithTrain:(TRTrain*)train;
- (instancetype)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (CNFuture*)lastWriteCount;
- (CNFuture*)writeToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array;
- (CNFuture*)executeWriteToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array;
- (CNFuture*)updateWithDelta:(CGFloat)delta trainState:(TRTrainState*)trainState;
- (TRSmokeParticle*)generateParticle;
+ (float)particleSize;
+ (GEQuad)modelQuad;
+ (GEQuadrant)textureQuadrant;
+ (GEVec4)defColor;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : EGEmittedParticle<EGBillboardParticle>
@property (nonatomic, readonly, weak) TRWeather* weather;
@property (nonatomic) GEVec3 speed;

+ (instancetype)smokeParticleWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (instancetype)initWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


