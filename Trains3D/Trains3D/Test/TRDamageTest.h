#import "objd.h"
#import "CNTest.h"
#import "EGTypes.h"
@class EGMapSso;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;
@class TRLevelFactory;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRDamageTest;

@interface TRDamageTest : CNTestCase
+ (id)damageTest;
- (id)init;
- (void)testMain;
@end

