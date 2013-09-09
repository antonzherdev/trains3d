#import "objd.h"
#import "EGProcessor.h"
#import "EGVec.h"
@class TRLevel;
@class TRRailroad;

@class TRLevelMenuProcessor;

@interface TRLevelMenuProcessor : NSObject<EGProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelMenuProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


