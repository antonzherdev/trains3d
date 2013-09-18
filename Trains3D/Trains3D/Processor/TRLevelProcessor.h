#import "objd.h"
#import "EGInput.h"
@class TRLevel;
@class TRRailroadBuilderProcessor;
@class TRRailroad;
@class TRSwitchProcessor;

@class TRLevelProcessor;

@interface TRLevelProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


