#import "objd.h"
#import "GEVec.h"
#import "GL.h"
#import "EGShader.h"
@class EGTexture;
@class EGVertexBuffer;
@class EGSimpleMaterial;
@class EGMesh;
@class EGGlobal;
@class EGContext;

@class EGSurface;
@class EGSimpleSurface;
@class EGMultisamplingSurface;
@class EGPairSurface;
@class EGFullScreenSurfaceShaderParam;
@class EGFullScreenSurfaceShader;
@class EGFullScreenSurface;

@interface EGSurface : NSObject
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GEVec2i size;

+ (id)surfaceWithDepth:(BOOL)depth size:(GEVec2i)size;
- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size;
- (ODClassType*)type;
- (void)applyDraw:(void(^)())draw;
- (void)bind;
- (void)unbind;
- (GLint)frameBuffer;
+ (ODClassType*)type;
@end


@interface EGSimpleSurface : EGSurface
@property (nonatomic, readonly) GLuint frameBuffer;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)simpleSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size;
- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGMultisamplingSurface : EGSurface
@property (nonatomic, readonly) GLuint frameBuffer;

+ (id)multisamplingSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size;
- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGPairSurface : EGSurface
@property (nonatomic, readonly) EGMultisamplingSurface* multisampling;
@property (nonatomic, readonly) EGSimpleSurface* simple;

+ (id)pairSurfaceWithDepth:(BOOL)depth size:(GEVec2i)size;
- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size;
- (ODClassType*)type;
- (void)bind;
- (void)unbind;
- (GLint)frameBuffer;
- (EGTexture*)texture;
+ (ODClassType*)type;
@end


@interface EGFullScreenSurfaceShaderParam : NSObject
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) float z;

+ (id)fullScreenSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z;
- (id)initWithTexture:(EGTexture*)texture z:(float)z;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFullScreenSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* zUniform;

+ (id)fullScreenSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(EGFullScreenSurfaceShaderParam*)param;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGFullScreenSurface : NSObject
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) BOOL multisampling;

+ (id)fullScreenSurfaceWithDepth:(BOOL)depth multisampling:(BOOL)multisampling;
- (id)initWithDepth:(BOOL)depth multisampling:(BOOL)multisampling;
- (ODClassType*)type;
- (BOOL)needRedraw;
- (void)bind;
- (void)applyDraw:(void(^)())draw;
- (void)maybeDraw:(void(^)())draw;
- (void)maybeForce:(BOOL)force draw:(void(^)())draw;
- (void)unbind;
- (void)drawWithZ:(float)z;
- (EGTexture*)texture;
- (void)draw;
+ (ODClassType*)type;
@end


