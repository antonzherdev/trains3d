#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
#import "EGBillboard.h"
@class EGParticleSystem;
@class EGParticle;
@class EGParticleSystemView;
#import "CNVoidRefArray.h"

@class TRExplosion;
@class TRExplosionFlame;
@class TRExplosionFlameParticle;

@interface TRExplosion : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) float size;

+ (id)explosionWithPosition:(EGVec3)position size:(float)size;
- (id)initWithPosition:(EGVec3)position size:(float)size;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRExplosionFlame : EGBillboardParticleSystem
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) float size;
@property (nonatomic, readonly) id<CNSeq> particles;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(float)size;
- (id)initWithPosition:(EGVec3)position size:(float)size;
- (ODClassType*)type;
- (EGBillboardParticle*)generateParticle;
- (TRExplosionFlame*)init;
+ (ODClassType*)type;
@end


@interface TRExplosionFlameParticle : EGBillboardParticle
+ (id)explosionFlameParticle;
- (id)init;
- (ODClassType*)type;
+ (TRExplosionFlameParticle*)applyPosition:(EGVec3)position size:(float)size;
+ (ODClassType*)type;
@end


