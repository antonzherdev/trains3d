#import "objd.h"
#import "GEVec.h"
@class EGShaderSystem;
@class EGMesh;
@protocol EGVertexBuffer;
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
@class EGBlendFunction;
@class EGBlendMode;

@interface EGMaterial : NSObject
+ (id)material;
- (id)init;
- (ODClassType*)type;
- (EGShaderSystem*)shaderSystem;
- (void)drawMesh:(EGMesh*)mesh;
- (void)drawVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (EGShader*)shader;
+ (EGMaterial*)applyColor:(GEVec4)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGColorSource : EGMaterial
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) id texture;
@property (nonatomic, readonly) EGBlendMode* blendMode;
@property (nonatomic, readonly) float alphaTestLevel;

+ (id)colorSourceWithColor:(GEVec4)color texture:(id)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel;
- (id)initWithColor:(GEVec4)color texture:(id)texture blendMode:(EGBlendMode*)blendMode alphaTestLevel:(float)alphaTestLevel;
- (ODClassType*)type;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture alphaTestLevel:(float)alphaTestLevel;
+ (EGColorSource*)applyColor:(GEVec4)color texture:(EGTexture*)texture blendMode:(EGBlendMode*)blendMode;
+ (EGColorSource*)applyColor:(GEVec4)color;
+ (EGColorSource*)applyTexture:(EGTexture*)texture;
- (EGShaderSystem*)shaderSystem;
- (EGColorSource*)setColor:(GEVec4)color;
- (GERect)uv;
+ (ODClassType*)type;
@end


@interface EGBlendMode : ODEnum
@property (nonatomic, readonly) NSString*(^blend)(NSString*, NSString*);

+ (EGBlendMode*)first;
+ (EGBlendMode*)second;
+ (EGBlendMode*)multiply;
+ (EGBlendMode*)darken;
+ (NSArray*)values;
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


