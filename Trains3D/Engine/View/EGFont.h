#import "objd.h"
#import "GEVec.h"
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
@class EGFontShader;
@class EGCullFace;
@class EGFontShaderParam;

@class EGFont;
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
@protected
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
- (EGFontSymbolDesc*)symbolOptSmb:(unichar)smb;
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


@interface EGFontSymbolDesc : NSObject {
@protected
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



