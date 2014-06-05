#import "objd.h"
#import "TSTestCase.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "TRTrain.h"
#import "TRCity.h"
#import "TRCar.h"
@class TRLevelFactory;
@class TRLevel;
@class TRRail;
@class TRRailroad;
@class CNFuture;
@class TRRailroadState;
@class TRSwitchState;
@class TRSwitch;
@class CNThread;
@class CNChain;

@class TRLevelTest;

@interface TRLevelTest : TSTestCase
+ (instancetype)levelTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testLock;
- (void)testCity;
- (NSString*)description;
+ (CNClassType*)type;
@end


