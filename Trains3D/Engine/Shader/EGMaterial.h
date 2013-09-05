#import "objd.h"
#import "EGTypes.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGMutableMatrix;
#import "EGGL.h"
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;
@class EGStandardShaderSystem;
@class EGStandardShaderKey;
@class EGStandardShader;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;

@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;

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
- (id<EGShaderSystem>)shaderSystem;
- (void)applyDraw:(void(^)())draw;
+ (EGMaterial*)applyColor:(EGColor)color;
+ (EGMaterial*)applyTexture:(EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGSimpleMaterial : EGMaterial
@property (nonatomic, readonly) EGColorSource* color;

+ (id)simpleMaterialWithColor:(EGColorSource*)color;
- (id)initWithColor:(EGColorSource*)color;
- (ODClassType*)type;
- (id<EGShaderSystem>)shaderSystem;
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
- (id<EGShaderSystem>)shaderSystem;
+ (ODClassType*)type;
@end


