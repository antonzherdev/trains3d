#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
#import "EGParticleSystem.h"
#import "EGMaterial.h"
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;
@class EGD2D;
@class GEMat4;

@class EGBillboardShaderSystem;
@class EGBillboardShaderBuilder;
@class EGBillboardShader;
@class EGBillboardParticleSystem;
@class EGBillboardParticle;
@class EGBillboardParticleSystemView;
@class EGBillboard;
typedef struct EGBillboardBufferData EGBillboardBufferData;

@interface EGBillboardShaderSystem : EGShaderSystem
- (ODClassType*)type;
+ (EGBillboardShader*)shaderForParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


@interface EGBillboardShaderBuilder : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) NSString* parameters;
@property (nonatomic, readonly) NSString* code;

+ (id)billboardShaderBuilderWithTexture:(BOOL)texture shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code;
- (id)initWithTexture:(BOOL)texture shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGBillboardShader : EGShader
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* colorSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* alphaTestLevelUniform;
@property (nonatomic, readonly) EGShaderUniform* wcUniform;
@property (nonatomic, readonly) EGShaderUniform* pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture shadow:(BOOL)shadow;
- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture shadow:(BOOL)shadow;
- (ODClassType*)type;
+ (EGBillboardShader*)instanceForColor;
+ (EGBillboardShader*)instanceForTexture;
+ (EGBillboardShader*)instanceForColorShadow;
+ (EGBillboardShader*)instanceForTextureShadow;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
+ (ODClassType*)type;
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
NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self);
ODPType* egBillboardBufferDataType();
@interface EGBillboardBufferDataWrap : NSObject
@property (readonly, nonatomic) EGBillboardBufferData value;

+ (id)wrapWithValue:(EGBillboardBufferData)value;
- (id)initWithValue:(EGBillboardBufferData)value;
@end



@interface EGBillboardParticleSystem : EGParticleSystem
+ (id)billboardParticleSystem;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
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
+ (ODClassType*)type;
@end


@interface EGBillboardParticleSystemView : EGParticleSystemView
@property (nonatomic, readonly) EGColorSource* material;
@property (nonatomic, readonly) EGShader* shader;

+ (id)billboardParticleSystemViewWithMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction)blendFunc;
- (id)initWithMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction)blendFunc;
- (ODClassType*)type;
+ (EGBillboardParticleSystemView*)applyMaxCount:(NSUInteger)maxCount material:(EGColorSource*)material;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
+ (ODClassType*)type;
@end


@interface EGBillboard : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GERect uv;
@property (nonatomic) GEVec3 position;
@property (nonatomic) GERect rect;

+ (id)billboard;
- (id)init;
- (ODClassType*)type;
- (void)draw;
+ (EGBillboard*)applyMaterial:(EGColorSource*)material;
- (BOOL)containsVec2:(GEVec2)vec2;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


