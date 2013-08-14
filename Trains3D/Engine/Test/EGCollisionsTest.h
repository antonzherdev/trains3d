#import "objd.h"
#import "CNTest.h"
@class CNPair;
@class CNPairIterator;
#import "EGTypes.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
@class EGCollisions;
@class EGCollision;

@class EGCollisionsTest;

@interface EGCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (void)testDavidsStar;
- (void)testEmptyWithCrossedBoundingRects;
- (void)testEmptyWithoutCrossedBoundingRects;
@end


