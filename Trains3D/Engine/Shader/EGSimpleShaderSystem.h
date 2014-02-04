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
@class EGMatrixModel;
@class EGTextureRegion;

@class EGSimpleShaderSystem;
@class EGSimpleShaderKey;
@class EGSimpleShader;

@interface EGSimpleShaderSystem : EGShaderSystem
+ (id)simpleShaderSystem;
- (id)init;
- (ODClassType*)type;
+ (EGShader*)colorShader;
- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget;
+ (EGSimpleShaderSystem*)instance;
+ (ODClassType*)type;
@end


@interface EGSimpleShaderKey : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL texture;
@property (nonatomic, readonly) BOOL region;
@property (nonatomic, readonly) EGBlendMode* blendMode;
@property (nonatomic, readonly) NSString* fragment;

+ (id)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode;
- (id)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGSimpleShader : EGShader
@property (nonatomic, readonly) EGSimpleShaderKey* key;
@property (nonatomic, readonly) id uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* mvpUniform;
@property (nonatomic, readonly) id colorUniform;
@property (nonatomic, readonly) id uvScale;
@property (nonatomic, readonly) id uvShift;

+ (id)simpleShaderWithKey:(EGSimpleShaderKey*)key;
- (id)initWithKey:(EGSimpleShaderKey*)key;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (ODClassType*)type;
@end


