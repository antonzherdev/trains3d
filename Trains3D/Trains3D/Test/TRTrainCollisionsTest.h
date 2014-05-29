#import "objd.h"
#import "TSTestCase.h"
#import "TRCar.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRCity.h"
@class TRLevel;
@class TRLevelFactory;
@class CNThread;
@class CNFuture;
@class TRCarsCollision;
@class CNChain;
@class TRRail;
@class TRRailroad;
@class TRRailroadState;
@class TRRailroadDamages;
@class TRTrainCollisions;

@class TRTrainCollisionsTest;

@interface TRTrainCollisionsTest : TSTestCase
+ (instancetype)trainCollisionsTest;
- (instancetype)init;
- (CNClassType*)type;
- (TRLevel*)newLevel;
- (id<CNSet>)aCheckLevel:(TRLevel*)level;
- (void)testStraight;
- (void)doTest1ForLevel:(TRLevel*)level form:(TRRailFormR)form big:(BOOL)big;
- (void)testTurn;
- (void)testCross;
- (void)emulateLevel:(TRLevel*)level seconds:(CGFloat)seconds;
- (void)testSimulation;
- (NSString*)description;
+ (CGFloat)carLen;
+ (CGFloat)carWidth;
+ (CGFloat)carConLen;
+ (CNClassType*)type;
@end


