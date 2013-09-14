#import "objd.h"
#import "CNTest.h"
#import "GEVec.h"
@class GELineSegment;
@class GEBentleyOttmann;
@class GEIntersection;

@class GEBentleyOttmannTest;

@interface GEBentleyOttmannTest : CNTestCase
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


