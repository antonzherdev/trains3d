#import "objd.h"
#import "GEVec.h"
@class EGShaderSystem;
@class EGMesh;
@class EGVertexBuffer;
@class EGTexture;
@class EGSimpleShaderSystem;
@class EGStandardShaderSystem;

@class EGMaterial;
@class EGColorSource;
@class EGStandardMaterial;
@class EGMeshModel;
typedef struct EGBlendFunction EGBlendFunction;

@interface EGMaterial : NSObject
+ (id)material;
- (id)init;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
- (void)drawVb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode;
- (void)drawVb:(EGVertexBuffer*)vb mode:(unsigned int)mode;
+ (EGMaterial*)applyColor:(GEVec4)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGColorSource : EGMaterial
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) id texture;
@property (nonatomic, readonly) float alphaTestLevel;

+ (id)colorSourceWithColor:(GEVec4)color texture:(id)texture alphaTestLevel:(float)alphaTestLevel;
- (id)initWithColor:(GEVec4)color texture:(id)texture alphaTestLevel:(float)alphaTestLevel;
- (ODClassType*)type;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture;
+ (EGColorSource*)applyColor:(GEVec4)color;
+ (EGColorSource*)applyTexture:(EGTexture*)texture;
- (EGShaderSystem*)shaderSystem;
+ (ODClassType*)type;
@end


@interface EGStandardMaterial : EGMaterial
@property (nonatomic, readonly) EGColorSource* diffuse;
@property (nonatomic, readonly) GEVec4 specularColor;
@property (nonatomic, readonly) CGFloat specularSize;

+ (id)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize;
- (id)initWithDiffuse:(EGColorSource*)diffuse specularColor:(GEVec4)specularColor specularSize:(CGFloat)specularSize;
- (ODClassType*)type;
+ (EGStandardMaterial*)applyDiffuse:(EGColorSource*)diffuse;
- (EGShaderSystem*)shaderSystem;
+ (ODClassType*)type;
@end


@interface EGMeshModel : NSObject
@property (nonatomic, readonly) id<CNSeq> meshes;

+ (id)meshModelWithMeshes:(id<CNSeq>)meshes;
- (id)initWithMeshes:(id<CNSeq>)meshes;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


struct EGBlendFunction {
    unsigned int source;
    unsigned int destination;
};
static inline EGBlendFunction EGBlendFunctionMake(unsigned int source, unsigned int destination) {
    return (EGBlendFunction){source, destination};
}
static inline BOOL EGBlendFunctionEq(EGBlendFunction s1, EGBlendFunction s2) {
    return s1.source == s2.source && s1.destination == s2.destination;
}
static inline NSUInteger EGBlendFunctionHash(EGBlendFunction self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.source;
    hash = hash * 31 + self.destination;
    return hash;
}
NSString* EGBlendFunctionDescription(EGBlendFunction self);
void egBlendFunctionApplyDraw(EGBlendFunction self, void(^draw)());
EGBlendFunction egBlendFunctionStandard();
EGBlendFunction egBlendFunctionPremultiplied();
ODPType* egBlendFunctionType();
@interface EGBlendFunctionWrap : NSObject
@property (readonly, nonatomic) EGBlendFunction value;

+ (id)wrapWithValue:(EGBlendFunction)value;
- (id)initWithValue:(EGBlendFunction)value;
@end



