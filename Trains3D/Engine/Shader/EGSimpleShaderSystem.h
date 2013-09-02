#import "objd.h"
#import "CNTypes.h"
#import "EGGL.h"
#import "EGShader.h"
#import "EGTypes.h"
@class EGContext;
@class EGMutableMatrix;
@class EGTexture;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;

@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;

@interface EGSimpleShaderSystem : NSObject<EGShaderSystem>
+ (id)simpleShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForContext:(EGContext*)context material:(EGSimpleMaterial*)material;
+ (EGSimpleShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGSimpleShader : EGShader
+ (id)simpleShaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (ODClassType*)type;
+ (NSInteger)STRIDE;
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
- (void)loadContext:(EGContext*)context material:(EGSimpleMaterial*)material;
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
- (void)loadContext:(EGContext*)context material:(EGSimpleMaterial*)material;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
+ (ODClassType*)type;
@end


