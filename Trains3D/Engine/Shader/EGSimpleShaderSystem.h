#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGColorSource;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShadowShaderSystem;
@class EGTexture;
@class EGBlendMode;
@class EGSettings;
@class EGShadowType;
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
- (ODClassType*)type;
+ (EGShader*)colorShader;
- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGSimpleShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGSimpleShaderKey : NSObject<EGShaderTextBuilder> {
@private
    BOOL _texture;
    BOOL _region;
    EGBlendMode* _blendMode;
    NSString* _fragment;
}
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) EGBlendMode* blendMode;
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode;
- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGSimpleShader : EGShader {
@private
    EGSimpleShaderKey* _key;
    id _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    id _colorUniform;
    id _uvScale;
    id _uvShift;
}
@property (nonatomic, readonly) EGSimpleShaderKey* key;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) id colorUniform;
@property (nonatomic, readonly) id uvScale;
@property (nonatomic, readonly) id uvShift;

+ (instancetype)simpleShaderWithKey:(EGSimpleShaderKey*)key;
- (instancetype)initWithKey:(EGSimpleShaderKey*)key;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


