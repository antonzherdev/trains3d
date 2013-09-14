#import "objd.h"
#import "EGProcessor.h"
#import "EGRect.h"
#import "EGVec.h"
@class TRLevel;
@class EGRectIndex;
@class TRRailConnector;
@class TRRailroad;
@class TRRailroadConnectorContent;
@class TRLight;

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


