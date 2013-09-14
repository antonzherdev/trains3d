#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
#import "EGRect.h"
@class EGLineSegment;
@class EGThickLineSegment;
@class EGPolygon;

@class EGFigureTest;

@interface EGFigureTest : CNTestCase
+ (id)figureTest;
- (id)init;
- (ODClassType*)type;
- (void)testThickLine;
+ (ODClassType*)type;
@end


