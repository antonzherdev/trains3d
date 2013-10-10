#import "objd.h"
#import "GL.h"
#import "GEVec.h"
@class EGDirector;
@class EGTexture;
@class EGFont;
@protocol EGVertexSource;
@class EGFileTexture;
@class EGShaderProgram;
@class EGVertexBuffer;
@class EGShadowMap;
@class GEMat4;

@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGRenderTarget;
@class EGSceneRenderTarget;
@class EGShadowRenderTarget;
@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@class EGMatrixStack;
@class EGMatrixModel;

@interface EGGlobal : NSObject
- (ODClassType*)type;
+ (EGDirector*)director;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGTexture*)nearestTextureForFile:(NSString*)file;
+ (EGTexture*)textureForFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter;
+ (EGFont*)fontWithName:(NSString*)name;
+ (EGContext*)context;
+ (EGMatrixStack*)matrix;
+ (ODClassType*)type;
@end


@interface EGContext : NSObject
@property (nonatomic) GLint defaultFramebuffer;
@property (nonatomic, retain) EGDirector* director;
@property (nonatomic, retain) EGEnvironment* environment;
@property (nonatomic, readonly) EGMatrixStack* matrixStack;
@property (nonatomic, retain) EGRenderTarget* renderTarget;
@property (nonatomic) BOOL considerShadows;
@property (nonatomic) GLuint defaultVertexArray;
@property (nonatomic, readonly) EGEnablingState* cullFace;
@property (nonatomic, readonly) EGEnablingState* blend;
@property (nonatomic, readonly) EGEnablingState* depthTest;

+ (id)context;
- (id)init;
- (ODClassType*)type;
- (EGTexture*)textureForFile:(NSString*)file magFilter:(unsigned int)magFilter minFilter:(unsigned int)minFilter;
- (EGFont*)fontWithName:(NSString*)name;
- (void)clear;
- (GERectI)viewport;
- (void)setViewport:(GERectI)viewport;
- (void)pushViewport;
- (void)popViewport;
- (void)restoreDefaultFramebuffer;
- (void)bindTextureTexture:(EGTexture*)texture;
- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(EGTexture*)texture;
- (void)bindShaderProgramProgram:(EGShaderProgram*)program;
- (void)bindVertexBufferBuffer:(EGVertexBuffer*)buffer;
- (id<EGVertexSource>)vertexSource;
- (void)bindIndexBufferHandle:(GLuint)handle;
- (void)bindVertexArrayHandle:(GLuint)handle;
- (void)bindDefaultVertexArray;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGEnablingState : NSObject
@property (nonatomic, readonly) unsigned int tp;

+ (id)enablingStateWithTp:(unsigned int)tp;
- (id)initWithTp:(unsigned int)tp;
- (ODClassType*)type;
- (void)enable;
- (void)disable;
- (void)draw;
- (void)clear;
- (void)disabledF:(void(^)())f;
- (void)enabledF:(void(^)())f;
+ (ODClassType*)type;
@end


@interface EGRenderTarget : NSObject
+ (id)renderTarget;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGSceneRenderTarget : EGRenderTarget
+ (id)sceneRenderTarget;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowRenderTarget : EGRenderTarget
@property (nonatomic, readonly) EGLight* shadowLight;

+ (id)shadowRenderTargetWithShadowLight:(EGLight*)shadowLight;
- (id)initWithShadowLight:(EGLight*)shadowLight;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEnvironment : NSObject
@property (nonatomic, readonly) GEVec4 ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;

+ (id)environmentWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (id)initWithAmbientColor:(GEVec4)ambientColor lights:(id<CNSeq>)lights;
- (ODClassType*)type;
+ (EGEnvironment*)applyLights:(id<CNSeq>)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
+ (EGEnvironment*)aDefault;
+ (ODClassType*)type;
@end


@interface EGLight : NSObject
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) BOOL hasShadows;

+ (id)lightWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (id)initWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (ODClassType*)type;
- (EGShadowMap*)shadowMap;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
+ (ODClassType*)type;
@end


@interface EGDirectLight : EGLight
@property (nonatomic, readonly) GEVec3 direction;
@property (nonatomic, readonly) GEMat4* shadowsProjectionMatrix;

+ (id)directLightWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (id)initWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (ODClassType*)type;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
+ (ODClassType*)type;
@end


@interface EGMatrixStack : NSObject
@property (nonatomic, retain) EGMatrixModel* value;

+ (id)matrixStack;
- (id)init;
- (ODClassType*)type;
- (void)clear;
- (void)push;
- (void)pop;
- (void)applyModify:(EGMatrixModel*(^)(EGMatrixModel*))modify f:(void(^)())f;
- (GEMat4*)m;
- (GEMat4*)w;
- (GEMat4*)c;
- (GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)wc;
- (GEMat4*)wcp;
- (GEMat4*)cp;
+ (ODClassType*)type;
@end


@interface EGMatrixModel : NSObject
@property (nonatomic, readonly) GEMat4* m;
@property (nonatomic, readonly) GEMat4* w;
@property (nonatomic, readonly) GEMat4* c;
@property (nonatomic, readonly) GEMat4* p;
@property (nonatomic, readonly) CNLazy* _mw;
@property (nonatomic, readonly) CNLazy* _mwc;
@property (nonatomic, readonly) CNLazy* _mwcp;
@property (nonatomic, readonly) CNLazy* _cp;
@property (nonatomic, readonly) CNLazy* _wcp;
@property (nonatomic, readonly) CNLazy* _wc;

+ (id)matrixModelWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (id)initWithM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p _mw:(CNLazy*)_mw _mwc:(CNLazy*)_mwc _mwcp:(CNLazy*)_mwcp _cp:(CNLazy*)_cp _wcp:(CNLazy*)_wcp _wc:(CNLazy*)_wc;
- (ODClassType*)type;
+ (EGMatrixModel*)applyM:(GEMat4*)m w:(GEMat4*)w c:(GEMat4*)c p:(GEMat4*)p;
- (GEMat4*)mw;
- (GEMat4*)mwc;
- (GEMat4*)mwcp;
- (GEMat4*)cp;
- (GEMat4*)wcp;
- (GEMat4*)wc;
- (EGMatrixModel*)modifyM:(GEMat4*(^)(GEMat4*))m;
- (EGMatrixModel*)modifyW:(GEMat4*(^)(GEMat4*))w;
- (EGMatrixModel*)modifyC:(GEMat4*(^)(GEMat4*))c;
- (EGMatrixModel*)modifyP:(GEMat4*(^)(GEMat4*))p;
+ (EGMatrixModel*)identity;
+ (ODClassType*)type;
@end


