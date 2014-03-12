#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGTexture;
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGSettings;
@class EGShadowType;
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

@interface EGSurface : NSObject {
@private
    GEVec2i _size;
}
@property (nonatomic, readonly) GEVec2i size;

+ (instancetype)surfaceWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)applyDraw:(void(^)())draw;
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


@interface EGViewportSurfaceShaderParam : NSObject {
@private
    EGTexture* _texture;
    float _z;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) float z;

+ (instancetype)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z;
- (instancetype)initWithTexture:(EGTexture*)texture z:(float)z;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGViewportShaderBuilder : NSObject<EGShaderTextBuilder>
+ (instancetype)viewportShaderBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGViewportSurfaceShader : EGShader {
@private
    EGShaderAttribute* _positionSlot;
    EGShaderUniformF4* _zUniform;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformF4* zUniform;

+ (instancetype)viewportSurfaceShader;
- (instancetype)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGViewportSurfaceShaderParam*)param;
+ (EGViewportSurfaceShader*)instance;
+ (ODClassType*)type;
@end


@interface EGBaseViewportSurface : NSObject {
@private
    EGSurfaceRenderTarget*(^_createRenderTarget)(GEVec2i);
    id __surface;
    id __renderTarget;
}
@property (nonatomic, readonly) EGSurfaceRenderTarget*(^createRenderTarget)(GEVec2i);

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (instancetype)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
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


