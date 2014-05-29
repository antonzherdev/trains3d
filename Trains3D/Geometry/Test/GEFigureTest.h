#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class GELineSegment;
@class GEThickLineSegment;
@class GEPolygon;

@class GEFigureTest;

@interface GEFigureTest : TSTestCase
+ (instancetype)figureTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testThickLine;
- (NSString*)description;
+ (CNClassType*)type;
@end


