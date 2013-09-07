#import "objd.h"
#import "CNTest.h"
@protocol CNSet;
@protocol CNMutableSet;
@class CNHashSetBuilder;
@class NSSet;
@class NSMutableSet;
#import "EGTypes.h"
@class EGCollisions;
@class EGCollision;
#import "EGVec.h"
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
@class TREngineType;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;

@class TRCollisionsTest;

@interface TRCollisionsTest : CNTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (TRLevel*)newLevel;
- (id<CNSet>)checkLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level delta:(CGFloat)delta form:(TRRailForm*)form;
- (void)testTurn;
- (void)testCross;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (ODClassType*)type;
@end


