#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
#import "EGBillboard.h"
#import "EGMaterial.h"
@class EGProgress;
@class EGGlobal;

@class TRExplosion;
@class TRExplosionFlame;
@class TRExplosionFlameParticle;
@class TRExplosionView;

@interface TRExplosion : NSObject<EGController>
@property (nonatomic, readonly) GEVec3 position;
@property (nonatomic, readonly) float size;
@property (nonatomic, readonly) TRExplosionFlame* flame;

+ (id)explosionWithPosition:(GEVec3)position size:(float)size;
- (id)initWithPosition:(GEVec3)position size:(float)size;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isFinished;
- (void)restart;
+ (ODType*)type;
@end


@interface TRExplosionFlame : EGBillboardParticleSystem
@property (nonatomic, readonly) GEVec3 position;
@property (nonatomic, readonly) float size;

+ (id)explosionFlameWithPosition:(GEVec3)position size:(float)size;
- (id)initWithPosition:(GEVec3)position size:(float)size;
- (ODClassType*)type;
- (EGBillboardParticle*)generateParticle;
- (TRExplosionFlame*)init;
+ (ODType*)type;
@end


@interface TRExplosionFlameParticle : EGBillboardParticle
@property (nonatomic, readonly) float size;
@property (nonatomic, readonly) GEVec2 startShift;
@property (nonatomic, readonly) GEVec2 shift;
@property (nonatomic, readonly) void(^animation)(float);

+ (id)explosionFlameParticleWithSize:(float)size startShift:(GEVec2)startShift shift:(GEVec2)shift;
- (id)initWithSize:(float)size startShift:(GEVec2)startShift shift:(GEVec2)shift;
- (ODClassType*)type;
+ (TRExplosionFlameParticle*)applyPosition:(GEVec3)position size:(float)size;
- (void)updateT:(float)t dt:(float)dt;
+ (GEVec4)startColor;
+ (GEQuadrant)textureQuadrant;
+ (ODType*)type;
@end


@interface TRExplosionView : NSObject
@property (nonatomic, readonly) EGSimpleMaterial* material;
@property (nonatomic, readonly) EGBillboardParticleSystemView* view;

+ (id)explosionView;
- (id)init;
- (ODClassType*)type;
- (void)drawExplosion:(TRExplosion*)explosion;
+ (ODType*)type;
@end


