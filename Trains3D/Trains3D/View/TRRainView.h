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
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)complete;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (NSUInteger)vertexCount;
- (void)_init;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (unsigned int)doWriteToArray:(TRRainData*)array;
- (NSString*)description;
+ (CNClassType*)type;
@end


struct TRRainParticle {
    GEVec2 position;
    float alpha;
};
static inline TRRainParticle TRRainParticleMake(GEVec2 position, float alpha) {
    return (TRRainParticle){position, alpha};
}
NSString* trRainParticleDescription(TRRainParticle self);
BOOL trRainParticleIsEqualTo(TRRainParticle self, TRRainParticle to);
NSUInteger trRainParticleHash(TRRainParticle self);
CNPType* trRainParticleType();
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
NSString* trRainDataDescription(TRRainData self);
BOOL trRainDataIsEqualTo(TRRainData self, TRRainData to);
NSUInteger trRainDataHash(TRRainData self);
CNPType* trRainDataType();
@interface TRRainDataWrap : NSObject
@property (readonly, nonatomic) TRRainData value;

+ (id)wrapWithValue:(TRRainData)value;
- (id)initWithValue:(TRRainData)value;
@end



@interface TRRainSystemView : EGParticleSystemView
+ (instancetype)rainSystemViewWithSystem:(TRRainParticleSystem*)system;
- (instancetype)initWithSystem:(TRRainParticleSystem*)system;
- (CNClassType*)type;
- (NSUInteger)indexCount;
- (id<EGIndexSource>)createIndexSource;
- (NSString*)description;
+ (EGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


@interface TRRainShaderText : EGShaderTextBuilder_impl {
@protected
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)rainShaderText;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
- (NSString*)description;
+ (TRRainShader*)instance;
+ (CNClassType*)type;
@end


