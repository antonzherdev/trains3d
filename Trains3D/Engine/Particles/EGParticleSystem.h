#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
#import "EGTypes.h"

@class EGParticleSystem;
@protocol EGParticle;

@interface EGParticleSystem : NSObject<EGController>
+ (id)particleSystem;
- (id)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@protocol EGParticle<EGController>
- (void)writeToArray:(CNMutablePArray*)array;
- (BOOL)isLive;
@end


