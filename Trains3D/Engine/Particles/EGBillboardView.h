#import "objd.h"
#import "EGShader.h"
#import "EGParticleSystemView.h"
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGTexture;
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGContext;
@class EGSprite;
@class EGParticleSystem;
@class EGBlendFunction;

@class EGBillboardShaderSystem;
@class EGBillboardShaderKey;
@class EGBillboardShaderBuilder;
@class EGBillboardShader;
@class EGBillboardParticleSystemView;
@class EGBillboardShaderSpace;

typedef enum EGBillboardShaderSpaceR {
    EGBillboardShaderSpace_Nil = 0,
    EGBillboardShaderSpace_camera = 1,
    EGBillboardShaderSpace_projection = 2
} EGBillboardShaderSpaceR;
@interface EGBillboardShaderSpace : CNEnum
+ (NSArray*)values;
@end
static EGBillboardShaderSpace* EGBillboardShaderSpace_Values[2];
static EGBillboardShaderSpace* EGBillboardShaderSpace_camera_Desc;
static EGBillboardShaderSpace* EGBillboardShaderSpace_projection_Desc;


@interface EGBillboardShaderSystem : EGShaderSystem {
@protected
    EGBillboardShaderSpaceR _space;
}
@property (nonatomic, readonly) EGBillboardShaderSpaceR space;

+ (instancetype)billboardShaderSystemWithSpace:(EGBillboardShaderSpaceR)space;
- (instancetype)initWithSpace:(EGBillboardShaderSpaceR)space;
- (CNClassType*)type;
- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGBillboardShader*)shaderForKey:(EGBillboardShaderKey*)key;
- (NSString*)description;
+ (EGBillboardShaderSystem*)cameraSpace;
+ (EGBillboardShaderSystem*)projectionSpace;
+ (CNClassType*)type;
@end


@interface EGBillboardShaderKey : NSObject {
@protected
    BOOL _texture;
    BOOL _alpha;
    BOOL _shadow;
    EGBillboardShaderSpaceR _modelSpace;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGBillboardShaderSpaceR modelSpace;

+ (instancetype)billboardShaderKeyWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpaceR)modelSpace;
- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow modelSpace:(EGBillboardShaderSpaceR)modelSpace;
- (CNClassType*)type;
- (EGBillboardShader*)shader;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGBillboardShaderBuilder : EGShaderTextBuilder_impl {
@protected
    EGBillboardShaderKey* _key;
}
@property (nonatomic, readonly) EGBillboardShaderKey* key;

+ (instancetype)billboardShaderBuilderWithKey:(EGBillboardShaderKey*)key;
- (instancetype)initWithKey:(EGBillboardShaderKey*)key;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGBillboardParticleSystemView : EGParticleSystemViewIndexArray
+ (instancetype)billboardParticleSystemViewWithSystem:(EGParticleSystem*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem*)system material:(EGColorSource*)material blendFunc:(EGBlendFunction*)blendFunc;
- (CNClassType*)type;
+ (EGBillboardParticleSystemView*)applySystem:(EGParticleSystem*)system material:(EGColorSource*)material;
- (NSString*)description;
+ (CNClassType*)type;
@end


