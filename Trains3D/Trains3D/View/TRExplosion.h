#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"

@class TRExplosion;
@class TRExplosionFlame;
typedef struct TRExplosionFlameParticle TRExplosionFlameParticle;

@interface TRExplosion : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) CGFloat size;

+ (id)explosionWithPosition:(EGVec3)position size:(CGFloat)size;
- (id)initWithPosition:(EGVec3)position size:(CGFloat)size;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRExplosionFlame : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 position;
@property (nonatomic, readonly) CGFloat size;
@property (nonatomic, readonly) id<CNSeq> particles;

+ (id)explosionFlameWithPosition:(EGVec3)position size:(CGFloat)size;
- (id)initWithPosition:(EGVec3)position size:(CGFloat)size;
- (ODClassType*)type;
- (TRExplosionFlameParticle)generateParticle;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


struct TRExplosionFlameParticle {
    EGVec3 position;
    EGVec2 size;
    EGVec2 uv;
};
static inline TRExplosionFlameParticle TRExplosionFlameParticleMake(EGVec3 position, EGVec2 size, EGVec2 uv) {
    TRExplosionFlameParticle ret;
    ret.position = position;
    ret.size = size;
    ret.uv = uv;
    return ret;
}
static inline BOOL TRExplosionFlameParticleEq(TRExplosionFlameParticle s1, TRExplosionFlameParticle s2) {
    return EGVec3Eq(s1.position, s2.position) && EGVec2Eq(s1.size, s2.size) && EGVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger TRExplosionFlameParticleHash(TRExplosionFlameParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + EGVec2Hash(self.size);
    hash = hash * 31 + EGVec2Hash(self.uv);
    return hash;
}
static inline NSString* TRExplosionFlameParticleDescription(TRExplosionFlameParticle self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRExplosionFlameParticle: "];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", size=%@", EGVec2Description(self.size)];
    [description appendFormat:@", uv=%@", EGVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* trExplosionFlameParticleType();
@interface TRExplosionFlameParticleWrap : NSObject
@property (readonly, nonatomic) TRExplosionFlameParticle value;

+ (id)wrapWithValue:(TRExplosionFlameParticle)value;
- (id)initWithValue:(TRExplosionFlameParticle)value;
@end



