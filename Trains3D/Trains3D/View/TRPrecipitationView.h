#import "objd.h"
#import "EGScene.h"
#import "EGParticleSystem.h"
#import "GEVec.h"
#import "EGShader.h"
@class TRPrecipitation;
@class TRPrecipitationType;
@class EGBlendFunction;
@class EGVertexBufferDesc;
@protocol EGIndexSource;
@class EGEmptyIndexSource;

@class TRPrecipitationView;
@class TRRainView;
@class TRRainParticleSystem;
@class TRRainParticle;
@class TRRainSystemView;
@class TRRainShader;
typedef struct TRRainData TRRainData;

@interface TRPrecipitationView : NSObject<EGController>
+ (id)precipitationView;
- (id)init;
- (ODClassType*)type;
+ (TRPrecipitationView*)applyPrecipitation:(TRPrecipitation*)precipitation;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRainView : TRPrecipitationView
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) TRRainParticleSystem* system;
@property (nonatomic, readonly) TRRainSystemView* view;

+ (id)rainViewWithStrength:(CGFloat)strength;
- (id)initWithStrength:(CGFloat)strength;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRRainParticleSystem : NSObject<EGParticleSystem>
@property (nonatomic, readonly) CGFloat strength;
@property (nonatomic, readonly) id<CNSeq> particles;

+ (id)rainParticleSystemWithStrength:(CGFloat)strength;
- (id)initWithStrength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRainParticle : NSObject<EGParticle>
+ (id)rainParticle;
- (id)init;
- (ODClassType*)type;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


struct TRRainData {
    GEVec2 position;
};
static inline TRRainData TRRainDataMake(GEVec2 position) {
    return (TRRainData){position};
}
static inline BOOL TRRainDataEq(TRRainData s1, TRRainData s2) {
    return GEVec2Eq(s1.position, s2.position);
}
static inline NSUInteger TRRainDataHash(TRRainData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.position);
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
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface TRRainShader : EGShader
+ (id)rainShader;
- (id)init;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(NSObject*)param;
+ (TRRainShader*)instance;
+ (ODClassType*)type;
@end


