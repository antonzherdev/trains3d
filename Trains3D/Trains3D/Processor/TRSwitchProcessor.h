#import "objd.h"
#import "CNActor.h"
#import "EGInput.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "TRCity.h"
@class CNSignal;
@class TRLevel;
@class CNFuture;
@class TRRailroad;
@class EGDirector;
@class TRRailroadState;
@class GEMat4;
@class TRSwitchState;
@class EGMapSso;
@class TRRailroadConnectorContent;
@class CNChain;
@class TRRailLightState;
@class EGMatrixModel;
@class CNSortBuilder;
@class EGPlatform;
@class CNReact;

@class TRSwitchProcessor;
@class TRSwitchProcessorItem;

@interface TRSwitchProcessor : CNActor<EGInputProcessor> {
@protected
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)switchProcessorWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (BOOL)processEvent:(id<EGEvent>)event;
- (CNFuture*)doProcessEvent:(id<EGEvent>)event;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNSignal*)strangeClick;
+ (CNClassType*)type;
@end


@interface TRSwitchProcessorItem : NSObject {
@protected
    TRRailroadConnectorContent* _content;
    GEVec3 _p0;
    GEVec3 _p1;
    GEVec3 _p2;
    GEVec3 _p3;
}
@property (nonatomic, readonly) TRRailroadConnectorContent* content;
@property (nonatomic, readonly) GEVec3 p0;
@property (nonatomic, readonly) GEVec3 p1;
@property (nonatomic, readonly) GEVec3 p2;
@property (nonatomic, readonly) GEVec3 p3;

+ (instancetype)switchProcessorItemWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3;
- (instancetype)initWithContent:(TRRailroadConnectorContent*)content p0:(GEVec3)p0 p1:(GEVec3)p1 p2:(GEVec3)p2 p3:(GEVec3)p3;
- (CNClassType*)type;
+ (TRSwitchProcessorItem*)applyContent:(TRRailroadConnectorContent*)content rect:(GERect)rect;
- (GEQuad)quad;
- (TRSwitchProcessorItem*)mulMat4:(GEMat4*)mat4;
- (GERect)boundingRect;
- (TRSwitchProcessorItem*)expandVec2:(GEVec2)vec2;
- (BOOL)containsVec2:(GEVec2)vec2;
- (float)distanceVec2:(GEVec2)vec2;
- (NSString*)description;
+ (CNClassType*)type;
@end


