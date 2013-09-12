#import "objd.h"
#import "CNTest.h"
@class EGCollisionWorld;
@class EGCollisionBox;
@class EGCollisionBody;
@class EGCollisionBox2d;

@class EGCollisionsTest;

@interface EGCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (void)testCollisions;
- (void)testCollisions2d;
+ (ODClassType*)type;
@end


