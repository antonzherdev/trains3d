#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "TRRailroad.h"

@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;

@interface TRRailroadBuilderProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (void)processEvent:(EGEvent*)event;
@end


@interface TRRailroadBuilderMouseProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (void)downEvent:(EGEvent*)event;
- (void)dragEvent:(EGEvent*)event;
- (void)upEvent:(EGEvent*)event;
@end


