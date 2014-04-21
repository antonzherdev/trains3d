#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "EGParticleSystemView.h"
#import "EGShader.h"
@class TRWeather;
@class EGTextureFilter;
@class EGGlobal;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGContext;
@class EGTexture;

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
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)complete;
- (void)draw;
+ (ODClassType*)type;
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
- (ODClassType*)type;
- (void)_init;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (unsigned int)doWriteToArray:(TRSnowData*)array;
+ (ODClassType*)type;
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
static inline BOOL TRSnowParticleEq(TRSnowParticle s1, TRSnowParticle s2) {
    return GEVec2Eq(s1.position, s2.position) && eqf4(s1.size, s2.size) && GEVec2Eq(s1.windVar, s2.windVar) && GEVec2Eq(s1.urge, s2.urge) && GEQuadEq(s1.uv, s2.uv);
}
static inline NSUInteger TRSnowParticleHash(TRSnowParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    hash = hash * 31 + GEVec2Hash(self.windVar);
    hash = hash * 31 + GEVec2Hash(self.urge);
    hash = hash * 31 + GEQuadHash(self.uv);
    return hash;
}
NSString* TRSnowParticleDescription(TRSnowParticle self);
ODPType* trSnowParticleType();
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



@interface TRSnowSystemView : EGParticleSystemViewIndexArray
+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (instancetype)initWithSystem:(TRSnowParticleSystem*)system;
- (ODClassType*)type;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRSnowShaderText : NSObject<EGShaderTextBuilder> {
@protected
    NSString* _fragment;
}
@property (nonatomic, readonly) NSString* fragment;

+ (instancetype)snowShaderText;
- (instancetype)init;
- (ODClassType*)type;
- (NSString*)vertex;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
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
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGTexture*)param;
+ (TRSnowShader*)instance;
+ (ODClassType*)type;
@end


