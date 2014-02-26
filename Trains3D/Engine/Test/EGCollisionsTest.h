#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class EGCollisionWorld;
@class EGCollisionBox;
@class EGCollisionBody;
@class EGCollisionBox2d;
@class EGCrossPoint;

@class EGCollisionsTest;

@interface EGCollisionsTest : TSTestCase
+ (instancetype)collisionsTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testCollisions;
- (void)testCollisions2d;
- (void)testRay;
+ (ODClassType*)type;
@end


