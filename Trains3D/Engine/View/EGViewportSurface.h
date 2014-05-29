#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGTexture;
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGContext;
@class EGMesh;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGVertexArray;
@class EGRenderTargetSurface;
@class EGSurfaceRenderTarget;
@class CNVar;
@class EGSurfaceRenderTargetTexture;
@class EGSurfaceRenderTargetRenderBuffer;

@class EGViewportSurfaceShaderParam;
@class EGViewportShaderBuilder;
@class EGViewportSurfaceShader;
@class EGBaseViewportSurface;

@interface EGViewportSurfaceShaderParam : NSObject {
@protected
    EGTexture* _texture;
    float _z;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) float z;

+ (instancetype)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z;
- (instancetype)initWithTexture:(EGTexture*)texture z:(float)z;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGViewportShaderBuilder : EGShaderTextBuilder_impl
+ (instancetype)viewportShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGViewportSurfaceShader : EGShader {
@protected
    EGShaderAttribute* _positionSlot;
    EGShaderUniformF4* _zUniform;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformF4* zUniform;

+ (instancetype)viewportSurfaceShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGViewportSurfaceShaderParam*)param;
- (NSString*)description;
+ (EGViewportSurfaceShader*)instance;
+ (CNClassType*)type;
@end


@interface EGBaseViewportSurface : NSObject {
@protected
    EGSurfaceRenderTarget*(^_createRenderTarget)(GEVec2i);
    EGRenderTargetSurface* __surface;
    EGSurfaceRenderTarget* __renderTarget;
}
@property (nonatomic, readonly) EGSurfaceRenderTarget*(^createRenderTarget)(GEVec2i);

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (instancetype)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (CNClassType*)type;
+ (EGMesh*)fullScreenMesh;
+ (EGVertexArray*)fullScreenVao;
- (EGRenderTargetSurface*)surface;
- (EGSurfaceRenderTarget*)renderTarget;
- (EGRenderTargetSurface*)createSurface;
- (EGTexture*)texture;
- (unsigned int)renderBuffer;
- (BOOL)needRedraw;
- (void)bind;
- (void)unbind;
- (NSString*)description;
+ (CNClassType*)type;
@end


