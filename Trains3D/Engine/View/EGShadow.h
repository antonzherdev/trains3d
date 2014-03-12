#import "objd.h"
#import "EGSurface.h"
#import "GEVec.h"
#import "EGShader.h"
@class GEMat4;
@class EGTexture;
@class EGEmptyTexture;
@class EGGlobal;
@class EGContext;
@class EGVertexArray;
@class EGMesh;
@class EGColorSource;
@class EGCullFace;
@class EGVertexBufferDesc;
@class EGRenderTarget;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGEnvironment;
@class EGLight;
@class EGViewportSurface;

@class EGShadowMap;
@class EGShadowSurfaceShaderBuilder;
@class EGShadowSurfaceShader;
@class EGShadowShaderSystem;
@class EGShadowShaderText;
@class EGShadowShader;
@class EGShadowDrawParam;
@class EGShadowDrawShaderSystem;
@class EGShadowDrawShaderKey;
@class EGShadowDrawShader;

@interface EGShadowMap : EGSurface {
@private
    unsigned int _frameBuffer;
    GEMat4* _biasDepthCp;
    EGTexture* _texture;
    CNLazy* __lazy_shader;
    CNLazy* __lazy_vao;
}
@property (nonatomic, readonly) unsigned int frameBuffer;
@property (nonatomic, retain) GEMat4* biasDepthCp;
@property (nonatomic, readonly) EGTexture* texture;

+ (instancetype)shadowMapWithSize:(GEVec2i)size;
- (instancetype)initWithSize:(GEVec2i)size;
- (ODClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (void)draw;
+ (GEMat4*)biasMatrix;
+ (ODClassType*)type;
@end


@interface EGShadowSurfaceShaderBuilder : EGViewportShaderBuilder
+ (instancetype)shadowSurfaceShaderBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGShadowSurfaceShader : EGShader {
@private
    EGShaderAttribute* _positionSlot;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (instancetype)shadowSurfaceShader;
- (instancetype)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


@interface EGShadowShaderSystem : EGShaderSystem
+ (instancetype)shadowShaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (EGShadowShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (BOOL)isColorShaderForParam:(EGColorSource*)param;
+ (EGShadowShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGShadowShaderText : NSObject<EGShaderTextBuilder> {
@private
    BOOL _texture;
}
@property (nonatomic, readonly) BOOL texture;

+ (instancetype)shadowShaderTextWithTexture:(BOOL)texture;
- (instancetype)initWithTexture:(BOOL)texture;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGShadowShader : EGShader {
@private
    BOOL _texture;
    id _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    id _alphaTestLevelUniform;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) id alphaTestLevelUniform;

+ (instancetype)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (instancetype)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (EGShadowShader*)instanceForColor;
+ (EGShadowShader*)instanceForTexture;
+ (ODClassType*)type;
@end


@interface EGShadowDrawParam : NSObject {
@private
    id<CNSeq> _percents;
    id _viewportSurface;
}
@property (nonatomic, readonly) id<CNSeq> percents;
@property (nonatomic, readonly) id viewportSurface;

+ (instancetype)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface;
- (instancetype)initWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderSystem : EGShaderSystem
+ (instancetype)shadowDrawShaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (EGShadowDrawShader*)shaderForParam:(EGShadowDrawParam*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGShadowDrawShaderSystem*)instance;
+ (CNNotificationObserver*)settingsChangeObs;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShaderKey : NSObject<EGShaderTextBuilder> {
@private
    NSUInteger _directLightCount;
    BOOL _viewportSurface;
}
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL viewportSurface;

+ (instancetype)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (instancetype)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (ODClassType*)type;
- (EGShadowDrawShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsIn;
- (NSString*)lightsOut;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
+ (ODClassType*)type;
@end


@interface EGShadowDrawShader : EGShader {
@private
    EGShadowDrawShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mwcpUniform;
    id<CNImSeq> _directLightPercents;
    id<CNImSeq> _directLightDepthMwcp;
    id<CNImSeq> _directLightShadows;
}
@property (nonatomic, readonly) EGShadowDrawShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) id<CNImSeq> directLightPercents;
@property (nonatomic, readonly) id<CNImSeq> directLightDepthMwcp;
@property (nonatomic, readonly) id<CNImSeq> directLightShadows;

+ (instancetype)shadowDrawShaderWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (instancetype)initWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGShadowDrawParam*)param;
+ (ODClassType*)type;
@end


