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

@class TRCollisionsTest;

@interface TRCollisionsTest : TSTestCase
+ (instancetype)collisionsTest;
- (instancetype)init;
- (ODClassType*)type;
- (TRLevel*)newLevel;
- (id<CNSet>)aCheckLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailForm*)form big:(BOOL)big;
- (void)testTurn;
- (void)testCross;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (CGFloat)carConLen;
+ (ODClassType*)type;
@end


