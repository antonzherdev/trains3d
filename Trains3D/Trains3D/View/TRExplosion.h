#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
#import "EGBillboard.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGParticleSystem;
@class EGParticle;
@class EGParticleSystemView;
#import "CNVoidRefArray.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;
@class EGMatrix;

@class TRExplosion;
@class TRExplosionFlame;
@class TRExplosionFlameParticle;
@class TRExplosionView;

@interface TRExplosion : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) float size;
@property (nonatomic, readonly) TRExplosionFlame* flame;

+ (id)explosionWithPosition:(EGVec3)position size:(float)size;
- (id)initWithPosition:(EGVec3)position size:(float)size;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isFinished;
- (void)restart;
+ (ODClassType*)type;
@end


@interface TRExplosionFlame : EGBillboardParticleSystem
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) float size;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(float)size;
- (id)initWithPosition:(EGVec3)position size:(float)size;
- (ODClassType*)type;
- (EGBillboardParticle*)generateParticle;
- (TRExplosionFlame*)init;
+ (ODClassType*)type;
@end


@interface TRExplosionFlameParticle : EGBillboardParticle
@property (nonatomic, readonly) float size;

+ (id)explosionFlameParticleWithSize:(float)size;
- (id)initWithSize:(float)size;
- (ODClassType*)type;
+ (TRExplosionFlameParticle*)applyPosition:(EGVec3)position size:(float)size;
- (void)updateT:(float)t dt:(float)dt;
+ (EGQuadrant)textureQuadrant;
+ (ODClassType*)type;
@end


@interface TRExplosionView : NSObject
@property (nonatomic, readonly) EGSimpleMaterial* material;
@property (nonatomic, readonly) EGBillboardParticleSystemView* view;

+ (id)explosionView;
- (id)init;
- (ODClassType*)type;
- (void)drawExplosion:(TRExplosion*)explosion;
+ (ODClassType*)type;
@end


