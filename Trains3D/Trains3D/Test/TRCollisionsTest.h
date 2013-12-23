#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRCarType;
@class TRLevel;
@class TRLevelFactory;
@class TRCarsCollision;
@class TRCar;
@class TRRail;
@class TRRailroad;
@class TRTrainType;
@class TRCityColor;
@class TRTrain;

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
+ (ODClassType*)type;
@end


