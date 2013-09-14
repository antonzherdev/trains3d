#import "objd.h"
#import "CNTest.h"
#import "GEVec.h"
@class EGDynamicWorld;
@class EGCollisionBox;
@class EGRigidBody;
@class GEMatrix;
@class EGCollisionPlane;

@class EGDynamicTest;

@interface EGDynamicTest : CNTestCase
+ (id)dynamicTest;
- (id)init;
- (ODClassType*)type;
- (void)runSecondInWorld:(EGDynamicWorld*)world;
- (void)testSimple;
- (void)testFriction;
+ (ODClassType*)type;
@end


