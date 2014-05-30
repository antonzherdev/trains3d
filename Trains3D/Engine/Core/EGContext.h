#import "objd.h"
#import "EGTexture.h"
#import "GEVec.h"
@class EGMatrixStack;
@class EGDirector;
@class EGFont;
@class CNVar;
@class CNReact;
@class EGBlendFunction;
@class EGBMFont;
@class EGTTFFont;
@class EGShaderProgram;
@protocol EGVertexBuffer;
@class CNChain;
@class EGShadowMap;
@class EGMatrixModel;
@class GEMat4;
@class EGMMatrixModel;
@class CNSignal;

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

typedef enum EGShadowTypeR {
    EGShadowType_Nil = 0,
    EGShadowType_no = 1,
    EGShadowType_shadow2d = 2,
    EGShadowType_sample2d = 3
} EGShadowTypeR;
@interface EGShadowType : CNEnum
@property (nonatomic, readonly) BOOL isOn;

- (BOOL)isOff;
+ (NSArray*)values;
@end
extern EGShadowType* EGShadowType_Values[4];
extern EGShadowType* EGShadowType_no_Desc;
extern EGShadowType* EGShadowType_shadow2d_Desc;
extern EGShadowType* EGShadowType_sample2d_Desc;


@interface EGGlobal : NSObject
- (CNClassType*)type;
+ (EGTexture*)compressedTextureForFile:(NSString*)file;
+ (EGTexture*)compressedTextureForFile:(NSString*)file filter:(EGTextureFilterR)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format filter:(EGTextureFilterR)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat filter:(EGTextureFilterR)filter;
+ (EGTexture*)textureForFile:(NSString*)file fileFormat:(EGTextureFileFormatR)fileFormat;
+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormatR)format filter:(EGTextureFilterR)filter;
+ (EGTexture*)textureForFile:(NSString*)file format:(EGTextureFormatR)format;
+ (EGTexture*)textureForFile:(NSString*)file filter:(EGTextureFilterR)filter;
+ (EGTexture*)textureForFile:(NSString*)file;
+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format;
+ (EGTexture*)scaledTextureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat;
+ (EGTexture*)scaledTextureForName:(NSString*)name format:(EGTextureFormatR)format;
+ (EGTexture*)scaledTextureForName:(NSString*)name;
+ (EGFont*)fontWithName:(NSString*)name;
+ (EGFont*)fontWithName:(NSString*)name size:(NSUInteger)size;
+ (EGFont*)mainFontWithSize:(NSUInteger)size;
+ (EGContext*)context;
+ (EGSettings*)settings;
+ (EGMatrixStack*)matrix;
+ (CNClassType*)type;
@end


@interface EGContext : NSObject {
@protected
    CNVar* _viewSize;
    CNReact* _scaledViewSize;
    BOOL _ttf;
    CNMHashMap* _textureCache;
    CNMHashMap* _fontCache;
    EGEnvironment* _environment;
    EGMatrixStack* _matrixStack;
    EGRenderTarget* _renderTarget;
    BOOL _considerShadows;
    BOOL _redrawShadows;
    BOOL _redrawFrame;
    GERectI __viewport;
    unsigned int __lastTexture2D;
    CNMHashMap* __lastTextures;
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
@property (nonatomic, readonly) CNVar* viewSize;
@property (nonatomic, readonly) CNReact* scaledViewSize;
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
- (CNClassType*)type;
- (EGTexture*)textureForName:(NSString*)name fileFormat:(EGTextureFileFormatR)fileFormat format:(EGTextureFormatR)format scale:(CGFloat)scale filter:(EGTextureFilterR)filter;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGEnablingState : NSObject {
@protected
    unsigned int _tp;
    BOOL __last;
    BOOL __coming;
}
@property (nonatomic, readonly) unsigned int tp;

+ (instancetype)enablingStateWithTp:(unsigned int)tp;
- (instancetype)initWithTp:(unsigned int)tp;
- (CNClassType*)type;
- (BOOL)enable;
- (BOOL)disable;
- (void)draw;
- (void)clear;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGCullFace : NSObject {
@protected
    unsigned int __lastActiveValue;
    unsigned int __value;
    unsigned int __comingValue;
}
+ (instancetype)cullFace;
- (instancetype)init;
- (CNClassType*)type;
- (void)setValue:(unsigned int)value;
- (void)draw;
- (unsigned int)disable;
- (unsigned int)invert;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGRenderTarget : NSObject
+ (instancetype)renderTarget;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)isShadow;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSceneRenderTarget : EGRenderTarget
+ (instancetype)sceneRenderTarget;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGShadowRenderTarget : EGRenderTarget {
@protected
    EGLight* _shadowLight;
}
@property (nonatomic, readonly) EGLight* shadowLight;

+ (instancetype)shadowRenderTargetWithShadowLight:(EGLight*)shadowLight;
- (instancetype)initWithShadowLight:(EGLight*)shadowLight;
- (CNClassType*)type;
- (BOOL)isShadow;
- (NSString*)description;
+ (EGShadowRenderTarget*)aDefault;
+ (CNClassType*)type;
@end


@interface EGEnvironment : NSObject {
@protected
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
- (CNClassType*)type;
+ (EGEnvironment*)applyLights:(NSArray*)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
- (NSString*)description;
+ (EGEnvironment*)aDefault;
+ (CNClassType*)type;
@end


@interface EGLight : NSObject {
@protected
    GEVec4 _color;
    BOOL _hasShadows;
    CNLazy* __lazy_shadowMap;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) BOOL hasShadows;

+ (instancetype)lightWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (instancetype)initWithColor:(GEVec4)color hasShadows:(BOOL)hasShadows;
- (CNClassType*)type;
- (EGShadowMap*)shadowMap;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
- (NSString*)description;
+ (EGLight*)aDefault;
+ (CNClassType*)type;
@end


@interface EGDirectLight : EGLight {
@protected
    GEVec3 _direction;
    GEMat4* _shadowsProjectionMatrix;
}
@property (nonatomic, readonly) GEVec3 direction;
@property (nonatomic, readonly) GEMat4* shadowsProjectionMatrix;

+ (instancetype)directLightWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (instancetype)initWithColor:(GEVec4)color direction:(GEVec3)direction hasShadows:(BOOL)hasShadows shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (CNClassType*)type;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction;
+ (EGDirectLight*)applyColor:(GEVec4)color direction:(GEVec3)direction shadowsProjectionMatrix:(GEMat4*)shadowsProjectionMatrix;
- (EGMatrixModel*)shadowMatrixModel:(EGMatrixModel*)model;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSettings : NSObject {
@protected
    CNSignal* _shadowTypeChanged;
    EGShadowTypeR __shadowType;
}
@property (nonatomic, readonly) CNSignal* shadowTypeChanged;

+ (instancetype)settings;
- (instancetype)init;
- (CNClassType*)type;
- (EGShadowTypeR)shadowType;
- (void)setShadowType:(EGShadowTypeR)shadowType;
- (NSString*)description;
+ (CNClassType*)type;
@end


