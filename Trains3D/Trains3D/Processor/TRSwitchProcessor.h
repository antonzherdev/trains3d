#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class EGGlobal;
@class EGContext;
@class TRRailroad;
@class GEMat4;
@class TRSwitchState;
@class TRRailConnector;
@class EGMapSso;
@class TRCity;
@class TRCityAngle;
@class TRRailForm;
@class TRRailroadState;
@class TRRailroadConnectorContent;
@class TRRailLightState;
@class EGMatrixModel;
@class EGDirector;

@class TRSwitchProcessor;
@class TRSwitchProcessorItem;

@interface TRSwitchProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)switchProcessorWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (BOOL)processEvent:(id<EGEvent>)event;
- (EGRecognizers*)recognizers;
+ (CNNotificationHandle*)strangeClickNotification;
+ (ODClassType*)type;
@end


@interface TRSwitchProcessorItem : NSObject
@property (nonatomic, readonly) TRRailroadConnectorContent* content;
@property (nonatomic, readonly) GEVec3 p0;
@property (nonatomic, readonly) GEVec3 p1;
@property (nonatomic, readonly) GEVec3 p2;
@property (nonatomic, readonly) GEVec3 p3;

+ (instancetype)switchProcessorItemWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3;
- (instancetype)initWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3;
- (ODClassType*)type;
+ (TRSwitchProcessorItem*)applyContent:(TRRailroadConnectorContent*)content rect:(GERect)rect;
- (GEQuad)quad;
- (TRSwitchProcessorItem*)mulMat4:(GEMat4*)mat4;
- (GERect)boundingRect;
- (TRSwitchProcessorItem*)expandVec2:(GEVec2)vec2;
- (BOOL)containsVec2:(GEVec2)vec2;
- (float)distanceVec2:(GEVec2)vec2;
+ (ODClassType*)type;
@end


