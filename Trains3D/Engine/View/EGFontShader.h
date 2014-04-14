#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGTexture;
@class EGGlobal;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGContext;
@class EGMatrixStack;
@class GEMat4;

@class EGFontShaderParam;
@class EGFontShaderBuilder;
@class EGFontShader;

@interface EGFontShaderParam : NSObject {
@protected
    EGTexture* _texture;
    GEVec4 _color;
    GEVec2 _shift;
}
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec2 shift;

+ (instancetype)fontShaderParamWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift;
- (instancetype)initWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFontShaderBuilder : NSObject<EGShaderTextBuilder>
+ (instancetype)fontShaderBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGFontShader : EGShader {
@protected
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformVec4* _colorUniform;
    EGShaderUniformVec2* _shiftSlot;
}
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniformVec4* colorUniform;
@property (nonatomic, readonly) EGShaderUniformVec2* shiftSlot;

+ (instancetype)fontShader;
- (instancetype)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGFontShaderParam*)param;
+ (EGFontShader*)instance;
+ (ODClassType*)type;
@end


