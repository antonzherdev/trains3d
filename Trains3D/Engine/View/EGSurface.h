#import "objd.h"
#import "GEVec.h"
#import "GL.h"
#import "EGShader.h"
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGTexture;
@class EGVertexBufferDesc;
@class EGMesh;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGVertexArray;

@class EGSurface;
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
- (void)_init;
+ (ODClassType*)type;
@end


@interface EGSimpleSurface : EGSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GLuint frameBuffer;
@property (nonatomic, readonly) EGEmptyTexture* texture;

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
+ (id)baseViewportSurface;
- (id)init;
- (ODClassType*)type;
+ (EGMesh*)fullScreenMesh;
+ (EGVertexArray*)fullScreenVao;
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


