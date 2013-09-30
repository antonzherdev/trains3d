#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGGlobal;
@class EGContext;
@class EGStandardMaterial;
@class EGShadowShaderSystem;
@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@class EGColorSource;
@class EGShadowShader;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;
@class GEMat4;

@class EGStandardShaderSystem;
@class EGStandardShadowShader;
@class EGStandardShaderKey;
@class EGStandardShader;

@interface EGStandardShaderSystem : EGShaderSystem
+ (id)standardShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForParam:(EGStandardMaterial*)param;
+ (EGStandardShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGStandardShadowShader : EGShader
@property (nonatomic, readonly) EGShadowShader* shadowShader;

+ (id)standardShadowShaderWithShadowShader:(EGShadowShader*)shadowShader;
- (id)initWithShadowShader:(EGShadowShader*)shadowShader;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGStandardMaterial*)param;
- (void)unloadParam:(EGStandardMaterial*)param;
+ (EGStandardShadowShader*)instanceForColor;
+ (EGStandardShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGStandardShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL texture;

+ (id)standardShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
- (ODClassType*)type;
- (EGStandardShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsIn;
- (NSString*)lightsOut;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
+ (ODClassType*)type;
@end


@interface EGStandardShader : EGShader
@property (nonatomic, readonly) EGStandardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) id normalSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderUniform* ambientColor;
@property (nonatomic, readonly) EGShaderUniform* specularColor;
@property (nonatomic, readonly) EGShaderUniform* specularSize;
@property (nonatomic, readonly) EGShaderUniform* diffuseColorUniform;
@property (nonatomic, readonly) EGShaderUniform* mwcpUniform;
@property (nonatomic, readonly) id mwcUniform;
@property (nonatomic, readonly) id<CNSeq> directLightDirections;
@property (nonatomic, readonly) id<CNSeq> directLightColors;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGStandardMaterial*)param;
- (void)unloadParam:(EGStandardMaterial*)param;
+ (ODClassType*)type;
@end


