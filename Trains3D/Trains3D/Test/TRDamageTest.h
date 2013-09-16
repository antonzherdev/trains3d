#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
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

@interface TRDamageTest : TSTestCase
+ (id)damageTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODClassType*)type;
@end


