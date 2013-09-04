#import "objd.h"
#import "CNTest.h"
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
#import "EGTypes.h"
#import "EGVec.h"

@class EGFigureTest;

@interface EGFigureTest : CNTestCase
+ (id)figureTest;
- (id)init;
- (ODClassType*)type;
- (void)testThickLine;
+ (ODClassType*)type;
@end


