#import "objd.h"
#import "EGProcessor.h"
@class TRLevel;
@class TRRailroadBuilderProcessor;
@class TRRailroad;
@class TRSwitchProcessor;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject<EGProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODType*)type;
@end


