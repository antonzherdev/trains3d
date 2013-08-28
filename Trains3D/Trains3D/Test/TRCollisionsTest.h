#import "objd.h"
#import "CNTest.h"
#import "CNSet.h"
#import "EGTypes.h"
@class EGCollisions;
@class EGCollision;
@class TRColor;
@class TRLevelRules;
@class TRLevel;
@class TRLevelFactory;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRTrainType;
@class TRTrain;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;

@class TRCollisionsTest;

@interface TRCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (TRLevel*)newLevel;
- (id<CNSet>)checkLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level delta:(CGFloat)delta form:(TRRailForm*)form;
- (void)testTurn;
- (void)testCross;
- (ODType*)type;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (ODType*)type;
@end


