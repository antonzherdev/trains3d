#import "objd.h"
#import "GEVec.h"
#import "EGParticleSystem.h"

@protocol EGBillboardParticleSystem;
typedef struct EGBillboardBufferData EGBillboardBufferData;
typedef struct EGBillboardParticle EGBillboardParticle;

struct EGBillboardBufferData {
    GEVec3 position;
    GEVec2 model;
    GEVec4 color;
    GEVec2 uv;
};
static inline EGBillboardBufferData EGBillboardBufferDataMake(GEVec3 position, GEVec2 model, GEVec4 color, GEVec2 uv) {
    return (EGBillboardBufferData){position, model, color, uv};
}
static inline BOOL EGBillboardBufferDataEq(EGBillboardBufferData s1, EGBillboardBufferData s2) {
    return GEVec3Eq(s1.position, s2.position) && GEVec2Eq(s1.model, s2.model) && GEVec4Eq(s1.color, s2.color) && GEVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger EGBillboardBufferDataHash(EGBillboardBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.model);
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec2Hash(self.uv);
    return hash;
}
NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self);
ODPType* egBillboardBufferDataType();
@interface EGBillboardBufferDataWrap : NSObject
@property (readonly, nonatomic) EGBillboardBufferData value;

+ (id)wrapWithValue:(EGBillboardBufferData)value;
- (id)initWithValue:(EGBillboardBufferData)value;
@end



struct EGBillboardParticle {
    GEVec3 position;
    GEQuad uv;
    GEQuad model;
    GEVec4 color;
};
static inline EGBillboardParticle EGBillboardParticleMake(GEVec3 position, GEQuad uv, GEQuad model, GEVec4 color) {
    return (EGBillboardParticle){position, uv, model, color};
}
static inline BOOL EGBillboardParticleEq(EGBillboardParticle s1, EGBillboardParticle s2) {
    return GEVec3Eq(s1.position, s2.position) && GEQuadEq(s1.uv, s2.uv) && GEQuadEq(s1.model, s2.model) && GEVec4Eq(s1.color, s2.color);
}
static inline NSUInteger EGBillboardParticleHash(EGBillboardParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + GEQuadHash(self.uv);
    hash = hash * 31 + GEQuadHash(self.model);
    hash = hash * 31 + GEVec4Hash(self.color);
    return hash;
}
NSString* EGBillboardParticleDescription(EGBillboardParticle self);
ODPType* egBillboardParticleType();
@interface EGBillboardParticleWrap : NSObject
@property (readonly, nonatomic) EGBillboardParticle value;

+ (id)wrapWithValue:(EGBillboardParticle)value;
- (id)initWithValue:(EGBillboardParticle)value;
@end



@protocol EGBillboardParticleSystem<EGParticleSystemIndexArray>
- (unsigned int)vertexCount;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
@end


