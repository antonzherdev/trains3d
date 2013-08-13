#import "objd.h"
@class EGBentleyOttmann;
@class EGIntersection;
@class EGBentleyOttmannEvent;
@class EGBentleyOttmannPointEvent;
@class EGBentleyOttmannIntersectionEvent;
@class EGBentleyOttmannEventQueue;
@class EGSweepLine;
#import "CNTest.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@class EGLineSegment;
#import "EGTypes.h"

@class EGBentleyOttmannTest;

@interface EGBentleyOttmannTest : CNTestCase
+ (id)bentleyOttmannTest;
- (id)init;
- (void)testMain;
- (void)testNoCross;
- (void)testVertical;
- (void)testOneStart;
- (void)testOneEnd;
- (void)testSameLines;
@end


