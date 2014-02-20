#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGSettings;
@class EGRenderTarget;
@class EGStandardMaterial;
@class EGShadowShaderSystem;
@class EGGlobal;
@class EGContext;
@class EGEnvironment;
@class EGLight;
@class EGColorSource;
@class EGTexture;
@class EGPlatform;
@class EGShadowShader;
@class EGVertexBufferDesc;
@class EGBlendMode;
@class EGShadowType;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGTextureRegion;
@class EGNormalMap;
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
- (EGShader*)shaderForParam:(EGStandardMaterial*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGStandardShaderSystem*)instance;
+ (CNNotificationObserver*)settingsChangeObs;
+ (ODClassType*)type;
@end


@interface EGStandardShadowShader : EGShader
@property (nonatomic, readonly) EGShadowShader* shadowShader;

+ (id)standardShadowShaderWithShadowShader:(EGShadowShader*)shadowShader;
- (id)initWithShadowShader:(EGShadowShader*)shadowShader;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGStandardMaterial*)param;
+ (EGStandardShadowShader*)instanceForColor;
+ (EGStandardShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGStandardShaderKey : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) NSUInteger directLightWithShadowsCount;
@property (nonatomic, readonly) NSUInteger directLightWithoutShadowsCount;
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) EGBlendMode* blendMode;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) BOOL specular;
@property (nonatomic, readonly) BOOL normalMap;
@property (nonatomic, readonly) BOOL perPixel;
@property (nonatomic, readonly) BOOL needUV;
@property (nonatomic, readonly) NSUInteger directLightCount;

+ (id)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
- (id)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
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
@property (nonatomic, readonly) id normalMap;
@property (nonatomic, readonly) id uvScale;
@property (nonatomic, readonly) id uvShift;
@property (nonatomic, readonly) EGShaderUniformVec4* ambientColor;
@property (nonatomic, readonly) id specularColor;
@property (nonatomic, readonly) id specularSize;
@property (nonatomic, readonly) id diffuseColorUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) id mwcUniform;
@property (nonatomic, readonly) id<CNSeq> directLightDirections;
@property (nonatomic, readonly) id<CNSeq> directLightColors;
@property (nonatomic, readonly) id<CNSeq> directLightShadows;
@property (nonatomic, readonly) id<CNSeq> directLightDepthMwcp;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGStandardMaterial*)param;
+ (ODClassType*)type;
@end


