#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGStandardMaterial;
@class EGShadowShaderSystem;
@class EGEnvironment;
@class EGLight;
@class EGPlatform;
@class EGColorSource;
@class EGShadowShader;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGTexture;
@class EGDirectLight;
@class GEMat4;
@class EGShadowMap;

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
+ (EGStandardShadowShader*)instanceForColor;
+ (EGStandardShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGStandardShaderKey : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) NSUInteger directLightWithShadowsCount;
@property (nonatomic, readonly) NSUInteger directLightWithoutShadowsCount;
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) NSUInteger directLightCount;

+ (id)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture;
- (id)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture;
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
@property (nonatomic, readonly) id diffuseTexture;
@property (nonatomic, readonly) EGShaderUniformVec4* ambientColor;
@property (nonatomic, readonly) EGShaderUniformVec4* specularColor;
@property (nonatomic, readonly) EGShaderUniformF4* specularSize;
@property (nonatomic, readonly) EGShaderUniformVec4* diffuseColorUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) id mwcUniform;
@property (nonatomic, readonly) id<CNSeq> directLightDirections;
@property (nonatomic, readonly) id<CNSeq> directLightColors;
@property (nonatomic, readonly) id<CNSeq> directLightShadows;
@property (nonatomic, readonly) id<CNSeq> directLightDepthMwcp;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGStandardMaterial*)param;
+ (ODClassType*)type;
@end


