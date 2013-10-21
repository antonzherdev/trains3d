#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class EGCollisionBox2d;
@class EGCollisionWorld;
@class TRRailroad;
@class EGCollisionBody;
@class TRSwitch;
@class TRRailConnector;
@class TRRailLight;
@class EGCrossPoint;
@class TRRailroadConnectorContent;
@class EGGlobal;
@class EGDirector;

@class TRSwitchProcessor;

@interface TRSwitchProcessor : NSObject<EGInputProcessor, EGTapProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGCollisionWorld* world;

+ (id)switchProcessorWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
- (void)_init;
- (BOOL)tapEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


