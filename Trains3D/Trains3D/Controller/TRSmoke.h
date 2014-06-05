#import "objd.h"
#import "PGParticleSystem.h"
#import "PGBillboard.h"
#import "PGVec.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "TRRailPoint.h"
@class TRWeather;
@class TRLevel;
@class CNFuture;

@class TRSmoke;
typedef struct TRSmokeParticle TRSmokeParticle;

@interface TRSmoke : PGEmissiveParticleSystem<PGBillboardParticleSystem> {
@public
    TRTrain* _train;
    TRTrainTypeR _trainType;
    CGFloat _speed;
    TRCarTypeR _engineCarType;
    __weak TRWeather* _weather;
    PGVec3 _tubePos;
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
- (unsigned int)doWriteToArray:(PGBillboardBufferData*)array;
- (NSString*)description;
+ (CGFloat)dragCoefficient;
+ (float)particleSize;
+ (PGQuad)modelQuad;
+ (PGQuadrant)textureQuadrant;
+ (PGVec4)defColor;
+ (CNClassType*)type;
@end


struct TRSmokeParticle {
    char life;
    PGVec3 speed;
    PGBillboardParticle billboard;
    float lifeTime;
};
static inline TRSmokeParticle TRSmokeParticleMake(char life, PGVec3 speed, PGBillboardParticle billboard, float lifeTime) {
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



