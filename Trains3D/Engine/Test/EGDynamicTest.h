#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class EGDynamicWorld;
@class EGCollisionBox;
@class EGDynamicBody;
@class EGMatrix;

@class EGDynamicTest;

@interface EGDynamicTest : CNTestCase
+ (id)dynamicTest;
- (id)init;
- (ODClassType*)type;
- (void)testSimple;
+ (ODClassType*)type;
@end


