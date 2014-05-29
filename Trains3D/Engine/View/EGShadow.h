#import "objd.h"
#import "EGSurface.h"
#import "GEVec.h"
#import "EGViewportSurface.h"
#import "EGShader.h"
#import "EGContext.h"
@class GEMat4;
@class EGTexture;
@class EGEmptyTexture;
@class EGVertexArray;
@class EGMesh;
@class EGDirector;
@class EGColorSource;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGViewportSurface;
@class CNObserver;
@class CNSignal;
@class CNChain;

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
@protected
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
- (CNClassType*)type;
- (void)dealloc;
- (void)bind;
- (void)unbind;
- (void)draw;
- (NSString*)description;
+ (GEMat4*)biasMatrix;
+ (CNClassType*)type;
@end


@interface EGShadowSurfaceShaderBuilder : EGViewportShaderBuilder
+ (instancetype)shadowSurfaceShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)fragment;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShadowSurfaceShader : EGShader {
@protected
    EGShaderAttribute* _positionSlot;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;

+ (instancetype)shadowSurfaceShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShadowShaderSystem : EGShaderSystem
+ (instancetype)shadowShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (EGShadowShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (BOOL)isColorShaderForParam:(EGColorSource*)param;
- (NSString*)description;
+ (EGShadowShaderSystem*)instance;
+ (CNClassType*)type;
@end


@interface EGShadowShaderText : EGShaderTextBuilder_impl {
@protected
    BOOL _texture;
}
@property (nonatomic, readonly) BOOL texture;

+ (instancetype)shadowShaderTextWithTexture:(BOOL)texture;
- (instancetype)initWithTexture:(BOOL)texture;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShadowShader : EGShader {
@protected
    BOOL _texture;
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    EGShaderUniformF4* _alphaTestLevelUniform;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) EGShaderUniformF4* alphaTestLevelUniform;

+ (instancetype)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (instancetype)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
- (NSString*)description;
+ (EGShadowShader*)instanceForColor;
+ (EGShadowShader*)instanceForTexture;
+ (CNClassType*)type;
@end


@interface EGShadowDrawParam : NSObject {
@protected
    id<CNSeq> _percents;
    EGViewportSurface* _viewportSurface;
}
@property (nonatomic, readonly) id<CNSeq> percents;
@property (nonatomic, readonly) EGViewportSurface* viewportSurface;

+ (instancetype)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(EGViewportSurface*)viewportSurface;
- (instancetype)initWithPercents:(id<CNSeq>)percents viewportSurface:(EGViewportSurface*)viewportSurface;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShadowDrawShaderSystem : EGShaderSystem
+ (instancetype)shadowDrawShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
- (EGShadowDrawShader*)shaderForParam:(EGShadowDrawParam*)param renderTarget:(EGRenderTarget*)renderTarget;
- (NSString*)description;
+ (EGShadowDrawShaderSystem*)instance;
+ (CNObserver*)settingsChangeObs;
+ (CNClassType*)type;
@end


@interface EGShadowDrawShaderKey : EGShaderTextBuilder_impl {
@protected
    NSUInteger _directLightCount;
    BOOL _viewportSurface;
}
@property (nonatomic, readonly) NSUInteger directLightCount;
@property (nonatomic, readonly) BOOL viewportSurface;

+ (instancetype)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (instancetype)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface;
- (CNClassType*)type;
- (EGShadowDrawShader*)shader;
- (NSString*)lightsVertexUniform;
- (NSString*)lightsIn;
- (NSString*)lightsOut;
- (NSString*)lightsCalculateVaryings;
- (NSString*)lightsFragmentUniform;
- (NSString*)lightsDiffuse;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGShadowDrawShader : EGShader {
@protected
    EGShadowDrawShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mwcpUniform;
    NSArray* _directLightPercents;
    NSArray* _directLightDepthMwcp;
    NSArray* _directLightShadows;
}
@property (nonatomic, readonly) EGShadowDrawShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mwcpUniform;
@property (nonatomic, readonly) NSArray* directLightPercents;
@property (nonatomic, readonly) NSArray* directLightDepthMwcp;
@property (nonatomic, readonly) NSArray* directLightShadows;

+ (instancetype)shadowDrawShaderWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (instancetype)initWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGShadowDrawParam*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


