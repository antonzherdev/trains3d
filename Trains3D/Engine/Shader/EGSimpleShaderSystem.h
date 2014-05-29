#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGTexture;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGTextureRegion;

@class EGSimpleShaderSystem;
@class EGSimpleShaderKey;
@class EGSimpleShader;

@interface EGSimpleShaderSystem : EGShaderSystem
+ (instancetype)simpleShaderSystem;
- (instancetype)init;
- (CNClassType*)type;
+ (EGShader*)colorShader;
- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
- (NSString*)description;
+ (EGSimpleShaderSystem*)instance;
+ (CNClassType*)type;
@end


@interface EGSimpleShaderKey : EGShaderTextBuilder_impl {
@protected
    BOOL _texture;
    BOOL _region;
    EGBlendModeR _blendMode;
    NSString* _fragment;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) EGBlendModeR blendMode;
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendModeR)blendMode;
- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendModeR)blendMode;
- (CNClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGSimpleShader : EGShader {
@protected
    EGSimpleShaderKey* _key;
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    EGShaderUniformVec4* _colorUniform;
    EGShaderUniformVec2* _uvScale;
    EGShaderUniformVec2* _uvShift;
}
@property (nonatomic, readonly) EGSimpleShaderKey* key;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) EGShaderUniformVec2* uvScale;
@property (nonatomic, readonly) EGShaderUniformVec2* uvShift;

+ (instancetype)simpleShaderWithKey:(EGSimpleShaderKey*)key;
- (instancetype)initWithKey:(EGSimpleShaderKey*)key;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
- (NSString*)description;
+ (CNClassType*)type;
@end


