#import "objd.h"
#import "TRLevelView.h"
#import "PGParticleSystem.h"
#import "PGVec.h"
#import "PGParticleSystemView.h"
#import "PGShader.h"
@class TRWeather;
@class PGDirector;
@class PGBlendFunction;
@class PGVertexBufferDesc;
@protocol PGIndexSource;
@class PGEmptyIndexSource;

@class TRRainView;
@class TRRainParticleSystem;
@class TRRainSystemView;
@class TRRainShaderText;
@class TRRainShader;
typedef struct TRRainParticle TRRainParticle;
typedef struct TRRainData TRRainData;

@interface TRRainView : TRPrecipitationView {
@public
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


@interface TRRainParticleSystem : PGFixedParticleSystem {
@public
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
    PGVec2 position;
    float alpha;
};
static inline TRRainParticle TRRainParticleMake(PGVec2 position, float alpha) {
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
    PGVec2 position;
    float alpha;
};
static inline TRRainData TRRainDataMake(PGVec2 position, float alpha) {
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



@interface TRRainSystemView : PGParticleSystemView
+ (instancetype)rainSystemViewWithSystem:(TRRainParticleSystem*)system;
- (instancetype)initWithSystem:(TRRainParticleSystem*)system;
- (CNClassType*)type;
- (NSUInteger)indexCount;
- (id<PGIndexSource>)createIndexSource;
- (NSString*)description;
+ (PGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


@interface TRRainShaderText : PGShaderTextBuilder_impl {
@public
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)rainShaderText;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRainShader : PGShader {
@public
    PGShaderAttribute* _positionSlot;
    PGShaderAttribute* _alphaSlot;
}
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderAttribute* alphaSlot;

+ (instancetype)rainShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
- (NSString*)description;
+ (TRRainShader*)instance;
+ (CNClassType*)type;
@end


