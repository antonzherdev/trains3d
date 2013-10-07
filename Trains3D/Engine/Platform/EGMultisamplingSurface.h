#import "objd.h"
#import "EGSurface.h"
#import "GL.h"
#import "GEVec.h"
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


@interface EGMultisamplingSurface : EGSurface
@property (nonatomic, readonly) BOOL depth;

+ (id)multisamplingSurfaceWithSize:(GEVec2i)size depth:(BOOL)depth;
- (id)initWithSize:(GEVec2i)size depth:(BOOL)depth;
- (ODClassType*)type;
- (void)bind;
- (void)unbind;
- (GLint)frameBuffer;
- (EGTexture*)texture;
+ (ODClassType*)type;
@end



@interface EGViewportSurface : EGBaseViewportSurface
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) BOOL multisampling;

+ (id)viewportSurfaceWithDepth:(BOOL)depth multisampling:(BOOL)multisampling;
- (id)initWithDepth:(BOOL)depth multisampling:(BOOL)multisampling;
- (ODClassType*)type;
- (EGSurface*)createSurface;
- (void)drawWithZ:(float)z;
- (EGTexture*)texture;
- (void)draw;
+ (ODClassType*)type;
@end


