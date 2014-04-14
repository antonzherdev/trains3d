#import "objd.h"
#import "EGParticleSystem2.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRTrain;
@class TRTrainType;
@class TRCarType;
@class TRWeather;
@class TRLevel;
@class TREngineType;
@class TRTrainState;
@class TRLiveTrainState;
@class TRLiveCarState;

@class TRSmoke;
typedef struct TRSmokeParticle TRSmokeParticle;

@interface TRSmoke : EGEmissiveParticleSystem2<EGBillboardParticleSystem2> {
@protected
    TRTrain* _train;
    TRTrainType* _trainType;
    CGFloat _speed;
    TRCarType* _engineCarType;
    __weak TRWeather* _weather;
    GEVec3 _tubePos;
    CGFloat _emitEvery;
    NSInteger _lifeLength;
    CGFloat _emitTime;
    CGFloat _tubeSize;
}
@property (nonatomic, readonly) TRTrain* train;

+ (instancetype)smokeWithTrain:(TRTrain*)train;
- (instancetype)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (ODPType*)particleType;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (void)doWriteToArray:(EGBillboardBufferData*)array;
+ (CGFloat)dragCoefficient;
+ (float)particleSize;
+ (GEQuad)modelQuad;
+ (GEQuadrant)textureQuadrant;
+ (GEVec4)defColor;
+ (ODClassType*)type;
@end


struct TRSmokeParticle {
    char life;
    GEVec3 speed;
    EGBillboardParticle2 billboard;
    float lifeTime;
};
static inline TRSmokeParticle TRSmokeParticleMake(char life, GEVec3 speed, EGBillboardParticle2 billboard, float lifeTime) {
    return (TRSmokeParticle){life, speed, billboard, lifeTime};
}
static inline BOOL TRSmokeParticleEq(TRSmokeParticle s1, TRSmokeParticle s2) {
    return s1.life == s2.life && GEVec3Eq(s1.speed, s2.speed) && EGBillboardParticle2Eq(s1.billboard, s2.billboard) && eqf4(s1.lifeTime, s2.lifeTime);
}
static inline NSUInteger TRSmokeParticleHash(TRSmokeParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.life;
    hash = hash * 31 + GEVec3Hash(self.speed);
    hash = hash * 31 + EGBillboardParticle2Hash(self.billboard);
    hash = hash * 31 + float4Hash(self.lifeTime);
    return hash;
}
NSString* TRSmokeParticleDescription(TRSmokeParticle self);
ODPType* trSmokeParticleType();
@interface TRSmokeParticleWrap : NSObject
@property (readonly, nonatomic) TRSmokeParticle value;

+ (id)wrapWithValue:(TRSmokeParticle)value;
- (id)initWithValue:(TRSmokeParticle)value;
@end



