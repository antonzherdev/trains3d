#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
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

@class TRLevelTest;

@interface TRLevelTest : TSTestCase
+ (instancetype)levelTest;
- (instancetype)init;
- (CNClassType*)type;
- (void)testLock;
- (NSString*)description;
+ (CNClassType*)type;
@end


