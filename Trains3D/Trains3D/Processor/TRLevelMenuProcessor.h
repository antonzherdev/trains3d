#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class TRRailroad;

@class TRLevelMenuProcessor;

@interface TRLevelMenuProcessor : NSObject<EGInputProcessor, EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelMenuProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


