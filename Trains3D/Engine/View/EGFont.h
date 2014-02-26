#import "objd.h"
#import "GEVec.h"
#import "EGShader.h"
@class EGVertexBufferDesc;
@class EGTexture;
@class EGGlobal;
@class EGContext;
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
@class EGDirector;
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
    GEVec3 shift;
};
static inline EGTextAlignment EGTextAlignmentMake(float x, float y, BOOL baseline, GEVec3 shift) {
    return (EGTextAlignment){x, y, baseline, shift};
}
static inline BOOL EGTextAlignmentEq(EGTextAlignment s1, EGTextAlignment s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && s1.baseline == s2.baseline && GEVec3Eq(s1.shift, s2.shift);
}
static inline NSUInteger EGTextAlignmentHash(EGTextAlignment self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + self.baseline;
    hash = hash * 31 + GEVec3Hash(self.shift);
    return hash;
}
NSString* EGTextAlignmentDescription(EGTextAlignment self);
EGTextAlignment egTextAlignmentApplyXY(float x, float y);
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



@interface EGFont : NSObject
+ (instancetype)font;
- (instancetype)init;
- (ODClassType*)type;
- (EGTexture*)texture;
- (NSUInteger)height;
- (NSUInteger)size;
- (GEVec2)measureInPixelsText:(NSString*)text;
- (id)symbolOptSmb:(unichar)smb;
- (GEVec2)measurePText:(NSString*)text;
- (GEVec2)measureCText:(NSString*)text;
- (BOOL)resymbol;
- (EGSimpleVertexArray*)vaoText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment;
- (void)drawText:(NSString*)text at:(GEVec3)at alignment:(EGTextAlignment)alignment color:(GEVec4)color;
- (void)beReadyForText:(NSString*)text;
+ (CNNotificationHandle*)fontChangeNotification;
+ (EGFontSymbolDesc*)newLineDesc;
+ (EGFontSymbolDesc*)zeroDesc;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface EGBMFont : EGFont
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


@interface EGText : NSObject
@property (nonatomic) BOOL _changed;
@property (nonatomic) GEVec4 color;
@property (nonatomic) id shadow;

+ (instancetype)text;
- (instancetype)init;
- (ODClassType*)type;
+ (EGText*)applyFont:(EGFont*)font text:(NSString*)text position:(GEVec3)position alignment:(EGTextAlignment)alignment color:(GEVec4)color;
- (EGFont*)font;
- (void)setFont:(EGFont*)font;
- (NSString*)text;
- (void)setText:(NSString*)text;
- (GEVec3)position;
- (void)setPosition:(GEVec3)position;
- (EGTextAlignment)alignment;
- (void)setAlignment:(EGTextAlignment)alignment;
- (void)draw;
- (GEVec2)measureInPixels;
- (GEVec2)measureP;
- (GEVec2)measureC;
+ (ODClassType*)type;
@end


@interface EGTextShadow : NSObject
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec2 shift;

+ (instancetype)textShadowWithColor:(GEVec4)color shift:(GEVec2)shift;
- (instancetype)initWithColor:(GEVec4)color shift:(GEVec2)shift;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFontShaderParam : NSObject
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


@interface EGFontShader : EGShader
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


@interface EGFontSymbolDesc : NSObject
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



