#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
@class EGRectIndex;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRLevelRules;
@class TRLevel;

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


