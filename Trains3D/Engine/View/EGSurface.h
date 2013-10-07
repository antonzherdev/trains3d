#import "objd.h"
#import "GEVec.h"
#import "GL.h"
#import "EGShader.h"
@class EGTexture;
@class EGVertexBufferDesc;
@class EGMesh;
@class EGGlobal;
@class EGContext;

@class EGSurface;
@class EGSimpleSurface;
@class EGViewportSurfaceShaderParam;
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
- (GLint)frameBuffer;
- (void)_init;
+ (ODClassType*)type;
@end


@interface EGSimpleSurface : EGSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GLuint frameBuffer;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)simpleSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth;
- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth;
- (ODClassType*)type;
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


@interface EGViewportSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* zUniform;

+ (id)viewportSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGViewportSurfaceShaderParam*)param;
- (void)unloadParam:(EGViewportSurfaceShaderParam*)param;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGBaseViewportSurface : NSObject
+ (id)baseViewportSurface;
- (id)init;
- (ODClassType*)type;
+ (EGMesh*)fullScreenMesh;
- (id)surface;
- (EGSurface*)createSurface;
- (BOOL)needRedraw;
- (void)bind;
- (void)applyDraw:(void(^)())draw;
- (void)maybeDraw:(void(^)())draw;
- (void)maybeForce:(BOOL)force draw:(void(^)())draw;
- (void)unbind;
+ (ODClassType*)type;
@end


