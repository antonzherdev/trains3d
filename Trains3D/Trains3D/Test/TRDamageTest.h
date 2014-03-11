#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRLevelFactory;
@class TRRail;
@class TRRailroad;
@class TRObstacle;
@class TRObstacleType;
@class TRRailroadState;

@class TRDamageTest;

@interface TRDamageTest : TSTestCase
+ (instancetype)damageTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODClassType*)type;
@end


