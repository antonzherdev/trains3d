#import "objd.h"
#import "EGShader.h"
#import "EGParticleSystemView.h"
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGGlobal;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGContext;
@class EGSprite;
@class EGBlendFunction;
@class EGParticleSystem;
@class EGMutableIndexSourceGap;
@class EGIBO;

@class EGBillboardShaderSystem;
@class EGBillboardShaderKey;
@class EGBillboardShaderBuilder;
@class EGBillboardShader;
@class EGBillboardParticleSystemView;
@class EGBillboardShaderSpace;

@interface EGBillboardShaderSystem : EGShaderSystem {
@private
    NSMutableDictionary* _map;
}
+ (instancetype)billboardShaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
- (EGBillboardShader*)shaderForKey:(EGBillboardShaderKey*)key;
+ (EGBillboardShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGBillboardShaderSpace : ODEnum
+ (EGBillboardShaderSpace*)camera;
+ (EGBillboardShaderSpace*)projection;
+ (NSArray*)values;
@end


@interface EGBillboardShaderKey : NSObject {
@private
    BOOL _texture;
    BOOL _alpha;
    BOOL _shadow;
    EGBillboardShaderSpace* _modelSpace;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGBillboardShaderSpace* modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpace*)modelSpace;
- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpace*)modelSpace;
- (ODClassType*)type;
- (EGBillboardShader*)shader;
+ (ODClassType*)type;
@end


@interface EGBillboardShaderBuilder : NSObject<EGShaderTextBuilder> {
@private
    EGBillboardShaderKey* _key;
}
@property (nonatomic, readonly) EGBillboardShaderKey* key;

+ (instancetype)billboardShaderBuilderWithKey:(EGBillboardShaderKey*)key;
- (instancetype)initWithKey:(EGBillboardShaderKey*)key;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGBillboardShader : EGShader {
@private
    EGBillboardShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    id _uvSlot;
    EGShaderAttribute* _colorSlot;
    EGShaderUniformVec4* _colorUniform;
    id _alphaTestLevelUniform;
    id _wcUniform;
    id _pUniform;
    id _wcpUniform;
}
@property (nonatomic, readonly) EGBillboardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* colorSlot;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) id alphaTestLevelUniform;
@property (nonatomic, readonly) id wcUniform;
@property (nonatomic, readonly) id pUniform;
@property (nonatomic, readonly) id wcpUniform;

+ (instancetype)billboardShaderWithKey:(EGBillboardShaderKey*)key program:(EGShaderProgram*)program;
- (instancetype)initWithKey:(EGBillboardShaderKey*)key program:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


@interface EGBillboardParticleSystemView : EGParticleSystemView<EGIBOParticleSystemViewQuad>
+ (instancetype)billboardParticleSystemViewWithSystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
+ (EGBillboardParticleSystemView*)applySystem:(EGParticleSystem*)system maxCount:(NSUInteger)maxCount material:(EGColorSource*)material;
+ (ODClassType*)type;
@end


