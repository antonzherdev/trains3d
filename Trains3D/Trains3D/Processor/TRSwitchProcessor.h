#import "objd.h"
#import "CNActor.h"
#import "PGInput.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "TRCity.h"
@class CNSignal;
@class TRLevel;
@class CNFuture;
@class TRRailroad;
@class PGDirector;
@class TRRailroadState;
@class PGMat4;
@class TRSwitchState;
@class PGMapSso;
@class TRRailroadConnectorContent;
@class CNChain;
@class TRRailLightState;
@class PGMatrixModel;
@class CNSortBuilder;
@class PGPlatform;
@class CNReact;

@class TRSwitchProcessor;
@class TRSwitchProcessorItem;

@interface TRSwitchProcessor : CNActor<PGInputProcessor> {
@public
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)switchProcessorWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (BOOL)processEvent:(id<PGEvent>)event;
- (CNFuture*)doProcessEvent:(id<PGEvent>)event;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNSignal*)strangeClick;
+ (CNClassType*)type;
@end


@interface TRSwitchProcessorItem : NSObject {
@public
    TRRailroadConnectorContent* _content;
    PGVec3 _p0;
    PGVec3 _p1;
    PGVec3 _p2;
    PGVec3 _p3;
}
@property (nonatomic, readonly) TRRailroadConnectorContent* content;
@property (nonatomic, readonly) PGVec3 p0;
@property (nonatomic, readonly) PGVec3 p1;
@property (nonatomic, readonly) PGVec3 p2;
@property (nonatomic, readonly) PGVec3 p3;

+ (instancetype)switchProcessorItemWithContent:(TRRailroadConnectorContent*)content p0:(PGVec3)p0 p1:(PGVec3)p1 p2:(PGVec3)p2 p3:(PGVec3)p3;
- (instancetype)initWithContent:(TRRailroadConnectorContent*)content p0:(PGVec3)p0 p1:(PGVec3)p1 p2:(PGVec3)p2 p3:(PGVec3)p3;
- (CNClassType*)type;
+ (TRSwitchProcessorItem*)applyContent:(TRRailroadConnectorContent*)content rect:(PGRect)rect;
- (PGQuad)quad;
- (TRSwitchProcessorItem*)mulMat4:(PGMat4*)mat4;
- (PGRect)boundingRect;
- (TRSwitchProcessorItem*)expandVec2:(PGVec2)vec2;
- (BOOL)containsVec2:(PGVec2)vec2;
- (float)distanceVec2:(PGVec2)vec2;
- (NSString*)description;
+ (CNClassType*)type;
@end


