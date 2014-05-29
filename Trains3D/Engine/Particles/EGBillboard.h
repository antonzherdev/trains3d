#import "objd.h"
#import "GEVec.h"
#import "EGParticleSystem.h"

@class EGBillboardParticleSystem_impl;
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
NSString* egBillboardBufferDataDescription(EGBillboardBufferData self);
BOOL egBillboardBufferDataIsEqualTo(EGBillboardBufferData self, EGBillboardBufferData to);
NSUInteger egBillboardBufferDataHash(EGBillboardBufferData self);
CNPType* egBillboardBufferDataType();
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
EGBillboardBufferData* egBillboardParticleWriteToArray(EGBillboardParticle self, EGBillboardBufferData* array);
NSString* egBillboardParticleDescription(EGBillboardParticle self);
BOOL egBillboardParticleIsEqualTo(EGBillboardParticle self, EGBillboardParticle to);
NSUInteger egBillboardParticleHash(EGBillboardParticle self);
CNPType* egBillboardParticleType();
@interface EGBillboardParticleWrap : NSObject
@property (readonly, nonatomic) EGBillboardParticle value;

+ (id)wrapWithValue:(EGBillboardParticle)value;
- (id)initWithValue:(EGBillboardParticle)value;
@end



@protocol EGBillboardParticleSystem<EGParticleSystemIndexArray>
- (unsigned int)vertexCount;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
- (NSString*)description;
@end


@interface EGBillboardParticleSystem_impl : EGParticleSystemIndexArray_impl<EGBillboardParticleSystem>
+ (instancetype)billboardParticleSystem_impl;
- (instancetype)init;
- (NSUInteger)indexCount;
- (unsigned int*)createIndexArray;
@end


