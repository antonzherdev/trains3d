#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"

@class TRExplosion;
@class TRExplosionFlame;
typedef struct TRExplosionFlameParticle TRExplosionFlameParticle;

@interface TRExplosion : NSObject<EGController>
@property (nonatomic, readonly) EGVec3 position;

+ (id)explosionWithPosition:(EGVec3)position;
- (id)initWithPosition:(EGVec3)position;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRExplosionFlame : NSObject
@property (nonatomic, readonly) EGVec3 position;

+ (id)explosionFlameWithPosition:(EGVec3)position;
- (id)initWithPosition:(EGVec3)position;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


struct TRExplosionFlameParticle {
    EGVec3 position;
    EGVec2 texturePos;
};
static inline TRExplosionFlameParticle TRExplosionFlameParticleMake(EGVec3 position, EGVec2 texturePos) {
    TRExplosionFlameParticle ret;
    ret.position = position;
    ret.texturePos = texturePos;
    return ret;
}
static inline BOOL TRExplosionFlameParticleEq(TRExplosionFlameParticle s1, TRExplosionFlameParticle s2) {
    return EGVec3Eq(s1.position, s2.position) && EGVec2Eq(s1.texturePos, s2.texturePos);
}
static inline NSUInteger TRExplosionFlameParticleHash(TRExplosionFlameParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + EGVec2Hash(self.texturePos);
    return hash;
}
static inline NSString* TRExplosionFlameParticleDescription(TRExplosionFlameParticle self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRExplosionFlameParticle: "];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", texturePos=%@", EGVec2Description(self.texturePos)];
    [description appendString:@">"];
    return description;
}
ODPType* trExplosionFlameParticleType();
@interface TRExplosionFlameParticleWrap : NSObject
@property (readonly, nonatomic) TRExplosionFlameParticle value;

+ (id)wrapWithValue:(TRExplosionFlameParticle)value;
- (id)initWithValue:(TRExplosionFlameParticle)value;
@end



