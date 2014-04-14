#import "objd.h"
#import "GEVec.h"
#import "EGParticleSystem.h"
#import "EGParticleSystem2.h"

@class EGBillboardParticleSystem;
@class EGEmissiveBillboardParticleSystem;
@protocol EGBillboardParticle;
@protocol EGBillboardParticleSystem2;
typedef struct EGBillboardBufferData EGBillboardBufferData;
typedef struct EGBillboardParticle2 EGBillboardParticle2;

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



@interface EGBillboardParticleSystem : EGParticleSystem
+ (instancetype)billboardParticleSystem;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEmissiveBillboardParticleSystem : EGEmissiveParticleSystem
+ (instancetype)emissiveBillboardParticleSystem;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@protocol EGBillboardParticle<EGParticle>
@property (nonatomic) GEVec3 position;
@property (nonatomic) GEQuad uv;
@property (nonatomic) GEQuad model;
@property (nonatomic) GEVec4 color;

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
@end


struct EGBillboardParticle2 {
    GEVec3 position;
    GEQuad uv;
    GEQuad model;
    GEVec4 color;
};
static inline EGBillboardParticle2 EGBillboardParticle2Make(GEVec3 position, GEQuad uv, GEQuad model, GEVec4 color) {
    return (EGBillboardParticle2){position, uv, model, color};
}
static inline BOOL EGBillboardParticle2Eq(EGBillboardParticle2 s1, EGBillboardParticle2 s2) {
    return GEVec3Eq(s1.position, s2.position) && GEQuadEq(s1.uv, s2.uv) && GEQuadEq(s1.model, s2.model) && GEVec4Eq(s1.color, s2.color);
}
static inline NSUInteger EGBillboardParticle2Hash(EGBillboardParticle2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + GEQuadHash(self.uv);
    hash = hash * 31 + GEQuadHash(self.model);
    hash = hash * 31 + GEVec4Hash(self.color);
    return hash;
}
NSString* EGBillboardParticle2Description(EGBillboardParticle2 self);
ODPType* egBillboardParticle2Type();
@interface EGBillboardParticle2Wrap : NSObject
@property (readonly, nonatomic) EGBillboardParticle2 value;

+ (id)wrapWithValue:(EGBillboardParticle2)value;
- (id)initWithValue:(EGBillboardParticle2)value;
@end



@protocol EGBillboardParticleSystem2<EGParticleSystemIndexArray>
- (unsigned int)vertexCount;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
@end


