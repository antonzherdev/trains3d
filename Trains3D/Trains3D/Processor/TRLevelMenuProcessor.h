#import "objd.h"
#import "EGProcessor.h"
@class TRLevelRules;
@class TRLevel;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelMenuProcessor;

@interface TRLevelMenuProcessor : NSObject<EGProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelMenuProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


