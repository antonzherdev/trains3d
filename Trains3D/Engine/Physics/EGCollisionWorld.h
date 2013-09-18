#import "objd.h"
#import "GELine.h"

@class EGCollisionBody;

@class EGCollisionWorld;

@interface EGCollisionWorld : NSObject
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addBody:(EGCollisionBody*)body;
- (void)removeBody:(EGCollisionBody*)body;
- (id<CNIterable>)detect;
+ (ODClassType*)type;

- (id <CNSeq>)crossPointsWithSegment:(GELine3)line3;
- (id)closestCrossPointWithSegment:(GELine3)line3;
@end


