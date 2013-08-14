#import "objd.h"
@class EGBentleyOttmann;
@class EGIntersection;
@class EGBentleyOttmannEvent;
@class EGBentleyOttmannPointEvent;
@class EGBentleyOttmannIntersectionEvent;
@class EGBentleyOttmannEventQueue;
@class EGPointClass;
@class EGSweepLine;
#import "CNTest.h"
@class CNPair;
@class CNPairIterator;
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
#import "EGTypes.h"
#import "CNSet.h"

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


