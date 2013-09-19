#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class TRRailConnector;
@class EGCollisionBox2d;
@class EGCollisionWorld;
@class TRRailroad;
@class EGCollisionBody;
@class TRSwitch;
@class TRRailLight;
@class EGCrossPoint;
@class TRRailroadConnectorContent;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject<EGMouseProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (id)switchProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (void)_init;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


