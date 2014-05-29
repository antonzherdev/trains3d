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
+ (instancetype)dynamicTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)runSecondInWorld:(EGDynamicWorld*)world;
- (void)testSimple;
- (void)testFriction;
- (NSString*)description;
+ (CNClassType*)type;
@end


