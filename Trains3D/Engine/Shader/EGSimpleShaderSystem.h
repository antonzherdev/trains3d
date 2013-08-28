#import "objd.h"
#import "CNTypes.h"
@class EG;
#import "EGGL.h"
#import "EGShader.h"
#import "EGTypes.h"
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;

@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGSimpleShaderSystem : NSObject<EGShaderSystem>
+ (id)simpleShaderSystem;
- (id)init;
- (EGShader*)shaderForContext:(EGContext*)context material:(EGSimpleMaterial*)material;
+ (EGSimpleShaderSystem*)instance;
@end


@interface EGSimpleShader : EGShader
+ (id)simpleShaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
+ (NSInteger)STRIDE;
+ (NSInteger)POSITION_SHIFT;
@end


@interface EGSimpleColorShader : EGSimpleShader
@property (nonatomic) EGColor color;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (void)load;
+ (NSString*)colorVertexProgram;
+ (NSString*)colorFragmentProgram;
@end


@interface EGSimpleTextureShader : EGSimpleShader
@property (nonatomic, retain) EGTexture* texture;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleTextureShader;
- (id)init;
- (void)load;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
@end


