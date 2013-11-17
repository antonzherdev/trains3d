#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGShader.h"
@class TRWeather;
@class EGGlobal;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@class EGMutableIndexSourceGap;
@class EGIBO;
@class EGBlendMode;
@class EGContext;
@class EGTexture;

@class TRSnowView;
@class TRSnowParticleSystem;
@class TRSnowParticle;
@class TRSnowSystemView;
@class TRSnowShaderText;
@class TRSnowShader;
typedef struct TRSnowData TRSnowData;

@interface TRSnowView : TRPrecipitationView
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) TRSnowParticleSystem* system;
@property (nonatomic, readonly) TRSnowSystemView* view;

+ (id)snowViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRSnowParticleSystem : NSObject<EGParticleSystem>
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) id<CNSeq> particles;

+ (id)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRSnowParticle : NSObject<EGParticle>
@property (nonatomic, readonly) TRWeather* weather;

+ (id)snowParticleWithWeather:(TRWeather*)weather;
- (id)initWithWeather:(TRWeather*)weather;
- (ODClassType*)type;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
- (GEVec2)vec;
- (void)updateWithDelta:(CGFloat)delta;
+ (GEQuadrant)textureQuadrant;
+ (ODClassType*)type;
@end


struct TRSnowData {
    GEVec2 position;
    GEVec2 uv;
};
static inline TRSnowData TRSnowDataMake(GEVec2 position, GEVec2 uv) {
    return (TRSnowData){position, uv};
}
static inline BOOL TRSnowDataEq(TRSnowData s1, TRSnowData s2) {
    return GEVec2Eq(s1.position, s2.position) && GEVec2Eq(s1.uv, s2.uv);
}
static inline NSUInteger TRSnowDataHash(TRSnowData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.uv);
    return hash;
}
NSString* TRSnowDataDescription(TRSnowData self);
ODPType* trSnowDataType();
@interface TRSnowDataWrap : NSObject
@property (readonly, nonatomic) TRSnowData value;

+ (id)wrapWithValue:(TRSnowData)value;
- (id)initWithValue:(TRSnowData)value;
@end



@interface TRSnowSystemView : EGParticleSystemView<EGIBOParticleSystemViewQuad>
+ (id)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (id)initWithSystem:(TRSnowParticleSystem*)system;
- (ODClassType*)type;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRSnowShaderText : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) NSString* fragment;

+ (id)snowShaderText;
- (id)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface TRSnowShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;

+ (id)snowShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGTexture*)param;
+ (TRSnowShader*)instance;
+ (ODClassType*)type;
@end

