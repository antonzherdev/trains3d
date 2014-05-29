#import "objd.h"
#import "GEVec.h"
@class EGVertexBufferDesc;
@class CNSignal;
@class EGTexture;
@class EGDirector;
@class EGGlobal;
@class EGContext;
@class CNReact;
@class EGMatrixStack;
@class GEMat4;
@class CNChain;
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
EGTextAlignment egTextAlignmentApplyXY(float x, float y);
EGTextAlignment egTextAlignmentApplyXYShift(float x, float y, GEVec2 shift);
EGTextAlignment egTextAlignmentBaselineX(float x);
NSString* egTextAlignmentDescription(EGTextAlignment self);
BOOL egTextAlignmentIsEqualTo(EGTextAlignment self, EGTextAlignment to);
NSUInteger egTextAlignmentHash(EGTextAlignment self);
EGTextAlignment egTextAlignmentLeft();
EGTextAlignment egTextAlignmentRight();
EGTextAlignment egTextAlignmentCenter();
CNPType* egTextAlignmentType();
@interface EGTextAlignmentWrap : NSObject
@property (readonly, nonatomic) EGTextAlignment value;

+ (id)wrapWithValue:(EGTextAlignment)value;
- (id)initWithValue:(EGTextAlignment)value;
@end



@interface EGFont : NSObject {
@protected
    CNSignal* _symbolsChanged;
}
@property (nonatomic, readonly) CNSignal* symbolsChanged;

+ (instancetype)font;
- (instancetype)init;
- (CNClassType*)type;
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
- (NSString*)description;
+ (EGFontSymbolDesc*)newLineDesc;
+ (EGFontSymbolDesc*)zeroDesc;
+ (EGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


struct EGFontPrintData {
    GEVec2 position;
    GEVec2 uv;
};
static inline EGFontPrintData EGFontPrintDataMake(GEVec2 position, GEVec2 uv) {
    return (EGFontPrintData){position, uv};
}
NSString* egFontPrintDataDescription(EGFontPrintData self);
BOOL egFontPrintDataIsEqualTo(EGFontPrintData self, EGFontPrintData to);
NSUInteger egFontPrintDataHash(EGFontPrintData self);
CNPType* egFontPrintDataType();
@interface EGFontPrintDataWrap : NSObject
@property (readonly, nonatomic) EGFontPrintData value;

+ (id)wrapWithValue:(EGFontPrintData)value;
- (id)initWithValue:(EGFontPrintData)value;
@end



