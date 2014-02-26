#import "objd.h"
#import "EGScene.h"

@class EGEmissiveParticleSystem;
@class EGEmittedParticle;
@protocol EGParticleSystem;
@protocol EGParticle;

@protocol EGParticleSystem<EGUpdatable>
- (id<CNSeq>)particles;
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGParticle<EGUpdatable>
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
@end


@interface EGEmissiveParticleSystem : NSObject<EGParticleSystem>
+ (instancetype)emissiveParticleSystem;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)hasParticles;
+ (ODClassType*)type;
@end


@interface EGEmittedParticle : NSObject<EGParticle>
@property (nonatomic, readonly) float lifeLength;

+ (instancetype)emittedParticleWithLifeLength:(float)lifeLength;
- (instancetype)initWithLifeLength:(float)lifeLength;
- (ODClassType*)type;
- (float)lifeTime;
- (BOOL)isLive;
- (void)updateWithDelta:(CGFloat)delta;
- (void)updateT:(float)t dt:(float)dt;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
+ (ODClassType*)type;
@end


