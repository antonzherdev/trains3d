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
@class EGMatrix;
@class EGTexture;
@class EGFileTexture;
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

@class EGBillboardShaderSystem;
@class EGBillboardShader;
typedef struct EGBillboardBufferData EGBillboardBufferData;

struct EGBillboardBufferData {
    EGVec3 position;
    EGVec2 model;
    EGVec2 uv;
};
static inline EGBillboardBufferData EGBillboardBufferDataMake(EGVec3 position, EGVec2 model, EGVec2 uv) {
    return (EGBillboardBufferData){position, model, uv};
}
static inline BOOL EGBillboardBufferDataEq(EGBillboardBufferData s1, EGBillboardBufferData s2) {
    return EGVec3Eq(s1.position, s2.position) && EGVec2Eq(s1.model, s2.model) && EGVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger EGBillboardBufferDataHash(EGBillboardBufferData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec3Hash(self.position);
    hash = hash * 31 + EGVec2Hash(self.model);
    hash = hash * 31 + EGVec2Hash(self.uv);
    return hash;
}
static inline NSString* EGBillboardBufferDataDescription(EGBillboardBufferData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBillboardBufferData: "];
    [description appendFormat:@"position=%@", EGVec3Description(self.position)];
    [description appendFormat:@", model=%@", EGVec2Description(self.model)];
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
@property (nonatomic, readonly) id colorUniform;
@property (nonatomic, readonly) EGShaderUniform* wcUniform;
@property (nonatomic, readonly) EGShaderUniform* pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture;
- (ODClassType*)type;
+ (EGShader*)instanceForColor;
+ (EGShader*)instanceForTexture;
+ (NSString*)vertexTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
+ (NSString*)fragmentTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (ODClassType*)type;
@end


