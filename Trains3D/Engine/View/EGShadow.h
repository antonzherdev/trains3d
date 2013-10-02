#import "objd.h"
#import "EGSurface.h"
#import "GL.h"
#import "GEVec.h"
#import "EGShader.h"
@class GEMat4;
@class EGTexture;
@class EGColorSource;
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGStandardShaderSystem;
@class EGContext;
@class EGEnvironment;
@class EGLight;
@class EGStandardShader;

@class EGShadowMap;
@class EGShadowSurfaceShader;
@class EGShadowShaderSystem;
@class EGShadowShader;
@class EGShadowSub;
@class EGShadowSubShaderSystem;
@class EGShadowSubShaderKey;
@class EGShadowSubShader;

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


@interface EGShadowSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (id)shadowSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
- (void)unloadParam:(EGViewportSurfaceShaderParam*)param;
+ (NSString*)fragment;
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
@property (nonatomic, readonly) EGShaderUniform* mvpUniform;
@property (nonatomic, readonly) id alphaTestLevelUniform;

+ (id)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (id)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param;
- (void)unloadParam:(EGColorSource*)param;
+ (EGShadowShader*)instanceForColor;
+ (EGShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGShadowSub : NSObject
@property (nonatomic, readonly) EGColorSource* color;
@property (nonatomic, readonly) id<CNSeq> percents;

+ (id)shadowSubWithColor:(EGColorSource*)color percents:(id<CNSeq>)percents;
- (id)initWithColor:(EGColorSource*)color percents:(id<CNSeq>)percents;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowSubShaderSystem : EGShaderSystem
+ (id)shadowSubShaderSystem;
- (id)init;
- (ODClassType*)type;
- (EGShader*)shaderForParam:(EGColorSource*)param;
+ (EGStandardShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGShadowSubShaderKey : NSObject
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL texture;

+ (id)shadowSubShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture;
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


@interface EGShadowSubShader : EGShader
@property (nonatomic, readonly) EGShadowSubShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) id diffuseTexture;
@property (nonatomic, readonly) EGShaderUniform* diffuseColorUniform;
@property (nonatomic, readonly) EGShaderUniform* mwcpUniform;
@property (nonatomic, readonly) id<CNSeq> directLightPercents;
@property (nonatomic, readonly) id<CNSeq> directLightDepthMwcp;
@property (nonatomic, readonly) id<CNSeq> directLightShadows;

+ (id)shadowSubShaderWithKey:(EGShadowSubShaderKey*)key program:(EGShaderProgram*)program;
- (id)initWithKey:(EGShadowSubShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGShadowSub*)param;
- (void)unloadParam:(EGShadowSub*)param;
+ (ODClassType*)type;
@end


