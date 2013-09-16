#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class EGDynamicWorld;
@class EGCollisionBox;
@class EGRigidBody;
@class GEMat4;
@class EGCollisionPlane;

@class EGDynamicTest;

@interface EGDynamicTest : TSTestCase
+ (id)dynamicTest;
- (id)init;
- (ODClassType*)type;
- (void)runSecondInWorld:(EGDynamicWorld*)world;
- (void)testSimple;
- (void)testFriction;
+ (ODClassType*)type;
@end


