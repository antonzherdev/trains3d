#import "objd.h"
#import "CNTest.h"
#import "EGVec.h"
@class TRCarType;
@class TRLevel;
@class TRLevelFactory;
@class TRLevelRules;
@class EGCollision;
@class TRRailForm;
@class TRRail;
@class TRRailroad;
@class TRTrainType;
@class TRColor;
@class TRCar;
@class TRTrain;
@class TRRailPoint;
@class TRRailPointCorrection;

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


