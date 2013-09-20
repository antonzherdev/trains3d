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
@class EGTexture;

@class EGFont;
@class EGFontShaderParam;
@class EGFontShader;
@class EGFontSymbolDesc;
typedef struct EGFontPrintData EGFontPrintData;

@interface EGFont : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) unsigned int size;

+ (id)fontWithName:(NSString*)name size:(unsigned int)size;
- (id)initWithName:(NSString*)name size:(unsigned int)size;
- (ODClassType*)type;
- (void)_init;
- (void)drawText:(NSString*)text at:(GEVec2)at color:(GEVec4)color;
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



