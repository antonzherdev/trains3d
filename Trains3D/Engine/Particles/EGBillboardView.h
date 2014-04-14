#import "objd.h"
#import "EGShader.h"
#import "EGParticleSystemView.h"
#import "EGParticleSystemView2.h"
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGTexture;
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
@class EGParticleSystem2;

@class EGBillboardShaderSystem;
@class EGBillboardShaderKey;
@class EGBillboardShaderBuilder;
@class EGBillboardShader;
@class EGBillboardParticleSystemView;
@class EGBillboardParticleSystemView2;
@class EGBillboardShaderSpace;

@interface EGBillboardShaderSystem : EGShaderSystem {
@protected
    EGBillboardShaderSpace* _space;
}
@property (nonatomic, readonly) EGBillboardShaderSpace* space;

+ (instancetype)billboardShaderSystemWithSpace:(EGBillboardShaderSpace*)space;
- (instancetype)initWithSpace:(EGBillboardShaderSpace*)space;
- (ODClassType*)type;
- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGBillboardShader*)shaderForKey:(EGBillboardShaderKey*)key;
+ (EGBillboardShaderSystem*)cameraSpace;
+ (EGBillboardShaderSystem*)projectionSpace;
+ (ODClassType*)type;
@end


@interface EGBillboardShaderSpace : ODEnum
+ (EGBillboardShaderSpace*)camera;
+ (EGBillboardShaderSpace*)projection;
+ (NSArray*)values;
@end


@interface EGBillboardShaderKey : NSObject {
@protected
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
@protected
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
@protected
    EGBillboardShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _colorSlot;
    EGShaderUniformVec4* _colorUniform;
    EGShaderUniformF4* _alphaTestLevelUniform;
    EGShaderUniformMat4* _wcUniform;
    EGShaderUniformMat4* _pUniform;
    EGShaderUniformMat4* _wcpUniform;
}
@property (nonatomic, readonly) EGBillboardShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* colorSlot;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) EGShaderUniformF4* alphaTestLevelUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* pUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* wcpUniform;

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


@interface EGBillboardParticleSystemView2 : EGParticleSystemView2
+ (instancetype)billboardParticleSystemView2WithSystem:(EGParticleSystem2*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem2*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
+ (EGBillboardParticleSystemView2*)applySystem:(EGParticleSystem2*)system material:(EGColorSource*)material;
+ (ODClassType*)type;
@end


