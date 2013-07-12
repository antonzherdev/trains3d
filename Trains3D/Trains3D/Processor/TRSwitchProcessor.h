#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
#import "TRRailPoint.h"
@class TRRail;
@class TRSwitch;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)switchProcessorWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
@end


