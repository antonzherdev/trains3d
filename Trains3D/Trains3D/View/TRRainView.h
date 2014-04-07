#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGParticleSystemView.h"
#import "EGShader.h"
@class TRWeather;
@class EGDirector;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@protocol EGIndexSource;
@class EGEmptyIndexSource;
@class EGGlobal;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;

@class TRRainView;
@class TRRainParticleSystem;
@class TRRainParticle;
@class TRRainSystemView;
@class TRRainShaderText;
@class TRRainShader;
typedef struct TRRainData TRRainData;

@interface TRRainView : TRPrecipitationView {
@private
    TRWeather* _weather;
    CGFloat _strength;
    TRRainParticleSystem* _system;
    TRRainSystemView* _view;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) TRRainParticleSystem* system;
@property (nonatomic, readonly) TRRainSystemView* view;

+ (instancetype)rainViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)complete;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRRainParticleSystem : EGParticleSystem {
@private
    TRWeather* _weather;
    CGFloat _strength;
    NSArray* _particles;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) NSArray* particles;

+ (instancetype)rainParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRainParticle : NSObject<EGParticle> {
@private
    TRWeather* _weather;
    GEVec2 _position;
    CGFloat _alpha;
}
@property (nonatomic, readonly) TRWeather* weather;

+ (instancetype)rainParticleWithWeather:(TRWeather*)weather;
- (instancetype)initWithWeather:(TRWeather*)weather;
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
+ (instancetype)rainSystemViewWithSystem:(TRRainParticleSystem*)system;
- (instancetype)initWithSystem:(TRRainParticleSystem*)system;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (NSUInteger)indexCount;
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRRainShaderText : NSObject<EGShaderTextBuilder> {
@private
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)rainShaderText;
- (instancetype)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface TRRainShader : EGShader {
@private
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _alphaSlot;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* alphaSlot;

+ (instancetype)rainShader;
- (instancetype)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
+ (TRRainShader*)instance;
+ (ODClassType*)type;
@end


