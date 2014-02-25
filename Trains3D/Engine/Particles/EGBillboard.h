#import "objd.h"
#import "GEVec.h"
#import "EGParticleSystem.h"

@class EGEmissiveBillboardParticleSystem;
@protocol EGBillboardParticleSystem;
@protocol EGBillboardParticle;
typedef struct EGBillboardBufferData EGBillboardBufferData;

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



@protocol EGBillboardParticleSystem<EGParticleSystem>
@end


@interface EGEmissiveBillboardParticleSystem : EGEmissiveParticleSystem
+ (id)emissiveBillboardParticleSystem;
- (id)init;
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


