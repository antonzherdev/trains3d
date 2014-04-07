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
@class EGNormalMap;
@class EGPlatform;
@class EGShadowShader;
@class EGVertexBufferDesc;
@class EGBlendMode;
@class EGShadowType;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGTextureRegion;
@class EGDirectLight;
@class GEMat4;
@class EGShadowMap;

@class EGStandardShaderSystem;
@class EGStandardShadowShader;
@class EGStandardShaderKey;
@class EGStandardShader;

@interface EGStandardShaderSystem : EGShaderSystem
+ (instancetype)standardShaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (EGShader*)shaderForParam:(EGStandardMaterial*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGStandardShaderSystem*)instance;
+ (CNNotificationObserver*)settingsChangeObs;
+ (ODClassType*)type;
@end


@interface EGStandardShadowShader : EGShader {
@private
    EGShadowShader* _shadowShader;
}
@property (nonatomic, readonly) EGShadowShader* shadowShader;

+ (instancetype)standardShadowShaderWithShadowShader:(EGShadowShader*)shadowShader;
- (instancetype)initWithShadowShader:(EGShadowShader*)shadowShader;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGStandardMaterial*)param;
+ (EGStandardShadowShader*)instanceForColor;
+ (EGStandardShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGStandardShaderKey : NSObject<EGShaderTextBuilder> {
@private
    NSUInteger _directLightWithShadowsCount;
    NSUInteger _directLightWithoutShadowsCount;
    BOOL _texture;
    EGBlendMode* _blendMode;
    BOOL _region;
    BOOL _specular;
    BOOL _normalMap;
    BOOL _perPixel;
    BOOL _needUV;
    NSUInteger _directLightCount;
}
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

+ (instancetype)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
- (instancetype)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap;
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


@interface EGStandardShader : EGShader {
@private
    EGStandardShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _normalSlot;
    EGShaderAttribute* _uvSlot;
    EGShaderUniformI4* _diffuseTexture;
    EGShaderUniformI4* _normalMap;
    EGShaderUniformVec2* _uvScale;
    EGShaderUniformVec2* _uvShift;
    EGShaderUniformVec4* _ambientColor;
    EGShaderUniformVec4* _specularColor;
    EGShaderUniformF4* _specularSize;
    EGShaderUniformVec4* _diffuseColorUniform;
    EGShaderUniformMat4* _mwcpUniform;
    EGShaderUniformMat4* _mwcUniform;
    NSArray* _directLightDirections;
    NSArray* _directLightColors;
    NSArray* _directLightShadows;
    NSArray* _directLightDepthMwcp;
}
@property (nonatomic, readonly) EGStandardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* normalSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderUniformI4* diffuseTexture;
@property (nonatomic, readonly) EGShaderUniformI4* normalMap;
@property (nonatomic, readonly) EGShaderUniformVec2* uvScale;
@property (nonatomic, readonly) EGShaderUniformVec2* uvShift;
@property (nonatomic, readonly) EGShaderUniformVec4* ambientColor;
@property (nonatomic, readonly) EGShaderUniformVec4* specularColor;
@property (nonatomic, readonly) EGShaderUniformF4* specularSize;
@property (nonatomic, readonly) EGShaderUniformVec4* diffuseColorUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcUniform;
@property (nonatomic, readonly) NSArray* directLightDirections;
@property (nonatomic, readonly) NSArray* directLightColors;
@property (nonatomic, readonly) NSArray* directLightShadows;
@property (nonatomic, readonly) NSArray* directLightDepthMwcp;

+ (instancetype)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (instancetype)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGStandardMaterial*)param;
+ (ODClassType*)type;
@end


