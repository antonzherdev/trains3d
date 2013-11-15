#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGShader.h"
@class TRWeather;
@class EGGlobal;
@class EGContext;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@protocol EGIndexSource;
@class EGEmptyIndexSource;
@class EGBlendMode;

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
+ (ODClassType*)type;
@end


struct TRSnowData {
    GEVec2 position;
    float alpha;
};
static inline TRSnowData TRSnowDataMake(GEVec2 position, float alpha) {
    return (TRSnowData){position, alpha};
}
static inline BOOL TRSnowDataEq(TRSnowData s1, TRSnowData s2) {
    return GEVec2Eq(s1.position, s2.position) && eqf4(s1.alpha, s2.alpha);
}
static inline NSUInteger TRSnowDataHash(TRSnowData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.alpha);
    return hash;
}
NSString* TRSnowDataDescription(TRSnowData self);
ODPType* trSnowDataType();
@interface TRSnowDataWrap : NSObject
@property (readonly, nonatomic) TRSnowData value;

+ (id)wrapWithValue:(TRSnowData)value;
- (id)initWithValue:(TRSnowData)value;
@end



@interface TRSnowSystemView : EGParticleSystemView
+ (id)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (id)initWithSystem:(TRSnowParticleSystem*)system;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (NSUInteger)indexCount;
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
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
@property (nonatomic, readonly) EGShaderAttribute* alphaSlot;

+ (id)snowShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(NSObject*)param;
+ (TRSnowShader*)instance;
+ (ODClassType*)type;
@end


