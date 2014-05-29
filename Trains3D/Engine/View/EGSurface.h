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
@protected
    GEVec2i _size;
}
@property (nonatomic, readonly) GEVec2i size;

+ (instancetype)surfaceWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (CNClassType*)type;
- (void)bind;
- (void)unbind;
- (int)frameBuffer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSurfaceRenderTarget : NSObject {
@protected
    GEVec2i _size;
}
@property (nonatomic, readonly) GEVec2i size;

+ (instancetype)surfaceRenderTargetWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (CNClassType*)type;
- (void)link;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSurfaceRenderTargetTexture : EGSurfaceRenderTarget {
@protected
    EGTexture* _texture;
}
@property (nonatomic, readonly) EGTexture* texture;

+ (instancetype)surfaceRenderTargetTextureWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (instancetype)initWithTexture:(EGTexture*)texture size:(GEVec2i)size;
- (CNClassType*)type;
+ (EGSurfaceRenderTargetTexture*)applySize:(GEVec2i)size;
- (void)link;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSurfaceRenderTargetRenderBuffer : EGSurfaceRenderTarget {
@protected
    unsigned int _renderBuffer;
}
@property (nonatomic, readonly) unsigned int renderBuffer;

+ (instancetype)surfaceRenderTargetRenderBufferWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (instancetype)initWithRenderBuffer:(unsigned int)renderBuffer size:(GEVec2i)size;
- (CNClassType*)type;
+ (EGSurfaceRenderTargetRenderBuffer*)applySize:(GEVec2i)size;
- (void)link;
- (void)dealloc;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGRenderTargetSurface : EGSurface {
@protected
    EGSurfaceRenderTarget* _renderTarget;
}
@property (nonatomic, readonly) EGSurfaceRenderTarget* renderTarget;

+ (instancetype)renderTargetSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget;
- (CNClassType*)type;
- (EGTexture*)texture;
- (unsigned int)renderBuffer;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSimpleSurface : EGRenderTargetSurface {
@protected
    BOOL _depth;
    unsigned int _frameBuffer;
    unsigned int _depthRenderBuffer;
}
@property (nonatomic, readonly) BOOL depth;
@property (nonatomic, readonly) unsigned int frameBuffer;

+ (instancetype)simpleSurfaceWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (instancetype)initWithRenderTarget:(EGSurfaceRenderTarget*)renderTarget depth:(BOOL)depth;
- (CNClassType*)type;
+ (EGSimpleSurface*)toTextureSize:(GEVec2i)size depth:(BOOL)depth;
+ (EGSimpleSurface*)toRenderBufferSize:(GEVec2i)size depth:(BOOL)depth;
- (void)_init;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (NSString*)description;
+ (CNClassType*)type;
@end


