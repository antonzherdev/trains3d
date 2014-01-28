#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRCar.h"
#import "TRRailPoint.h"
#import "EGParticleSystem.h"
@class TRTrain;
@class TRWeather;
@class TRTrainType;
@class EGGlobal;
@class EGColorSource;
@class EGBlendFunction;

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;

@interface TRSmoke : EGEmissiveBillboardParticleSystem
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly, weak) TRWeather* weather;

+ (id)smokeWithTrain:(TRTrain*)train weather:(TRWeather*)weather;
- (id)initWithTrain:(TRTrain*)train weather:(TRWeather*)weather;
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

+ (id)smokeParticleWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (id)initWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


@interface TRSmokeView : EGBillboardParticleSystemView
@property (nonatomic, readonly) TRSmoke* system;

+ (id)smokeViewWithSystem:(TRSmoke*)system;
- (id)initWithSystem:(TRSmoke*)system;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


