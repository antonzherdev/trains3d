#import "objd.h"
#import "EGProcessor.h"
#import "GEVec.h"
@class TRLevel;
@class TRRailConnector;
@class TRRailroad;
@class TRRailroadConnectorContent;
@class TRRailLight;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject<EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)switchProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


