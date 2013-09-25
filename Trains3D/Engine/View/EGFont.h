#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
#import "EGShader.h"
@class EGVertexBufferDesc;
@class EGFileTexture;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGMesh;
@class EGGlobal;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class GEMat4;
@class EGTexture;

@class EGFont;
@class EGFontShaderParam;
@class EGFontShader;
@class EGFontSymbolDesc;
typedef struct EGTextAlignment EGTextAlignment;
typedef struct EGFontPrintData EGFontPrintData;

struct EGTextAlignment {
    float x;
    float y;
    BOOL baseline;
};
static inline EGTextAlignment EGTextAlignmentMake(float x, float y, BOOL baseline) {
    return (EGTextAlignment){x, y, baseline};
}
static inline BOOL EGTextAlignmentEq(EGTextAlignment s1, EGTextAlignment s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && s1.baseline == s2.baseline;
}
static inline NSUInteger EGTextAlignmentHash(EGTextAlignment self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + self.baseline;
    return hash;
}
static inline NSString* EGTextAlignmentDescription(EGTextAlignment self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGTextAlignment: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", baseline=%d", self.baseline];
    [description appendString:@">"];
    return description;
}
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
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly) NSUInteger size;

+ (id)fontWithName:(NSString*)name;
- (id)initWithName:(NSString*)name;
- (ODClassType*)type;
- (void)_init;
- (void)drawText:(NSString*)text color:(GEVec4)color at:(GEVec2)at alignment:(EGTextAlignment)alignment;
+ (ODClassType*)type;
@end


@interface EGFontShaderParam : NSObject
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) GEVec4 color;

+ (id)fontShaderParamWithTexture:(EGTexture*)texture color:(GEVec4)color;
- (id)initWithTexture:(EGTexture*)texture color:(GEVec4)color;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGFontShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderUniform* colorUniform;

+ (id)fontShader;
- (id)init;
- (ODClassType*)type;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGFontShaderParam*)param;
- (void)unloadParam:(EGFontShaderParam*)param;
+ (EGFontShader*)instance;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (ODClassType*)type;
@end


@interface EGFontSymbolDesc : NSObject
@property (nonatomic, readonly) float width;
@property (nonatomic, readonly) GEVec2 offset;
@property (nonatomic, readonly) GEVec2 size;
@property (nonatomic, readonly) GERect textureRect;

+ (id)fontSymbolDescWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect;
- (id)initWithWidth:(float)width offset:(GEVec2)offset size:(GEVec2)size textureRect:(GERect)textureRect;
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
static inline NSString* EGFontPrintDataDescription(EGFontPrintData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGFontPrintData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* egFontPrintDataType();
@interface EGFontPrintDataWrap : NSObject
@property (readonly, nonatomic) EGFontPrintData value;

+ (id)wrapWithValue:(EGFontPrintData)value;
- (id)initWithValue:(EGFontPrintData)value;
@end



