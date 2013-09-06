#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
#import "EGVec.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;
#import "EGShader.h"
#import "EGTypes.h"
#import "EGParticleSystem.h"
#import "CNVoidRefArray.h"
@class EGMatrix;
@class EGTexture;
@class EGFileTexture;
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

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
+ (ODClassType*)type;
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
+ (ODClassType*)type;
@end


struct EGBillboardBufferData {
    EGVec3 position;
    EGVec2 model;
    EGVec4 color;
    EGVec2 uv;
};
static inline EGBillboardBufferData EGBillboardBufferDataMake(EGVec3 position, EGVec2 model, EGVec4 color, EGVec2 uv) {
    return (EGBillboardBufferData){position, model, color, uv};
}
static inline BOOL EGBillboardBufferDataEq(EGBillboardBufferData s1, EGBillboardBufferData s2) {
    return EGVec3Eq(s1.position, s2.position) && EGVec2Eq(s1.model, s2.model) && EGVec4Eq(s1.color, s2.color) && EGVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger EGBillboardBufferDataHash(EGBillboardBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + EGVec2Hash(self.model);
    hash = hash * 31 + EGVec4Hash(self.color);
    hash = hash * 31 + EGVec2Hash(self.uv);
    return hash;
}
static inline NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardBufferData: "];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", model=%@", EGVec2Description(self.model)];
    [description appendFormat:@", color=%@", EGVec4Description(self.color)];
    [description appendFormat:@", uv=%@", EGVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
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
@property (nonatomic) EGVec3 position;
@property (nonatomic) EGQuad uv;
@property (nonatomic) EGQuad model;
@property (nonatomic) EGVec4 color;

+ (id)billboardParticleWithLifeLength:(float)lifeLength;
- (id)initWithLifeLength:(float)lifeLength;
- (ODClassType*)type;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
+ (ODClassType*)type;
@end


@interface EGBillboardParticleSystemView : EGParticleSystemView
@property (nonatomic, readonly) EGSimpleMaterial* material;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) NSUInteger vertexCount;

+ (id)billboardParticleSystemViewWithMaterial:(EGSimpleMaterial*)material;
- (id)initWithMaterial:(EGSimpleMaterial*)material;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


