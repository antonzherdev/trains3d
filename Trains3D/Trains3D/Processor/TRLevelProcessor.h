#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "TRRailroadBuilderProcessor.h"
@class TRSwitchProcessor;
@class TRLevel;
@class TRLevelView;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject<EGProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (BOOL)processEvent:(EGEvent*)event;
@end


