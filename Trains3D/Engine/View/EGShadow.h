#import "objd.h"
#import "EGSurface.h"
#import "GL.h"
#import "GEVec.h"
#import "EGShader.h"
@class GEMat4;
@class EGTexture;
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGColorSource;
@class EGEnablingState;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGEnvironment;
@class EGLight;
@class EGStandardShader;

@class EGShadowMap;
@class EGShadowSurfaceShaderBuilder;
@class EGShadowSurfaceShader;
@class EGShadowShaderSystem;
@class EGShadowShader;
@class EGShadowDrawParam;
@class EGShadowDrawShaderSystem;
@class EGShadowDrawShaderKey;
@class EGShadowDrawShader;

@interface EGShadowMap : EGSurface
@property (nonatomic, readonly) GLuint frameBuffer;
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
- (ODClassType*)type;
+ (EGShadowShader*)shaderForParam:(EGColorSource*)param;
+ (BOOL)isColorShaderForParam:(EGColorSource*)param;
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

+ (id)shadowDrawParamWithPercents:(id<CNSeq>)percents;
- (id)initWithPercents:(id<CNSeq>)percents;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderSystem : EGShaderSystem
- (ODClassType*)type;
+ (EGShader*)shaderForParam:(EGShadowDrawParam*)param;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;

+ (id)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount;
- (id)initWithDirectLightCount:(NSUInteger)directLightCount;
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


