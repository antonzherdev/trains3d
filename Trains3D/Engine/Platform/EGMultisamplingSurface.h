#import "objd.h"
#import "EGSurface.h"
#import "GL.h"
#import "GEVec.h"
#import "EGViewportSurface.h"

@class EGTexture;

@class EGFirstMultisamplingSurface;

@interface EGFirstMultisamplingSurface : EGSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) GLuint frameBuffer;

+ (id)firstMultisamplingSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth;
- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGMultisamplingSurface : EGRenderTargetSurface
@property (nonatomic, readonly) BOOL depth;

+ (id)multisamplingSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (id)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (ODClassType*)type;
- (void)bind;
- (void)unbind;
- (GLint)frameBuffer;
+ (ODClassType*)type;
@end



@interface EGViewportSurface : EGBaseViewportSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) BOOL multisampling;

+ (id)viewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling;
- (id)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget depth:(BOOL)depth multisampling:(BOOL)multisampling;
- (ODClassType*)type;
- (void)drawWithZ:(float)z;
- (void)draw;
+ (ODClassType*)type;

+ (EGViewportSurface *)toTextureDepth:(BOOL)depth multisampling:(BOOL)multisampling;
+ (EGViewportSurface *)toRenderBufferDepth:(BOOL)depth multisampling:(BOOL)multisampling;
@end


