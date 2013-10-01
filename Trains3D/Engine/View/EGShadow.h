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

@class EGShadowMap;
@class EGShadowSurfaceShader;
@class EGShadowShaderSystem;
@class EGShadowShader;

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


