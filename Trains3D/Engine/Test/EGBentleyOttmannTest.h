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


