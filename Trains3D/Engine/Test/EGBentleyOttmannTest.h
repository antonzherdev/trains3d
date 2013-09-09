#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class EGLineSegment;
@class EGBentleyOttmann;
@class EGIntersection;

@class EGBentleyOttmannTest;

@interface EGBentleyOttmannTest : CNTestCase
+ (id)bentleyOttmannTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
- (void)testInPoint;
- (void)testNoCross;
- (void)testVertical;
- (void)testVerticalInPoint;
- (void)testOneStart;
- (void)testOneEnd;
- (void)testSameLines;
+ (ODClassType*)type;
@end


