#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
#import "TRRailroadBuilderProcessor.h"
@class TRSwitchProcessor;
@class TRLevel;
@class TRLevelView;
@class TRRail;
@class TRSwitch;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (BOOL)processEvent:(EGEvent*)event;
@end


