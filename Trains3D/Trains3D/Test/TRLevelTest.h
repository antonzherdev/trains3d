#import "objd.h"
#import "TSTestCase.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRLevelFactory;
@class TRLevel;
@class TRRail;
@class TRRailroad;
@class TRRailroadState;
@class TRSwitchState;
@class TRSwitch;
@class TRTrainType;
@class TRCityColor;
@class TRCarType;
@class TRTrain;

@class TRLevelTest;

@interface TRLevelTest : TSTestCase
+ (instancetype)levelTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testLock;
+ (ODClassType*)type;
@end


