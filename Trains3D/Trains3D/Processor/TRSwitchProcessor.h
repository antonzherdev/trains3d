#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
@class EGRectIndex;
#import "TRRailPoint.h"
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRLevel;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject<EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)switchProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
@end


