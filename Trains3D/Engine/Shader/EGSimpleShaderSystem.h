#import "objd.h"
#import "EGShader.h"
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;

@class EGSimpleShaderSystem;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGSimpleShaderSystem : EGShaderSystem
+ (id)simpleShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForParam:(EGColorSource*)param;
+ (EGSimpleShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGSimpleColorShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
- (void)unloadParam:(EGColorSource*)param;
+ (NSString*)colorVertexProgram;
+ (NSString*)colorFragmentProgram;
+ (ODClassType*)type;
@end


@interface EGSimpleTextureShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;

+ (id)simpleTextureShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
- (void)unloadParam:(EGColorSource*)param;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
+ (ODClassType*)type;
@end


