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
@class EGSimpleShaderBuilder;
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


@interface EGSimpleShaderBuilder : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) NSString* fragment;

+ (id)simpleShaderBuilderWithTexture:(BOOL)texture;
- (id)initWithTexture:(BOOL)texture;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGSimpleColorShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
+ (ODClassType*)type;
@end


@interface EGSimpleTextureShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;

+ (id)simpleTextureShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
+ (ODClassType*)type;
@end


