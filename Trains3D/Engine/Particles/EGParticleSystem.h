#import "objd.h"
#import "ATActor.h"
#import "EGScene.h"

@class EGParticleSystem;
@class EGEmissiveParticleSystem;
@class EGEmittedParticle;
@protocol EGParticle;

@interface EGParticleSystem : ATActor {
@protected
    NSUInteger __lastWriteCount;
}
@property (nonatomic) NSUInteger _lastWriteCount;

+ (instancetype)particleSystem;
- (instancetype)init;
- (ODClassType*)type;
- (NSArray*)particles;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (CNFuture*)lastWriteCount;
- (CNFuture*)writeToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array;
- (void)doWriteToMaxCount:(NSUInteger)maxCount array:(CNVoidRefArray)array;
+ (ODClassType*)type;
@end


@protocol EGParticle<EGUpdatable>
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
@end


@interface EGEmissiveParticleSystem : EGParticleSystem {
@protected
    NSMutableArray* __particles;
}
+ (instancetype)emissiveParticleSystem;
- (instancetype)init;
- (ODClassType*)type;
- (NSArray*)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)doUpdateWithDelta:(CGFloat)delta;
- (BOOL)hasParticles;
+ (ODClassType*)type;
@end


@interface EGEmittedParticle : NSObject<EGParticle> {
@protected
    float _lifeLength;
    float __lifeTime;
}
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


