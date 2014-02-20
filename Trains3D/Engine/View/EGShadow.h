#import "objd.h"
#import "EGSurface.h"
#import "GEVec.h"
#import "EGShader.h"
@class GEMat4;
@class EGTexture;
@class EGEmptyTexture;
@class EGVertexArray;
@class EGMesh;
@class EGGlobal;
@class EGContext;
@class EGColorSource;
@class EGCullFace;
@class EGVertexBufferDesc;
@class EGRenderTarget;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGEnvironment;
@class EGLight;
@class EGViewportSurface;

@class EGShadowMap;
@class EGShadowSurfaceShaderBuilder;
@class EGShadowSurfaceShader;
@class EGShadowShaderSystem;
@class EGShadowShaderText;
@class EGShadowShader;
@class EGShadowDrawParam;
@class EGShadowDrawShaderSystem;
@class EGShadowDrawShaderKey;
@class EGShadowDrawShader;

@interface EGShadowMap : EGSurface
@property (nonatomic, readonly) unsigned int frameBuffer;
@property (nonatomic, retain) GEMat4* biasDepthCp;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)shadowMapWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (void)draw;
+ (GEMat4*)biasMatrix;
+ (ODClassType*)type;
@end


@interface EGShadowSurfaceShaderBuilder : EGViewportShaderBuilder
+ (id)shadowSurfaceShaderBuilder;
- (id)init;
- (ODClassType*)type;
- (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGShadowSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (id)shadowSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


@interface EGShadowShaderSystem : EGShaderSystem
+ (id)shadowShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShadowShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (BOOL)isColorShaderForParam:(EGColorSource*)param;
+ (EGShadowShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGShadowShaderText : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL texture;

+ (id)shadowShaderTextWithTexture:(BOOL)texture;
- (id)initWithTexture:(BOOL)texture;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGShadowShader : EGShader
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) id alphaTestLevelUniform;

+ (id)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (id)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (EGShadowShader*)instanceForColor;
+ (EGShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGShadowDrawParam : NSObject
@property (nonatomic, readonly) id<CNSeq> percents;
@property (nonatomic, readonly) id viewportSurface;

+ (id)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface;
- (id)initWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderSystem : EGShaderSystem
+ (id)shadowDrawShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShadowDrawShader*)shaderForParam:(EGShadowDrawParam*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGShadowDrawShaderSystem*)instance;
+ (CNNotificationObserver*)settingsChangeObs;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderKey : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL viewportSurface;

+ (id)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (ODClassType*)type;
- (EGShadowDrawShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsIn;
- (NSString*)lightsOut;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShader : EGShader
@property (nonatomic, readonly) EGShadowDrawShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) id<CNSeq> directLightPercents;
@property (nonatomic, readonly) id<CNSeq> directLightDepthMwcp;
@property (nonatomic, readonly) id<CNSeq> directLightShadows;

+ (id)shadowDrawShaderWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGShadowDrawParam*)param;
+ (ODClassType*)type;
@end


