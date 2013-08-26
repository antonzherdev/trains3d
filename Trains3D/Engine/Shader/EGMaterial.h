#import "objd.h"
#import "EGTypes.h"
@class EG;
#import "EGGL.h"
@class EGContext;
@class EGMutableMatrix;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@class EGStandardShader;
@class EGSimpleColorShader;
@class EGTexture;

@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGMaterialColor;
@class EGStandardMaterial;
@class EGMaterial;

@interface EGColorSource : NSObject
+ (id)colorSource;
- (id)init;
@end


@interface EGColorSourceColor : EGColorSource
@property (nonatomic, readonly) EGColor color;

+ (id)colorSourceColorWithColor:(EGColor)color;
- (id)initWithColor:(EGColor)color;
@end


@interface EGColorSourceTexture : EGColorSource
@property (nonatomic, readonly) EGTexture* texture;

+ (id)colorSourceTextureWithTexture:(EGTexture*)texture;
- (id)initWithTexture:(EGTexture*)texture;
@end


@interface EGMaterial2 : NSObject
+ (id)material2;
- (id)init;
- (EGShader*)shaderForContext:(EGContext*)context;
- (void)applyDraw:(void(^)())draw;
+ (EGMaterial2*)applyColor:(EGColor)color;
@end


@interface EGMaterialColor : EGMaterial2
@property (nonatomic, readonly) EGColor color;

+ (id)materialColorWithColor:(EGColor)color;
- (id)initWithColor:(EGColor)color;
- (EGShader*)shaderForContext:(EGContext*)context;
@end


@interface EGStandardMaterial : NSObject
@property (nonatomic, readonly) EGColorSource* diffuse;
@property (nonatomic, readonly) CGFloat ambient;
@property (nonatomic, readonly) EGColor specular;

+ (id)standardMaterialWithDiffuse:(EGColorSource*)diffuse ambient:(CGFloat)ambient specular:(EGColor)specular;
- (id)initWithDiffuse:(EGColorSource*)diffuse ambient:(CGFloat)ambient specular:(EGColor)specular;
@end


@interface EGMaterial : NSObject
@property (nonatomic, readonly) EGColor ambient;
@property (nonatomic, readonly) EGColor diffuse;
@property (nonatomic, readonly) EGColor specular;
@property (nonatomic, readonly) CGFloat shininess;

+ (id)materialWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess;
- (id)initWithAmbient:(EGColor)ambient diffuse:(EGColor)diffuse specular:(EGColor)specular shininess:(CGFloat)shininess;
- (void)set;
- (void)drawF:(void(^)())f;
+ (EGMaterial*)default;
+ (EGMaterial*)emerald;
+ (EGMaterial*)jade;
+ (EGMaterial*)obsidian;
+ (EGMaterial*)pearl;
+ (EGMaterial*)ruby;
+ (EGMaterial*)turquoise;
+ (EGMaterial*)brass;
+ (EGMaterial*)bronze;
+ (EGMaterial*)chrome;
+ (EGMaterial*)copper;
+ (EGMaterial*)gold;
+ (EGMaterial*)silver;
+ (EGMaterial*)blackPlastic;
+ (EGMaterial*)cyanPlastic;
+ (EGMaterial*)greenPlastic;
+ (EGMaterial*)redPlastic;
+ (EGMaterial*)whitePlastic;
+ (EGMaterial*)yellowPlastic;
+ (EGMaterial*)blackRubber;
+ (EGMaterial*)cyanRubber;
+ (EGMaterial*)greenRubber;
+ (EGMaterial*)redRubber;
+ (EGMaterial*)whiteRubber;
+ (EGMaterial*)yellowRubber;
+ (EGMaterial*)wood;
+ (EGMaterial*)stone;
+ (EGMaterial*)steel;
+ (EGMaterial*)blackMetal;
+ (EGMaterial*)grass;
@end


