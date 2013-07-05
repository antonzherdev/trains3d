#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;
@class TRLevel;
@class TRLevelView;
@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)processEvent:(EGEvent*)event;
@end


