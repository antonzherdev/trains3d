#import "objd.h"
#import "GEVec.h"
#import "GL.h"
#import "EGShader.h"
@class EGTexture;
@class EGSimpleMaterial;
@class EGColorSource;
@class EGColorSourceTexture;
@class EGVertexBuffer;
@class EGMesh;
@class EGGlobal;
@class EGContext;

@class EGSurface;
@class EGFullScreenSurfaceShader;
@class EGFullScreenSurface;

@interface EGSurface : NSObject
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GEVec2i size;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGSimpleMaterial* material;

+ (id)surfaceWithDepth:(BOOL)depth size:(GEVec2i)size;
- (id)initWithDepth:(BOOL)depth size:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)applyDraw:(void(^)())draw;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGFullScreenSurfaceShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (id)fullScreenSurfaceShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material;
- (void)unloadMaterial:(EGSimpleMaterial*)material;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGFullScreenSurface : NSObject
@property (nonatomic, readonly) BOOL depth;

+ (id)fullScreenSurfaceWithDepth:(BOOL)depth;
- (id)initWithDepth:(BOOL)depth;
- (ODClassType*)type;
- (BOOL)needRedraw;
- (void)bind;
- (void)applyDraw:(void(^)())draw;
- (void)maybeDraw:(void(^)())draw;
- (void)maybeForce:(BOOL)force draw:(void(^)())draw;
- (void)unbind;
- (void)draw;
+ (ODClassType*)type;
@end


