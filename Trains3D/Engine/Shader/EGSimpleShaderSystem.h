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
- (ODType*)type;
+ (EGSimpleShaderSystem*)instance;
+ (ODType*)type;
@end


@interface EGSimpleShader : EGShader
+ (id)simpleShaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (ODType*)type;
+ (NSInteger)STRIDE;
+ (NSInteger)UV_SHIFT;
+ (NSInteger)POSITION_SHIFT;
+ (ODType*)type;
@end


@interface EGSimpleColorShader : EGSimpleShader
@property (nonatomic) EGColor color;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleColorShader;
- (id)init;
- (void)load;
- (ODType*)type;
+ (NSString*)colorVertexProgram;
+ (NSString*)colorFragmentProgram;
+ (ODType*)type;
@end


@interface EGSimpleTextureShader : EGSimpleShader
@property (nonatomic, retain) EGTexture* texture;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;

+ (id)simpleTextureShader;
- (id)init;
- (void)load;
- (ODType*)type;
+ (NSString*)textureVertexProgram;
+ (NSString*)textureFragmentProgram;
+ (ODType*)type;
@end


