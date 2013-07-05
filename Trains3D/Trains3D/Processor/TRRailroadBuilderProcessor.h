#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "EGTwoFingerTouchToMouse.h"
#import "TRRailroad.h"

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


