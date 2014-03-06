#import "objd.h"
#import "EGShader.h"
#import "EGParticleSystemView.h"
#import "EGBillboard.h"
#import "GEVec.h"
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
@class EGBlendFunction;
@class EGParticleSystem;
@class EGMutableIndexSourceGap;
@class EGIBO;
@class EGD2D;
@class GEMat4;

@class EGBillboardShaderSystem;
@class EGBillboardShaderBuilder;
@class EGBillboardShader;
@class EGBillboardParticleSystemView;
@class EGBillboard;

@interface EGBillboardShaderSystem : EGShaderSystem
+ (instancetype)billboardShaderSystem;
- (instancetype)init;
- (ODClassType*)type;
- (EGBillboardShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGBillboardShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGBillboardShaderBuilder : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) NSString* parameters;
@property (nonatomic, readonly) NSString* code;

+ (instancetype)billboardShaderBuilderWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code;
- (instancetype)initWithTexture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow parameters:(NSString*)parameters code:(NSString*)code;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGBillboardShader : EGShader
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL alpha;
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* colorSlot;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) id alphaTestLevelUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* pUniform;

+ (instancetype)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow;
- (instancetype)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture alpha:(BOOL)alpha shadow:(BOOL)shadow;
- (ODClassType*)type;
+ (EGBillboardShader*)instanceForColor;
+ (EGBillboardShader*)instanceForTexture;
+ (EGBillboardShader*)instanceForAlpha;
+ (EGBillboardShader*)instanceForColorShadow;
+ (EGBillboardShader*)instanceForTextureShadow;
+ (EGBillboardShader*)instanceForAlphaShadow;
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


@interface EGBillboard : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GEVec3 position;
@property (nonatomic) GERect rect;

+ (instancetype)billboard;
- (instancetype)init;
- (ODClassType*)type;
- (void)draw;
+ (EGBillboard*)applyMaterial:(EGColorSource*)material;
- (BOOL)containsVec2:(GEVec2)vec2;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


