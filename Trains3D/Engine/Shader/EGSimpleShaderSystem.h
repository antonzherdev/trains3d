#import "objd.h"
#import "EGShader.h"
@class EGColorSource;
@class EGVertexBuffer;
@class EGGlobal;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;

@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGSimpleShaderSystem : EGShaderSystem
+ (id)simpleShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForMaterial:(EGColorSource*)material;
+ (EGSimpleShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGSimpleShader : EGShader
+ (id)simpleShaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (ODClassType*)type;
+ (NSInteger)UV_SHIFT;
+ (NSInteger)POSITION_SHIFT;
+ (ODClassType*)type;
@end


@interface EGSimpleColorShader : EGSimpleShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(EGColorSource*)param;
+ (NSString*)colorVertexProgram;
+ (NSString*)colorFragmentProgram;
+ (ODClassType*)type;
@end


@interface EGSimpleTextureShader : EGSimpleShader
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;

+ (id)simpleTextureShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(EGColorSource*)param;
- (void)unloadMaterial:(EGColorSource*)material;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
+ (ODClassType*)type;
@end


