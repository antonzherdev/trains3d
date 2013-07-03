#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
#import "TRRailroadBuilderProcessor.h"
#import "TRLevel.h"
#import "TRLevelView.h"

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)processEvent:(EGEvent*)event;
@end


