#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
#import "GERect.h"
@class GELineSegment;
@class GEThickLineSegment;
@class GEPolygon;

@class GEFigureTest;

@interface GEFigureTest : TSTestCase
+ (id)figureTest;
- (id)init;
- (ODClassType*)type;
- (void)testThickLine;
+ (ODType*)type;
@end


