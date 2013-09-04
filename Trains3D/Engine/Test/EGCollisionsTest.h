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
#import "EGVec.h"

@class EGCollisionsTest;

@interface EGCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (void)testDavidsStar;
- (void)testEmptyWithCrossedBoundingRects;
- (void)testEmptyWithoutCrossedBoundingRects;
+ (ODClassType*)type;
@end


