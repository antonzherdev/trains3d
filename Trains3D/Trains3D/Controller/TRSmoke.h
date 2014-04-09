#import "objd.h"
#import "EGBillboard.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGParticleSystem.h"
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
@class TRSmokeParticle;

@interface TRSmoke : EGEmissiveBillboardParticleSystem {
@private
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
    TRTrainState* __trainState;
}
@property (nonatomic, readonly) TRTrain* train;

+ (instancetype)smokeWithTrain:(TRTrain*)train;
- (instancetype)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (TRSmokeParticle*)generateParticle;
+ (float)particleSize;
+ (GEQuad)modelQuad;
+ (GEQuadrant)textureQuadrant;
+ (GEVec4)defColor;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : EGEmittedParticle<EGBillboardParticle> {
@private
    __weak TRWeather* _weather;
    GEVec3 _speed;
    GEVec3 _position;
    GEQuad _uv;
    GEQuad _model;
    GEVec4 _color;
}
@property (nonatomic, readonly, weak) TRWeather* weather;
@property (nonatomic) GEVec3 speed;

+ (instancetype)smokeParticleWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (instancetype)initWithLifeLength:(float)lifeLength weather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


