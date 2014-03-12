#import "objd.h"
#import "TRLevelView.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGParticleSystemView.h"
#import "EGShader.h"
@class TRWeather;
@class EGTextureFilter;
@class EGGlobal;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@class EGMutableIndexSourceGap;
@class EGIBO;
@class EGSettings;
@class EGShadowType;
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

@interface TRSnowView : TRPrecipitationView {
@private
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
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRSnowParticleSystem : EGParticleSystem {
@private
    TRWeather* _weather;
    CGFloat _strength;
    id<CNImSeq> _particles;
}
@property (nonatomic, readonly) TRWeather* weather;
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) id<CNImSeq> particles;

+ (instancetype)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRSnowParticle : NSObject<EGParticle> {
@private
    TRWeather* _weather;
    GEVec2 _position;
    CGFloat _size;
    GEVec2 _windVar;
    GEVec2 _urge;
    GEQuad _uv;
}
@property (nonatomic, readonly) TRWeather* weather;

+ (instancetype)snowParticleWithWeather:(TRWeather*)weather;
- (instancetype)initWithWeather:(TRWeather*)weather;
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
+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system;
- (instancetype)initWithSystem:(TRSnowParticleSystem*)system;
- (ODClassType*)type;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRSnowShaderText : NSObject<EGShaderTextBuilder> {
@private
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
@private
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


