#import "objd.h"
#import "TRLevelView.h"
#import "PGParticleSystem.h"
#import "PGBillboard.h"
#import "PGVec.h"
#import "PGParticleSystemView.h"
#import "PGTexture.h"
#import "PGShader.h"
@class TRWeather;
@class PGGlobal;
@class PGBlendFunction;
@class PGVertexBufferDesc;
@class PGContext;

@class TRSnowView;
@class TRSnowParticleSystem;
@class TRSnowSystemView;
@class TRSnowShaderText;
@class TRSnowShader;
typedef struct TRSnowParticle TRSnowParticle;
typedef struct TRSnowData TRSnowData;

@interface TRSnowView : TRPrecipitationView {
@public
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


@interface TRSnowParticleSystem : PGFixedParticleSystem<PGBillboardParticleSystem> {
@public
    TRWeather* _weather;
    CGFloat _strength;
    PGQuadrant _textureQuadrant;
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
    PGVec2 position;
    float size;
    PGVec2 windVar;
    PGVec2 urge;
    PGQuad uv;
};
static inline TRSnowParticle TRSnowParticleMake(PGVec2 position, float size, PGVec2 windVar, PGVec2 urge, PGQuad uv) {
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
    PGVec2 position;
    PGVec2 uv;
};
static inline TRSnowData TRSnowDataMake(PGVec2 position, PGVec2 uv) {
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



@interface TRSnowSystemView : PGParticleSystemViewIndexArray
+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (instancetype)initWithSystem:(TRSnowParticleSystem*)system;
- (CNClassType*)type;
- (NSString*)description;
+ (PGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


@interface TRSnowShaderText : PGShaderTextBuilder_impl {
@public
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)snowShaderText;
- (instancetype)init;
- (CNClassType*)type;
- (NSString*)vertex;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRSnowShader : PGShader {
@public
    PGShaderAttribute* _positionSlot;
    PGShaderAttribute* _uvSlot;
}
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;

+ (instancetype)snowShader;
- (instancetype)init;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGTexture*)param;
- (NSString*)description;
+ (TRSnowShader*)instance;
+ (CNClassType*)type;
@end


