#import "objd.h"
#import "CNTest.h"
#import "GEVec.h"
#import "GERect.h"
@class GELineSegment;
@class GEThickLineSegment;
@class GEPolygon;

@class GEFigureTest;

@interface GEFigureTest : CNTestCase
+ (id)figureTest;
- (id)init;
- (ODClassType*)type;
- (void)testThickLine;
+ (ODClassType*)type;
@end


