#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "TRRailroadBuilderProcessor.h"
@class TRSwitchProcessor;
@class TRLevelRules;
@class TRLevel;
@class TRLevelView;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject<EGProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (BOOL)processEvent:(EGEvent*)event;
- (ODType*)type;
+ (ODType*)type;
@end


