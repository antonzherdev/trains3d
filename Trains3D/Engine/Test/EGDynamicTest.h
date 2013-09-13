#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class EGDynamicWorld;
@class EGCollisionBox;
@class EGDynamicBody;
@class EGMatrix;
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


