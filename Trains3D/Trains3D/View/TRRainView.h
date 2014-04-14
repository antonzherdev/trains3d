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
@class TRRainSystemView;
@class TRRainShaderText;
@class TRRainShader;
typedef struct TRRainParticle TRRainParticle;
typedef struct TRRainData TRRainData;

@interface TRRainView : TRPrecipitationView {
@protected
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


@interface TRRainParticleSystem : EGFixedParticleSystem {
@protected
    TRWeather* _weather;
    CGFloat _strength;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;

+ (instancetype)rainParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (void)_init;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (void)doWriteToArray:(TRRainData*)array;
+ (ODClassType*)type;
@end


struct TRRainParticle {
    GEVec2 position;
    float alpha;
};
static inline TRRainParticle TRRainParticleMake(GEVec2 position, float alpha) {
    return (TRRainParticle){position, alpha};
}
static inline BOOL TRRainParticleEq(TRRainParticle s1, TRRainParticle s2) {
    return GEVec2Eq(s1.position, s2.position) && eqf4(s1.alpha, s2.alpha);
}
static inline NSUInteger TRRainParticleHash(TRRainParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.alpha);
    return hash;
}
NSString* TRRainParticleDescription(TRRainParticle self);
ODPType* trRainParticleType();
@interface TRRainParticleWrap : NSObject
@property (readonly, nonatomic) TRRainParticle value;

+ (id)wrapWithValue:(TRRainParticle)value;
- (id)initWithValue:(TRRainParticle)value;
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
- (NSUInteger)indexCount;
- (id<EGIndexSource>)createIndexSource;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRRainShaderText : NSObject<EGShaderTextBuilder> {
@protected
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
@protected
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


