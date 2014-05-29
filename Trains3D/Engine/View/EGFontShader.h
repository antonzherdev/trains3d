#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGTexture;
@class EGVertexBufferDesc;
@class EGGlobal;
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
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface EGFontShaderBuilder : EGShaderTextBuilder_impl
+ (instancetype)fontShaderBuilder;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGFontShaderParam*)param;
- (NSString*)description;
+ (EGFontShader*)instance;
+ (CNClassType*)type;
@end


