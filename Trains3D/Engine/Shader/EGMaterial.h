#import "objd.h"
#import "GEVec.h"
@class EGShaderSystem;
@class EGMesh;
@protocol EGVertexSource;
@protocol EGIndexSource;
@class EGShader;
@class EGTexture;
@class EGSimpleShaderSystem;
@class EGStandardShaderSystem;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGMaterial;
@class EGColorSource;
@class EGStandardMaterial;
@class EGMeshModel;
@class EGBlendFunction;

@interface EGMaterial : NSObject
+ (id)material;
- (id)init;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
- (void)drawVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (EGShader*)shader;
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


@interface EGBlendFunction : NSObject
@property (nonatomic, readonly) unsigned int source;
@property (nonatomic, readonly) unsigned int destination;

+ (id)blendFunctionWithSource:(unsigned int)source destination:(unsigned int)destination;
- (id)initWithSource:(unsigned int)source destination:(unsigned int)destination;
- (ODClassType*)type;
- (void)applyDraw:(void(^)())draw;
+ (EGBlendFunction*)standard;
+ (EGBlendFunction*)premultiplied;
+ (ODClassType*)type;
@end


