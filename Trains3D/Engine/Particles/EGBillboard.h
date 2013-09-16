#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
#import "EGParticleSystem.h"
#import "EGMaterial.h"
@class EGVertexBuffer;
@class EG;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;

@class EGBillboardShaderSystem;
@class EGBillboardShader;
@class EGBillboardParticleSystem;
@class EGBillboardParticle;
@class EGBillboardParticleSystemView;
typedef struct EGBillboardBufferData EGBillboardBufferData;

@interface EGBillboardShaderSystem : EGShaderSystem
+ (id)billboardShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGBillboardShader*)shaderForMaterial:(EGSimpleMaterial*)material;
+ (EGBillboardShaderSystem*)instance;
+ (ODType*)type;
@end


@interface EGBillboardShader : EGShader
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* colorSlot;
@property (nonatomic, readonly) id colorUniform;
@property (nonatomic, readonly) EGShaderUniform* wcUniform;
@property (nonatomic, readonly) EGShaderUniform* pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (ODClassType*)type;
+ (EGBillboardShader*)instanceForColor;
+ (EGBillboardShader*)instanceForTexture;
+ (NSString*)vertexTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
+ (NSString*)fragmentTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (ODType*)type;
@end


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
static inline NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardBufferData: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", model=%@", GEVec2Description(self.model)];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODType* egBillboardBufferDataType();
@interface EGBillboardBufferDataWrap : NSObject
@property (readonly, nonatomic) EGBillboardBufferData value;

+ (id)wrapWithValue:(EGBillboardBufferData)value;
- (id)initWithValue:(EGBillboardBufferData)value;
@end



@interface EGBillboardParticleSystem : EGParticleSystem
+ (id)billboardParticleSystem;
- (id)init;
- (ODClassType*)type;
+ (ODType*)type;
@end


@interface EGBillboardParticle : EGParticle
@property (nonatomic) GEVec3 position;
@property (nonatomic) GEQuad uv;
@property (nonatomic) GEQuad model;
@property (nonatomic) GEVec4 color;

+ (id)billboardParticleWithLifeLength:(float)lifeLength;
- (id)initWithLifeLength:(float)lifeLength;
- (ODClassType*)type;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
+ (ODType*)type;
@end


@interface EGBillboardParticleSystemView : EGParticleSystemView
@property (nonatomic, readonly) EGSimpleMaterial* material;
@property (nonatomic, readonly) EGShader* shader;

+ (id)billboardParticleSystemViewWithMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material blendFunc:(EGBlendFunction)blendFunc;
- (id)initWithMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material blendFunc:(EGBlendFunction)blendFunc;
- (ODClassType*)type;
+ (EGBillboardParticleSystemView*)applyMaxCount:(NSUInteger)maxCount material:(EGSimpleMaterial*)material;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
+ (ODType*)type;
@end


