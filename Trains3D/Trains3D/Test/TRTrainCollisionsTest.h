#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRCarType;
@class TRLevel;
@class TRLevelFactory;
@class TRCarsCollision;
@class TRRail;
@class TRRailroad;
@class TRTrainType;
@class TRCityColor;
@class TRTrain;
@class TRRailroadState;
@class TRRailroadDamages;
@class TRTrainsCollisionWorld;

@class TRTrainCollisionsTest;

@interface TRTrainCollisionsTest : TSTestCase
+ (instancetype)trainCollisionsTest;
- (instancetype)init;
- (ODClassType*)type;
- (TRLevel*)newLevel;
- (id<CNSet>)aCheckLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailForm*)form big:(BOOL)big;
- (void)testTurn;
- (void)testCross;
- (void)emulateLevel:(TRLevel*)level seconds:(CGFloat)seconds;
- (void)testSimulation;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (CGFloat)carConLen;
+ (ODClassType*)type;
@end


