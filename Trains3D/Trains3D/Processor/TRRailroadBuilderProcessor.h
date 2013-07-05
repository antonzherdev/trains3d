#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
@class EGTwoFingerTouchToMouse;
@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;

@interface TRRailroadBuilderProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)processEvent:(EGEvent*)event;
@end


@interface TRRailroadBuilderMouseProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (id)mouseDragEvent:(EGEvent*)event;
- (id)mouseUpEvent:(EGEvent*)event;
@end


