#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class EGMapSso;
@class TRLevelFactory;
@class TRScore;
@class TRRailroad;
@class TRRailForm;
@class TRRail;
@class TRRailPoint;
@class TRObstacle;
@class TRObstacleType;
@class TRRailPointCorrection;

@class TRDamageTest;

@interface TRDamageTest : CNTestCase
+ (id)damageTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODClassType*)type;
@end


