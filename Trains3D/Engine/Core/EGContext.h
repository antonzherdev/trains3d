#import "objd.h"
#import "GEVec.h"
@class EGMatrixStack;
@class EGTexture;
@class EGTextureFileFormat;
@class EGTextureFormat;
@class EGTextureFilter;
@class EGDirector;
@class EGFont;
@class ATVar;
@class ATReact;
@class EGBlendFunction;
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
+ (EGTexture*)compressedTextureForFile:(NSString*)file;
+ (EGTexture*)compressedTextureForFile:(NSString*)file filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormat*)fileFormat;
+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormat*)format filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormat*)format;
+ (EGTexture*)textureForFile:(NSString*)file filter:(EGTextureFilter*)filter;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat format:(EGTextureFormat*)format;
+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormat*)fileFormat;
+ (EGTexture*)scaledTextureForName:(NSString*)name format:(EGTextureFormat*)format;
+ (EGTexture*)scaledTextureForName:(NSString*)name;
+ (EGFont*)fontWithName:(NSString*)name;
+ (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
+ (EGFont*)mainFontWithSize:(NSUInteger)size;
+ (EGContext*)context;
+ (EGSettings*)settings;
+ (EGMatrixStack*)matrix;
+ (ODClassType*)type;
@end


@interface EGContext : NSObject {
@private
    ATVar* _viewSize;
    ATReact* _scaledViewSize;
    BOOL _ttf;
    NSMutableDictionary* _textureCache;
    NSMutableDictionary* _fontCache;
    EGEnvironment* _environment;
    EGMatrixStack* _matrixStack;
    EGRenderTarget* _renderTarget;
    BOOL _considerShadows;
    BOOL _redrawShadows;
    BOOL _redrawFrame;
    GERectI __viewport;
    unsigned int __lastTexture2D;
    NSMutableDictionary* __lastTextures;
    unsigned int __lastShaderProgram;
    unsigned int __lastRenderBuffer;
    unsigned int __lastVertexBufferId;
    unsigned int __lastVertexBufferCount;
    unsigned int __lastIndexBuffer;
    unsigned int __lastVertexArray;
    unsigned int _defaultVertexArray;
    BOOL __needBindDefaultVertexArray;
    EGCullFace* _cullFace;
    EGEnablingState* _blend;
    EGEnablingState* _depthTest;
    GEVec4 __lastClearColor;
    EGBlendFunction* __blendFunction;
    EGBlendFunction* __blendFunctionComing;
    BOOL __blendFunctionChanged;
}
@property (nonatomic, readonly) ATVar* viewSize;
@property (nonatomic, readonly) ATReact* scaledViewSize;
@property (nonatomic) BOOL ttf;
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

+ (instancetype)context;
- (instancetype)init;
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
- (EGBlendFunction*)blendFunction;
- (void)setBlendFunction:(EGBlendFunction*)blendFunction;
+ (ODClassType*)type;
@end


@interface EGEnablingState : NSObject {
@private
    unsigned int _tp;
    BOOL __last;
    BOOL __coming;
}
@property (nonatomic, readonly) unsigned int tp;

+ (instancetype)enablingStateWithTp:(unsigned int)tp;
- (instancetype)initWithTp:(unsigned int)tp;
- (ODClassType*)type;
- (BOOL)enable;
- (BOOL)disable;
- (void)draw;
- (void)clear;
+ (ODClassType*)type;
@end


@interface EGCullFace : NSObject {
@private
    unsigned int __lastActiveValue;
    unsigned int __value;
    unsigned int __comingValue;
}
+ (instancetype)cullFace;
- (instancetype)init;
- (ODClassType*)type;
- (void)setValue:(unsigned int)value;
- (void)draw;
- (unsigned int)disable;
- (unsigned int)invert;
+ (ODClassType*)type;
@end


@interface EGRenderTarget : NSObject
+ (instancetype)renderTarget;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)isShadow;
+ (ODClassType*)type;
@end


@interface EGSceneRenderTarget : EGRenderTarget
+ (instancetype)sceneRenderTarget;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGShadowRenderTarget : EGRenderTarget {
@private
    EGLight* _shadowLight;
}
@property (nonatomic, readonly) EGLight* shadowLight;

+ (instancetype)shadowRenderTargetWithShadowLight:(EGLight*)shadowLight;
- (instancetype)initWithShadowLight:(EGLight*)shadowLight;
- (ODClassType*)type;
- (BOOL)isShadow;
+ (EGShadowRenderTarget*)aDefault;
+ (ODClassType*)type;
@end


@interface EGEnvironment : NSObject {
@private
    GEVec4 _ambientColor;
    NSArray* _lights;
    NSArray* _directLights;
    NSArray* _directLightsWithShadows;
    NSArray* _directLightsWithoutShadows;
}
@property (nonatomic, readonly) GEVec4 ambientColor;
@property (nonatomic, readonly) NSArray* lights;
@property (nonatomic, readonly) NSArray* directLights;
@property (nonatomic, readonly) NSArray* directLightsWithShadows;
@property (nonatomic, readonly) NSArray* directLightsWithoutShadows;

+ (instancetype)environmentWithAmbientColor:(GEVec4)ambientColor lights:(NSArray*)lights;
- (instancetype)initWithAmbientColor:(GEVec4)ambientColor lights:(NSArray*)lights;
- (ODClassType*)type;
+ (EGEnvironment*)applyLights:(NSArray*)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
+ (EGEnvironment*)aDefault;
+ (ODClassType*)type;
@end


@interface EGLight : NSObject {
@private
    GEVec4 _color;
    BOOL _hasShadows;
    CNLazy* __lazy_shadowMap;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) BOOL hasShadows;

+ (instancetype)lightWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (instancetype)initWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (ODClassType*)type;
- (EGShadowMap*)shadowMap;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
+ (EGLight*)aDefault;
+ (ODClassType*)type;
@end


@interface EGDirectLight : EGLight {
@private
    GEVec3 _direction;
    GEMat4* _shadowsProjectionMatrix;
}
@property (nonatomic, readonly) GEVec3 direction;
@property (nonatomic, readonly) GEMat4* shadowsProjectionMatrix;

+ (instancetype)directLightWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (instancetype)initWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (ODClassType*)type;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
+ (ODClassType*)type;
@end


@interface EGSettings : NSObject {
@private
    EGShadowType* __shadowType;
}
+ (instancetype)settings;
- (instancetype)init;
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


