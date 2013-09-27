#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class TRLevelFactory;
@class TRRailForm;
@class TRRail;
@class TRRailroad;
@class TRRailPoint;
@class TRObstacle;
@class TRObstacleType;
@class TRRailPointCorrection;

@class TRDamageTest;

@interface TRDamageTest : TSTestCase
+ (id)damageTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODClassType*)type;
@end


