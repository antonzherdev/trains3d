#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGTexture;
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGMesh;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGVertexArray;

@class EGSurface;
@class EGSurfaceRenderTarget;
@class EGSurfaceRenderTargetTexture;
@class EGSurfaceRenderTargetRenderBuffer;
@class EGRenderTargetSurface;
@class EGSimpleSurface;
@class EGViewportSurfaceShaderParam;
@class EGViewportShaderBuilder;
@class EGViewportSurfaceShader;
@class EGBaseViewportSurface;

@interface EGSurface : NSObject
@property (nonatomic, readonly) GEVec2i size;

+ (id)surfaceWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)applyDraw:(void(^)())draw;
- (void)bind;
- (void)unbind;
- (int)frameBuffer;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTarget : NSObject
@property (nonatomic, readonly) GEVec2i size;

+ (id)surfaceRenderTargetWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)link;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTargetTexture : EGSurfaceRenderTarget
@property (nonatomic, readonly) EGTexture* texture;

+ (id)surfaceRenderTargetTextureWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (id)initWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (ODClassType*)type;
+ (EGSurfaceRenderTargetTexture*)applySize:(GEVec2i)size;
- (void)link;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTargetRenderBuffer : EGSurfaceRenderTarget
@property (nonatomic, readonly) unsigned int renderBuffer;

+ (id)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (id)initWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (ODClassType*)type;
+ (EGSurfaceRenderTargetRenderBuffer*)applySize:(GEVec2i)size;
- (void)link;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface EGRenderTargetSurface : EGSurface
@property (nonatomic, readonly) EGSurfaceRenderTarget* renderTarget;

+ (id)renderTargetSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (id)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (ODClassType*)type;
- (EGTexture*)texture;
- (unsigned int)renderBuffer;
+ (ODClassType*)type;
@end


@interface EGSimpleSurface : EGRenderTargetSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) unsigned int frameBuffer;

+ (id)simpleSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (id)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (ODClassType*)type;
+ (EGSimpleSurface*)toTextureSize:(GEVec2i)size depth:(BOOL)depth;
+ (EGSimpleSurface*)toRenderBufferSize:(GEVec2i)size depth:(BOOL)depth;
- (void)_init;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGViewportSurfaceShaderParam : NSObject
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) float z;

+ (id)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z;
- (id)initWithTexture:(EGTexture*)texture z:(float)z;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGViewportShaderBuilder : NSObject<EGShaderTextBuilder>
+ (id)viewportShaderBuilder;
- (id)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGViewportSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformF4* zUniform;

+ (id)viewportSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGViewportSurfaceShaderParam*)param;
+ (EGViewportSurfaceShader*)instance;
+ (ODClassType*)type;
@end


@interface EGBaseViewportSurface : NSObject
@property (nonatomic, readonly) EGSurfaceRenderTarget*(^createRenderTarget)(GEVec2i);

+ (id)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (id)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (ODClassType*)type;
+ (EGMesh*)fullScreenMesh;
+ (EGVertexArray*)fullScreenVao;
- (id)surface;
- (EGSurfaceRenderTarget*)renderTarget;
- (EGRenderTargetSurface*)createSurface;
- (EGTexture*)texture;
- (unsigned int)renderBuffer;
- (BOOL)needRedraw;
- (void)bind;
- (void)applyDraw:(void(^)())draw;
- (void)maybeDraw:(void(^)())draw;
- (void)maybeForce:(BOOL)force draw:(void(^)())draw;
- (void)unbind;
+ (ODClassType*)type;
@end


