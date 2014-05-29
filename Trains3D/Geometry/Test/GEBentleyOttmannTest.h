#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class GELineSegment;
@class GEBentleyOttmann;
@class GEIntersection;

@class GEBentleyOttmannTest;

@interface GEBentleyOttmannTest : TSTestCase
+ (instancetype)bentleyOttmannTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testMain;
- (void)testInPoint;
- (void)testNoCross;
- (void)testVertical;
- (void)testVerticalInPoint;
- (void)testOneStart;
- (void)testOneEnd;
- (void)testSameLines;
- (NSString*)description;
+ (CNClassType*)type;
@end


