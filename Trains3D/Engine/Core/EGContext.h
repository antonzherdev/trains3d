#import "objd.h"
#import "GEVec.h"
@class EGMatrixStack;
@class EGTexture;
@class EGTextureFileFormat;
@class EGTextureFormat;
@class EGTextureFilter;
@class EGFont;
@class EGFileTexture;
@class EGBMFont;
@class EGTTFFont;
@class EGShaderProgram;
@protocol EGVertexBuffer;
@class EGShadowMap;
@class EGMatrixModel;
@class GEMat4;
@class EGMMatrixModel;

@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGCullFace;
@class EGRenderTarget;
@class EGSceneRenderTarget;
@class EGShadowRenderTarget;
@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@class EGSettings;
@class EGShadowType;

@interface EGGlobal : NSObject
- (ODClassType*)type;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGTexture*)compressedTextureForFile:(NSString*)file;
+ (EGTexture*)compressedTextureForFile:(NSString*)file filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat;
+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormat*)format filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat filter:(EGTextureFilter*)filter;
+ (EGTexture*)scaledTextureForName:(NSString*)name;
+ (EGTexture*)scaledTextureForName:(NSString*)name format:(EGTextureFormat*)format;
+ (EGFont*)fontWithName:(NSString*)name;
+ (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
+ (EGFont*)mainFontWithSize:(NSUInteger)size;
+ (EGContext*)context;
+ (EGSettings*)settings;
+ (EGMatrixStack*)matrix;
+ (ODClassType*)type;
@end


@interface EGContext : NSObject
@property (nonatomic) GEVec2i viewSize;
@property (nonatomic) BOOL ttf;
@property (nonatomic) CGFloat scale;
@property (nonatomic, retain) EGEnvironment* environment;
@property (nonatomic, readonly) EGMatrixStack* matrixStack;
@property (nonatomic, retain) EGRenderTarget* renderTarget;
@property (nonatomic) BOOL considerShadows;
@property (nonatomic) BOOL redrawShadows;
@property (nonatomic) BOOL redrawFrame;
@property (nonatomic) unsigned int defaultVertexArray;
@property (nonatomic, readonly) EGCullFace* cullFace;
@property (nonatomic, readonly) EGEnablingState* blend;
@property (nonatomic, readonly) EGEnablingState* depthTest;

+ (id)context;
- (id)init;
- (ODClassType*)type;
- (EGTexture*)textureForName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format scale:(CGFloat)scale filter:(EGTextureFilter*)filter;
- (EGFont*)fontWithName:(NSString*)name;
- (EGFont*)mainFontWithSize:(NSUInteger)size;
- (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
- (void)clear;
- (void)clearCache;
- (GERectI)viewport;
- (void)setViewport:(GERectI)viewport;
- (void)bindTextureTextureId:(unsigned int)textureId;
- (void)bindTextureTexture:(EGTexture*)texture;
- (void)bindTextureSlot:(unsigned int)slot target:(unsigned int)target texture:(EGTexture*)texture;
- (void)deleteTextureId:(unsigned int)id;
- (void)bindShaderProgramProgram:(EGShaderProgram*)program;
- (void)deleteShaderProgramId:(unsigned int)id;
- (void)bindRenderBufferId:(unsigned int)id;
- (void)deleteRenderBufferId:(unsigned int)id;
- (void)bindVertexBufferBuffer:(id<EGVertexBuffer>)buffer;
- (unsigned int)vertexBufferCount;
- (void)bindIndexBufferHandle:(unsigned int)handle;
- (void)deleteBufferId:(unsigned int)id;
- (void)bindVertexArrayHandle:(unsigned int)handle vertexCount:(unsigned int)vertexCount mutable:(BOOL)mutable;
- (void)deleteVertexArrayId:(unsigned int)id;
- (void)bindDefaultVertexArray;
- (void)checkBindDefaultVertexArray;
- (void)draw;
- (void)clearColorColor:(GEVec4)color;
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


@interface EGCullFace : NSObject
+ (id)cullFace;
- (id)init;
- (ODClassType*)type;
- (void)setValue:(unsigned int)value;
- (void)draw;
- (void)disabledF:(void(^)())f;
- (void)disable;
- (void)invertedF:(void(^)())f;
+ (ODClassType*)type;
@end


@interface EGRenderTarget : NSObject
+ (id)renderTarget;
- (id)init;
- (ODClassType*)type;
- (BOOL)isShadow;
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
- (BOOL)isShadow;
+ (EGShadowRenderTarget*)aDefault;
+ (ODClassType*)type;
@end


@interface EGEnvironment : NSObject
@property (nonatomic, readonly) GEVec4 ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;
@property (nonatomic, readonly) id<CNSeq> directLights;
@property (nonatomic, readonly) id<CNSeq> directLightsWithShadows;
@property (nonatomic, readonly) id<CNSeq> directLightsWithoutShadows;

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
+ (EGLight*)aDefault;
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


@interface EGSettings : NSObject
+ (id)settings;
- (id)init;
- (ODClassType*)type;
- (EGShadowType*)shadowType;
- (void)setShadowType:(EGShadowType*)shadowType;
+ (CNNotificationHandle*)shadowTypeChangedNotification;
+ (ODClassType*)type;
@end


@interface EGShadowType : ODEnum
@property (nonatomic, readonly) BOOL isOn;

- (BOOL)isOff;
+ (EGShadowType*)no;
+ (EGShadowType*)shadow2d;
+ (EGShadowType*)sample2d;
+ (NSArray*)values;
@end


