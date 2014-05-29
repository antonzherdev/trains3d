#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "EGParticleSystemView.h"
#import "EGTexture.h"
#import "EGShader.h"
@class TRWeather;
@class EGGlobal;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@class EGContext;

@class TRSnowView;
@class TRSnowParticleSystem;
@class TRSnowSystemView;
@class TRSnowShaderText;
@class TRSnowShader;
typedef struct TRSnowParticle TRSnowParticle;
typedef struct TRSnowData TRSnowData;

@interface TRSnowView : TRPrecipitationView {
@protected
    TRWeather* _weather;
    CGFloat _strength;
    TRSnowParticleSystem* _system;
    TRSnowSystemView* _view;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) TRSnowParticleSystem* system;
@property (nonatomic, readonly) TRSnowSystemView* view;

+ (instancetype)snowViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)complete;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRSnowParticleSystem : EGFixedParticleSystem<EGBillboardParticleSystem> {
@protected
    TRWeather* _weather;
    CGFloat _strength;
    GEQuadrant _textureQuadrant;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;

+ (instancetype)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (CNClassType*)type;
- (void)_init;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (unsigned int)doWriteToArray:(TRSnowData*)array;
- (NSString*)description;
+ (CNClassType*)type;
@end


struct TRSnowParticle {
    GEVec2 position;
    float size;
    GEVec2 windVar;
    GEVec2 urge;
    GEQuad uv;
};
static inline TRSnowParticle TRSnowParticleMake(GEVec2 position, float size, GEVec2 windVar, GEVec2 urge, GEQuad uv) {
    return (TRSnowParticle){position, size, windVar, urge, uv};
}
NSString* trSnowParticleDescription(TRSnowParticle self);
BOOL trSnowParticleIsEqualTo(TRSnowParticle self, TRSnowParticle to);
NSUInteger trSnowParticleHash(TRSnowParticle self);
CNPType* trSnowParticleType();
@interface TRSnowParticleWrap : NSObject
@property (readonly, nonatomic) TRSnowParticle value;

+ (id)wrapWithValue:(TRSnowParticle)value;
- (id)initWithValue:(TRSnowParticle)value;
@end



struct TRSnowData {
    GEVec2 position;
    GEVec2 uv;
};
static inline TRSnowData TRSnowDataMake(GEVec2 position, GEVec2 uv) {
    return (TRSnowData){position, uv};
}
NSString* trSnowDataDescription(TRSnowData self);
BOOL trSnowDataIsEqualTo(TRSnowData self, TRSnowData to);
NSUInteger trSnowDataHash(TRSnowData self);
CNPType* trSnowDataType();
@interface TRSnowDataWrap : NSObject
@property (readonly, nonatomic) TRSnowData value;

+ (id)wrapWithValue:(TRSnowData)value;
- (id)initWithValue:(TRSnowData)value;
@end



@interface TRSnowSystemView : EGParticleSystemViewIndexArray
+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (instancetype)initWithSystem:(TRSnowParticleSystem*)system;
- (CNClassType*)type;
- (NSString*)description;
+ (EGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


@interface TRSnowShaderText : EGShaderTextBuilder_impl {
@protected
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)snowShaderText;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRSnowShader : EGShader {
@protected
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _uvSlot;
}
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;

+ (instancetype)snowShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGTexture*)param;
- (NSString*)description;
+ (TRSnowShader*)instance;
+ (CNClassType*)type;
@end


