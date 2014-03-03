#import "objd.h"
#import "ATTypedActor.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGParticleSystem.h"
@class TRTrainState;
@class TRTrainType;
@class TRCarType;
@class TRWeather;
@class TREngineType;
@class TRLiveTrainState;
@class TRLiveCarState;

@class TRSmokeActor;
@class TRSmoke;
@class TRSmokeParticle;

@interface TRSmokeActor : ATTypedActor
@property (nonatomic, readonly) TRSmoke* smoke;
@property (nonatomic) id _viewData;

+ (instancetype)smokeActorWithSmoke:(TRSmoke*)smoke;
- (instancetype)initWithSmoke:(TRSmoke*)smoke;
- (ODClassType*)type;
- (CNFuture*)viewDataCreator:(id(^)(TRSmoke*))creator;
- (CNFuture*)updateWithDelta:(CGFloat)delta trainState:(TRTrainState*)trainState;
+ (ODClassType*)type;
@end


@interface TRSmoke : EGEmissiveBillboardParticleSystem
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) CGFloat speed;
@property (nonatomic, readonly) TRCarType* engineCarType;
@property (nonatomic, readonly, weak) TRWeather* weather;
@property (nonatomic, retain) TRTrainState* _trainState;

+ (instancetype)smokeWithTrainType:(TRTrainType*)trainType speed:(CGFloat)speed engineCarType:(TRCarType*)engineCarType weather:(TRWeather*)weather;
- (instancetype)initWithTrainType:(TRTrainType*)trainType speed:(CGFloat)speed engineCarType:(TRCarType*)engineCarType weather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)generateParticlesWithDelta:(CGFloat)delta;
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


