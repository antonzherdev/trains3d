#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGParticleSystem.h"
@class TRTrain;
@class TRWeather;
@class TRCar;
@class TRCarType;
@class TREngineType;
@class TRTrainType;
@class TRCarPosition;

@class TRSmoke;
@class TRSmokeParticle;

@interface TRSmoke : EGEmissiveBillboardParticleSystem
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly, weak) TRWeather* weather;

+ (instancetype)smokeWithTrain:(TRTrain*)train weather:(TRWeather*)weather;
- (instancetype)initWithTrain:(TRTrain*)train weather:(TRWeather*)weather;
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


