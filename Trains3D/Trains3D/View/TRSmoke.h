#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
@class TRTrain;
@class TRWeather;
@class TRCar;
@class TRCarType;
@class TREngineType;
@class TRCarPosition;
@class TRRailPoint;
@class EGProgress;
@class EGGlobal;
@class EGColorSource;
@class EGBlendFunction;

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;

@interface TRSmoke : EGBillboardParticleSystem
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


@interface TRSmokeParticle : EGBillboardParticle
@property (nonatomic, readonly, weak) TRWeather* weather;
@property (nonatomic) GEVec3 speed;
@property (nonatomic, readonly) void(^animation)(float);

+ (id)smokeParticleWithWeather:(TRWeather*)weather;
- (id)initWithWeather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


@interface TRSmokeView : EGBillboardParticleSystemView
+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


