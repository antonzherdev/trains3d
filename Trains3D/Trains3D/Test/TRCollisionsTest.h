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
@class TRRailroad;
@class TRRailroadBuilder;
@class TRTrain;
@class TRCar;
@class TRTrainGenerator;

@class TRCollisionsTest;

@interface TRCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (TRLevel*)newLevel;
- (NSSet*)checkLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level delta:(double)delta form:(TRRailForm*)form;
- (void)testTurn;
- (void)testCross;
+ (double)carLen;
+ (double)carWidth;
+ (double)carsDelta;
@end


