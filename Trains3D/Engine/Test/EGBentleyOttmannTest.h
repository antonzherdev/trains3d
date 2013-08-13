#import "objd.h"
@class EGBentleyOttmann;
@protocol EGBentleyOttmannEvent;
@class EGBentleyOttmannEventQueue;
@class EGBentleyOttmannEventStart;
@class EGBentleyOttmannEventEnd;
@class EGBentleyOttmannIntersection;
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
@end


