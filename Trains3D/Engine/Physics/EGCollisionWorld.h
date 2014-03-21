#import "objd.h"
#import "GEVec.h"
#import "EGCollision.h"

@class EGCollisionBody;

@class EGCollisionWorld;

@interface EGCollisionWorld : EGPhysicsWorld
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (id<CNIterable>)detect;
+ (ODClassType*)type;

- (id <CNImSeq>)crossPointsWithSegment:(GELine3)line3;
- (id)closestCrossPointWithSegment:(GELine3)line3;
@end


