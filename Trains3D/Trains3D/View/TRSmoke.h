#import "objd.h"
#import "EGBillboard.h"
#import "EGVec.h"
#import "EGMaterial.h"
@class TRTrain;
@class TRCar;
@class TRCarType;
@class TREngineType;
@class TRRailPoint;
@class EG;

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
+ (EGQuad)modelQuad;
+ (EGQuadrant)textureQuadrant;
+ (EGVec4)defColor;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : EGBillboardParticle
@property (nonatomic) EGVec3 speed;

+ (id)smokeParticle;
- (id)init;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (NSInteger)dragCoefficient;
+ (ODClassType*)type;
@end


@interface TRSmokeView : EGBillboardParticleSystemView
+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


