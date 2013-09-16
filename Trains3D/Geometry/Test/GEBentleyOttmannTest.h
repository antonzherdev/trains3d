#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class GELineSegment;
@class GEBentleyOttmann;
@class GEIntersection;

@class GEBentleyOttmannTest;

@interface GEBentleyOttmannTest : TSTestCase
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
+ (ODType*)type;
@end


