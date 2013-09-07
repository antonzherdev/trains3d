#import "objd.h"
#import "CNTypes.h"
#import "EGGL.h"
#import "EGShader.h"
#import "EGTypes.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;
@class EGFileTexture;
#import "EGMaterial.h"
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGSimpleShaderSystem : EGShaderSystem
+ (id)simpleShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForMaterial:(EGSimpleMaterial*)material;
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
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
+ (NSString*)colorVertexProgram;
+ (NSString*)colorFragmentProgram;
+ (ODClassType*)type;
@end


@interface EGSimpleTextureShader : EGSimpleShader
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleTextureShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
+ (ODClassType*)type;
@end


