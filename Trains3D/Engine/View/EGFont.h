#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGVertexBufferDesc;
@class ATSignal;
@class EGTexture;
@class EGDirector;
@class EGGlobal;
@class EGContext;
@class ATReact;
@class EGMatrixStack;
@class GEMat4;
@class EGSimpleVertexArray;
@class EGVBO;
@class EGIBO;
@class EGCullFace;
@class EGFileTexture;
@class EGTextureFileFormat;
@class EGTextureFormat;
@class EGTextureFilter;
@class ATReactFlag;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;

@class EGFont;
@class EGBMFont;
@class EGText;
@class EGTextShadow;
@class EGFontShaderParam;
@class EGFontShaderBuilder;
@class EGFontShader;
@class EGFontSymbolDesc;
typedef struct EGTextAlignment EGTextAlignment;
typedef struct EGFontPrintData EGFontPrintData;

struct EGTextAlignment {
    float x;
    float y;
    BOOL baseline;
    GEVec2 shift;
};
static inline EGTextAlignment EGTextAlignmentMake(float x, float y, BOOL baseline, GEVec2 shift) {
    return (EGTextAlignment){x, y, baseline, shift};
}
static inline BOOL EGTextAlignmentEq(EGTextAlignment s1, EGTextAlignment s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && s1.baseline == s2.baseline && GEVec2Eq(s1.shift, s2.shift);
}
static inline NSUInteger EGTextAlignmentHash(EGTextAlignment self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + self.baseline;
    hash = hash * 31 + GEVec2Hash(self.shift);
    return hash;
}
NSString* EGTextAlignmentDescription(EGTextAlignment self);
EGTextAlignment egTextAlignmentApplyXY(float x, float y);
EGTextAlignment egTextAlignmentApplyXYShift(float x, float y, GEVec2 shift);
EGTextAlignment egTextAlignmentBaselineX(float x);
EGTextAlignment egTextAlignmentLeft();
EGTextAlignment egTextAlignmentRight();
EGTextAlignment egTextAlignmentCenter();
ODPType* egTextAlignmentType();
@interface EGTextAlignmentWrap : NSObject
@property (readonly, nonatomic) EGTextAlignment value;

+ (id)wrapWithValue:(EGTextAlignment)value;
- (id)initWithValue:(EGTextAlignment)value;
@end



@interface EGFont : NSObject {
@private
    ATSignal* _symbolsChanged;
}
@property (nonatomic, readonly) ATSignal* symbolsChanged;

+ (instancetype)font;
- (instancetype)init;
- (ODClassType*)type;
- (EGTexture*)texture;
- (NSUInteger)height;
- (NSUInteger)size;
- (GEVec2)measureInPointsText:(NSString*)text;
- (id)symbolOptSmb:(unichar)smb;
- (GEVec2)measurePText:(NSString*)text;
- (GEVec2)measureCText:(NSString*)text;
- (BOOL)resymbolHasGL:(BOOL)hasGL;
- (EGSimpleVertexArray*)vaoText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment;
- (void)drawText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment color:(GEVec4)color;
- (EGFont*)beReadyForText:(NSString*)text;
+ (EGFontSymbolDesc*)newLineDesc;
+ (EGFontSymbolDesc*)zeroDesc;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface EGBMFont : EGFont {
@private
    NSString* _name;
    EGFileTexture* _texture;
    id<CNMap> _symbols;
    NSUInteger _height;
    NSUInteger _size;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) EGFileTexture* texture;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSUInteger size;

+ (instancetype)fontWithName:(NSString*)name;
- (instancetype)initWithName:(NSString*)name;
- (ODClassType*)type;
- (void)_init;
- (id)symbolOptSmb:(unichar)smb;
+ (ODClassType*)type;
@end


@interface EGText : NSObject {
@private
    ATReact* _visible;
    ATReact* _font;
    ATReact* _text;
    ATReact* _position;
    ATReact* _alignment;
    ATReact* _color;
    ATReact* _shadow;
    ATReactFlag* __changed;
    ATReact* _fontObserver;
    EGSimpleVertexArray* __vao;
    CNLazy* __lazy_sizeInPoints;
    CNLazy* __lazy_sizeInP;
}
@property (nonatomic, readonly) ATReact* visible;
@property (nonatomic, readonly) ATReact* font;
@property (nonatomic, readonly) ATReact* text;
@property (nonatomic, readonly) ATReact* position;
@property (nonatomic, readonly) ATReact* alignment;
@property (nonatomic, readonly) ATReact* color;
@property (nonatomic, readonly) ATReact* shadow;

+ (instancetype)textWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
- (instancetype)initWithVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
- (ODClassType*)type;
- (ATReact*)sizeInPoints;
- (ATReact*)sizeInP;
- (void)draw;
- (GEVec2)measureInPoints;
- (GEVec2)measureP;
- (GEVec2)measureC;
+ (EGText*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color;
+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color shadow:(ATReact*)shadow;
+ (EGText*)applyFont:(ATReact*)font text:(ATReact*)text position:(ATReact*)position alignment:(ATReact*)alignment color:(ATReact*)color;
+ (ODClassType*)type;
@end


@interface EGTextShadow : NSObject {
@private
    GEVec4 _color;
    GEVec2 _shift;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec2 shift;

+ (instancetype)textShadowWithColor:(GEVec4)color shift:(GEVec2)shift;
- (instancetype)initWithColor:(GEVec4)color shift:(GEVec2)shift;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFontShaderParam : NSObject {
@private
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
@private
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


@interface EGFontSymbolDesc : NSObject {
@private
    float _width;
    GEVec2 _offset;
    GEVec2 _size;
    GERect _textureRect;
    BOOL _isNewLine;
}
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) GEVec2 offset;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) GERect textureRect;
@property (nonatomic, readonly) BOOL isNewLine;

+ (instancetype)fontSymbolDescWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine;
- (instancetype)initWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect isNewLine:(BOOL)isNewLine;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


struct EGFontPrintData {
    GEVec2 position;
    GEVec2 uv;
};
static inline EGFontPrintData EGFontPrintDataMake(GEVec2 position, GEVec2 uv) {
    return (EGFontPrintData){position, uv};
}
static inline BOOL EGFontPrintDataEq(EGFontPrintData s1, EGFontPrintData s2) {
    return GEVec2Eq(s1.position, s2.position) && GEVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger EGFontPrintDataHash(EGFontPrintData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.uv);
    return hash;
}
NSString* EGFontPrintDataDescription(EGFontPrintData self);
ODPType* egFontPrintDataType();
@interface EGFontPrintDataWrap : NSObject
@property (readonly, nonatomic) EGFontPrintData value;

+ (id)wrapWithValue:(EGFontPrintData)value;
- (id)initWithValue:(EGFontPrintData)value;
@end



