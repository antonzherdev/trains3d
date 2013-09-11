#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class EGPolygon;
@class EGCollisions;
@class EGCollision;
@class EGCollisionWorld;
@class EGCollisionBox;
@class EGCollisionBody;

@class EGCollisionsTest;

@interface EGCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (void)testDavidsStar;
- (void)testEmptyWithCrossedBoundingRects;
- (void)testEmptyWithoutCrossedBoundingRects;
- (void)testCollisions2;
+ (ODClassType*)type;
@end


