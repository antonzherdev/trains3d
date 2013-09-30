#import "objd.h"
#import "EGSurface.h"
#import "GL.h"
#import "GEVec.h"
@class EGTexture;
@class EGGlobal;
@class EGContext;

@class EGShadowMapSurface;
@class EGShadowMap;

@interface EGShadowMapSurface : EGSurface
@property (nonatomic, readonly) GLuint frameBuffer;
@property (nonatomic, readonly) EGTexture* texture;

+ (id)shadowMapSurfaceWithSize:(GEVec2i)size;
- (id)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGShadowMap : EGBaseViewportSurface
+ (id)shadowMap;
- (id)init;
- (ODClassType*)type;
- (EGSurface*)createSurface;
- (EGTexture*)texture;
+ (ODClassType*)type;
@end


