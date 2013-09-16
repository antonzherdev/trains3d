#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class TRTrain;
@class TRCar;
@class TRCarType;
@class TREngineType;
@class TRCarPosition;
@class TRRailPoint;
@class EGProgress;
@class EGGlobal;

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;

@interface TRSmoke : EGBillboardParticleSystem
@property (nonatomic, readonly, weak) TRTrain* train;

+ (id)smokeWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
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
@property (nonatomic) GEVec3 speed;
@property (nonatomic, readonly) void(^animation)(float);

+ (id)smokeParticle;
- (id)init;
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


