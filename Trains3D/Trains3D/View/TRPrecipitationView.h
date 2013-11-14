#import "objd.h"
#import "EGScene.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGShader.h"
@class TRPrecipitation;
@class TRPrecipitationType;
@class TRWeather;
@class EGGlobal;
@class EGContext;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@protocol EGIndexSource;
@class EGEmptyIndexSource;
@class EGBlendMode;

@class TRPrecipitationView;
@class TRRainView;
@class TRRainParticleSystem;
@class TRRainParticle;
@class TRRainSystemView;
@class TRRainShaderText;
@class TRRainShader;
typedef struct TRRainData TRRainData;

@interface TRPrecipitationView : NSObject<EGController>
+ (id)precipitationView;
- (id)init;
- (ODClassType*)type;
+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRainView : TRPrecipitationView
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) TRRainParticleSystem* system;
@property (nonatomic, readonly) TRRainSystemView* view;

+ (id)rainViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRRainParticleSystem : NSObject<EGParticleSystem>
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) id<CNSeq> particles;

+ (id)rainParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (id)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRainParticle : NSObject<EGParticle>
@property (nonatomic, readonly) TRWeather* weather;

+ (id)rainParticleWithWeather:(TRWeather*)weather;
- (id)initWithWeather:(TRWeather*)weather;
- (ODClassType*)type;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
- (GEVec2)vec;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


struct TRRainData {
    GEVec2 position;
    float alpha;
};
static inline TRRainData TRRainDataMake(GEVec2 position, float alpha) {
    return (TRRainData){position, alpha};
}
static inline BOOL TRRainDataEq(TRRainData s1, TRRainData s2) {
    return GEVec2Eq(s1.position, s2.position) && eqf4(s1.alpha, s2.alpha);
}
static inline NSUInteger TRRainDataHash(TRRainData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.alpha);
    return hash;
}
NSString* TRRainDataDescription(TRRainData self);
ODPType* trRainDataType();
@interface TRRainDataWrap : NSObject
@property (readonly, nonatomic) TRRainData value;

+ (id)wrapWithValue:(TRRainData)value;
- (id)initWithValue:(TRRainData)value;
@end



@interface TRRainSystemView : EGParticleSystemView
+ (id)rainSystemViewWithSystem:(TRRainParticleSystem*)system;
- (id)initWithSystem:(TRRainParticleSystem*)system;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (NSUInteger)indexCount;
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRRainShaderText : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) NSString* fragment;

+ (id)rainShaderText;
- (id)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface TRRainShader : EGShader
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* alphaSlot;

+ (id)rainShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(NSObject*)param;
+ (TRRainShader*)instance;
+ (ODClassType*)type;
@end


