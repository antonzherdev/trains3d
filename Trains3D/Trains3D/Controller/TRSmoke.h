#import "objd.h"
#import "EGParticleSystem.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRRailPoint.h"
@class TRWeather;
@class TRLevel;
@class CNFuture;

@class TRSmoke;
typedef struct TRSmokeParticle TRSmokeParticle;

@interface TRSmoke : EGEmissiveParticleSystem<EGBillboardParticleSystem> {
@protected
    TRTrain* _train;
    TRTrainTypeR _trainType;
    CGFloat _speed;
    TRCarTypeR _engineCarType;
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
- (CNClassType*)type;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (unsigned int)doWriteToArray:(EGBillboardBufferData*)array;
- (NSString*)description;
+ (CGFloat)dragCoefficient;
+ (float)particleSize;
+ (GEQuad)modelQuad;
+ (GEQuadrant)textureQuadrant;
+ (GEVec4)defColor;
+ (CNClassType*)type;
@end


struct TRSmokeParticle {
    char life;
    GEVec3 speed;
    EGBillboardParticle billboard;
    float lifeTime;
};
static inline TRSmokeParticle TRSmokeParticleMake(char life, GEVec3 speed, EGBillboardParticle billboard, float lifeTime) {
    return (TRSmokeParticle){life, speed, billboard, lifeTime};
}
NSString* trSmokeParticleDescription(TRSmokeParticle self);
BOOL trSmokeParticleIsEqualTo(TRSmokeParticle self, TRSmokeParticle to);
NSUInteger trSmokeParticleHash(TRSmokeParticle self);
CNPType* trSmokeParticleType();
@interface TRSmokeParticleWrap : NSObject
@property (readonly, nonatomic) TRSmokeParticle value;

+ (id)wrapWithValue:(TRSmokeParticle)value;
- (id)initWithValue:(TRSmokeParticle)value;
@end



