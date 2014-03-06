#import "objd.h"
#import "ATTypedActor.h"
#import "EGScene.h"

@class EGParticleSystem;
@class EGEmissiveParticleSystem;
@class EGEmittedParticle;
@protocol EGParticle;

@interface EGParticleSystem : ATTypedActor
@property (nonatomic) NSUInteger _lastWriteCount;

+ (instancetype)particleSystem;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)lastWriteCount;
- (CNFuture*)writeToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array;
+ (ODClassType*)type;
@end


@protocol EGParticle<EGUpdatable>
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface EGEmissiveParticleSystem : EGParticleSystem
@property (nonatomic, readonly) NSMutableArray* _particles;

+ (instancetype)emissiveParticleSystem;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)doUpdateWithDelta:(CGFloat)delta;
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


