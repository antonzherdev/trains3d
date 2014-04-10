#import "objd.h"
#import "GEVec.h"
@class EGTexture;
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGDirector;

@class EGSurface;
@class EGSurfaceRenderTarget;
@class EGSurfaceRenderTargetTexture;
@class EGSurfaceRenderTargetRenderBuffer;
@class EGRenderTargetSurface;
@class EGSimpleSurface;

@interface EGSurface : NSObject {
@private
    GEVec2i _size;
}
@property (nonatomic, readonly) GEVec2i size;

+ (instancetype)surfaceWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)bind;
- (void)unbind;
- (int)frameBuffer;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTarget : NSObject {
@private
    GEVec2i _size;
}
@property (nonatomic, readonly) GEVec2i size;

+ (instancetype)surfaceRenderTargetWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)link;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTargetTexture : EGSurfaceRenderTarget {
@private
    EGTexture* _texture;
}
@property (nonatomic, readonly) EGTexture* texture;

+ (instancetype)surfaceRenderTargetTextureWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (instancetype)initWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (ODClassType*)type;
+ (EGSurfaceRenderTargetTexture*)applySize:(GEVec2i)size;
- (void)link;
+ (ODClassType*)type;
@end


@interface EGSurfaceRenderTargetRenderBuffer : EGSurfaceRenderTarget {
@private
    unsigned int _renderBuffer;
}
@property (nonatomic, readonly) unsigned int renderBuffer;

+ (instancetype)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (instancetype)initWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (ODClassType*)type;
+ (EGSurfaceRenderTargetRenderBuffer*)applySize:(GEVec2i)size;
- (void)link;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface EGRenderTargetSurface : EGSurface {
@private
    EGSurfaceRenderTarget* _renderTarget;
}
@property (nonatomic, readonly) EGSurfaceRenderTarget* renderTarget;

+ (instancetype)renderTargetSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (ODClassType*)type;
- (EGTexture*)texture;
- (unsigned int)renderBuffer;
+ (ODClassType*)type;
@end


@interface EGSimpleSurface : EGRenderTargetSurface {
@private
    BOOL _depth;
    unsigned int _frameBuffer;
    unsigned int _depthRenderBuffer;
}
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) unsigned int frameBuffer;

+ (instancetype)simpleSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (ODClassType*)type;
+ (EGSimpleSurface*)toTextureSize:(GEVec2i)size depth:(BOOL)depth;
+ (EGSimpleSurface*)toRenderBufferSize:(GEVec2i)size depth:(BOOL)depth;
- (void)_init;
- (void)dealloc;
- (void)bind;
- (void)unbind;
+ (ODClassType*)type;
@end


