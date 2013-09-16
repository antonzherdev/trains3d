#import "objd.h"
#import "EGTypes.h"
#import "GL.h"
@class EGTexture;
@class EGShaderSystem;
@class EGMesh;
@class EGSimpleShaderSystem;
@class EGStandardShaderSystem;

@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;
typedef struct EGBlendFunction EGBlendFunction;

@interface EGColorSource : NSObject
+ (id)colorSource;
- (id)init;
- (ODClassType*)type;
+ (EGColorSource*)applyColor:(EGColor)color;
+ (EGColorSource*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGColorSourceColor : EGColorSource
@property (nonatomic, readonly) EGColor color;

+ (id)colorSourceColorWithColor:(EGColor)color;
- (id)initWithColor:(EGColor)color;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGColorSourceTexture : EGColorSource
@property (nonatomic, readonly) EGTexture* texture;

+ (id)colorSourceTextureWithTexture:(EGTexture*)texture;
- (id)initWithTexture:(EGTexture*)texture;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMaterial : NSObject
+ (id)material;
- (id)init;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
+ (EGMaterial*)applyColor:(EGColor)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGSimpleMaterial : EGMaterial
@property (nonatomic, readonly) EGColorSource* color;

+ (id)simpleMaterialWithColor:(EGColorSource*)color;
- (id)initWithColor:(EGColorSource*)color;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
+ (ODClassType*)type;
@end


@interface EGStandardMaterial : EGMaterial
@property (nonatomic, readonly) EGColorSource* diffuse;
@property (nonatomic, readonly) EGColor specularColor;
@property (nonatomic, readonly) CGFloat specularSize;

+ (id)standardMaterialWithDiffuse:(EGColorSource*)diffuse specularColor:(EGColor)specularColor specularSize:(CGFloat)specularSize;
- (id)initWithDiffuse:(EGColorSource*)diffuse specularColor:(EGColor)specularColor specularSize:(CGFloat)specularSize;
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
    GLenum source;
    GLenum destination;
};
static inline EGBlendFunction EGBlendFunctionMake(GLenum source, GLenum destination) {
    return (EGBlendFunction){source, destination};
}
static inline BOOL EGBlendFunctionEq(EGBlendFunction s1, EGBlendFunction s2) {
    return GLenumEq(s1.source, s2.source) && GLenumEq(s1.destination, s2.destination);
}
static inline NSUInteger EGBlendFunctionHash(EGBlendFunction self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GLenumHash(self.source);
    hash = hash * 31 + GLenumHash(self.destination);
    return hash;
}
static inline NSString* EGBlendFunctionDescription(EGBlendFunction self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGBlendFunction: "];
    [description appendFormat:@"source=%@", GLenumDescription(self.source)];
    [description appendFormat:@", destination=%@", GLenumDescription(self.destination)];
    [description appendString:@">"];
    return description;
}
void egBlendFunctionApplyDraw(EGBlendFunction self, void(^draw)());
EGBlendFunction egBlendFunctionStandard();
EGBlendFunction egBlendFunctionPremultiplied();
ODPType* egBlendFunctionType();
@interface EGBlendFunctionWrap : NSObject
@property (readonly, nonatomic) EGBlendFunction value;

+ (id)wrapWithValue:(EGBlendFunction)value;
- (id)initWithValue:(EGBlendFunction)value;
@end



