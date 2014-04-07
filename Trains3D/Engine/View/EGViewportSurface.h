#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGTexture;
@class EGGlobal;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGContext;
@class EGMesh;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGVertexArray;
@class EGRenderTargetSurface;
@class EGSurfaceRenderTarget;
@class ATVar;
@class EGSurfaceRenderTargetTexture;
@class EGSurfaceRenderTargetRenderBuffer;

@class EGViewportSurfaceShaderParam;
@class EGViewportShaderBuilder;
@class EGViewportSurfaceShader;
@class EGBaseViewportSurface;

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
    EGRenderTargetSurface* __surface;
    EGSurfaceRenderTarget* __renderTarget;
}
@property (nonatomic, readonly) EGSurfaceRenderTarget*(^createRenderTarget)(GEVec2i);

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (instancetype)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget;
- (ODClassType*)type;
+ (EGMesh*)fullScreenMesh;
+ (EGVertexArray*)fullScreenVao;
- (EGRenderTargetSurface*)surface;
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


