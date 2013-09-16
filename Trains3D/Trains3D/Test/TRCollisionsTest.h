#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
@class TRCarType;
@class TRLevel;
@class TRLevelFactory;
@class TRLevelRules;
@class TRCarsCollision;
@class TRCar;
@class TRRailForm;
@class TRRail;
@class TRRailroad;
@class TRTrainType;
@class TRCityColor;
@class TRTrain;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRCollisionsTest;

@interface TRCollisionsTest : TSTestCase
+ (id)collisionsTest;
- (id)init;
- (ODClassType*)type;
- (TRLevel*)newLevel;
- (id<CNSet>)checkLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailForm*)form;
- (void)testTurn;
- (void)testCross;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (CGFloat)carConLen;
+ (ODType*)type;
@end


