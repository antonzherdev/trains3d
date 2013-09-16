#import "objd.h"
#import "TSTestCase.h"
@class EGCollisionWorld;
@class EGCollisionBox;
@class EGCollisionBody;
@class EGCollisionBox2d;

@class EGCollisionsTest;

@interface EGCollisionsTest : TSTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (void)testCollisions;
- (void)testCollisions2d;
+ (ODType*)type;
@end


