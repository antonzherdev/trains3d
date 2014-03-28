#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "ATActor.h"
@class TRForest;
@class EGMapSso;
@class TRScore;
@class ATSignal;

@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRSwitchState;
@class TRRailLight;
@class TRRailLightState;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadDamages;
@class TRRailroadState;
@class TRObstacleType;

@interface TRRailroadConnectorContent : NSObject
+ (instancetype)railroadConnectorContent;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (id<CNImSeq>)rails;
- (BOOL)isGreen;
- (BOOL)isEmpty;
- (void)cutDownTreesInForest:(TRForest*)forest;
+ (ODClassType*)type;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (instancetype)emptyConnector;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNImSeq>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (BOOL)isEmpty;
+ (TRRailroadConnectorContent*)instance;
+ (ODClassType*)type;
@end


@interface TRRail : TRRailroadConnectorContent {
@private
    GEVec2i _tile;
    TRRailForm* _form;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (instancetype)railWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (instancetype)initWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (ODClassType*)type;
- (BOOL)hasConnector:(TRRailConnector*)connector;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNImSeq>)rails;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (BOOL)canAddRail:(TRRail*)rail;
- (GELine2)line;
+ (ODClassType*)type;
@end


@interface TRSwitch : NSObject {
@private
    GEVec2i _tile;
    TRRailConnector* _connector;
    TRRail* _rail1;
    TRRail* _rail2;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;

+ (instancetype)switchWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (ODClassType*)type;
- (id<CNImSeq>)rails;
- (TRRailPoint)railPoint1;
- (TRRailPoint)railPoint2;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRSwitchState : TRRailroadConnectorContent {
@private
    TRSwitch* _switch;
    BOOL _firstActive;
}
@property (nonatomic, readonly) TRSwitch* aSwitch;
@property (nonatomic, readonly) BOOL firstActive;

+ (instancetype)switchStateWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (instancetype)initWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (ODClassType*)type;
- (TRRail*)activeRail;
- (id<CNImSeq>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRSwitchState*)turn;
- (TRRailConnector*)connector;
- (GEVec2i)tile;
+ (ODClassType*)type;
@end


@interface TRRailLight : NSObject {
@private
    GEVec2i _tile;
    TRRailConnector* _connector;
    TRRail* _rail;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRailLightState : TRRailroadConnectorContent {
@private
    TRRailLight* _light;
    BOOL _isGreen;
}
@property (nonatomic, readonly) TRRailLight* light;
@property (nonatomic, readonly) BOOL isGreen;

+ (instancetype)railLightStateWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (instancetype)initWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (ODClassType*)type;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (id<CNImSeq>)rails;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailLightState*)turn;
- (TRRailConnector*)connector;
- (GEVec2i)tile;
- (GEVec3)shift;
+ (ODClassType*)type;
@end


@interface TRObstacleType : ODEnum
+ (TRObstacleType*)damage;
+ (TRObstacleType*)aSwitch;
+ (TRObstacleType*)light;
+ (TRObstacleType*)end;
+ (NSArray*)values;
@end


@interface TRObstacle : NSObject {
@private
    TRObstacleType* _obstacleType;
    TRRailPoint _point;
}
@property (nonatomic, readonly) TRObstacleType* obstacleType;
@property (nonatomic, readonly) TRRailPoint point;

+ (instancetype)obstacleWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point;
- (instancetype)initWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRailroad : ATActor {
@private
    EGMapSso* _map;
    TRScore* _score;
    TRForest* _forest;
    CNMMapDefault* __connectorIndex;
    TRRailroadState* __state;
    ATSignal* _stateWasRestored;
    ATSignal* _switchWasTurned;
    ATSignal* _lightWasTurned;
    ATSignal* _railWasBuilt;
    ATSignal* _railWasRemoved;
    ATSignal* _lightWasBuiltOrRemoved;
}
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) ATSignal* stateWasRestored;
@property (nonatomic, readonly) ATSignal* switchWasTurned;
@property (nonatomic, readonly) ATSignal* lightWasTurned;
@property (nonatomic, readonly) ATSignal* railWasBuilt;
@property (nonatomic, readonly) ATSignal* railWasRemoved;
@property (nonatomic, readonly) ATSignal* lightWasBuiltOrRemoved;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (ODClassType*)type;
- (CNFuture*)state;
- (CNFuture*)restoreState:(TRRailroadState*)state;
- (CNFuture*)tryAddRail:(TRRail*)rail;
- (CNFuture*)tryAddRail:(TRRail*)rail free:(BOOL)free;
- (CNFuture*)turnASwitch:(TRSwitch*)aSwitch;
- (CNFuture*)turnLight:(TRRailLight*)light;
- (CNFuture*)removeRail:(TRRail*)rail;
- (CNFuture*)addDamageAtPoint:(TRRailPoint)point;
- (CNFuture*)fixDamageAtPoint:(TRRailPoint)point;
- (CNFuture*)isLockedRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRRailroadDamages : NSObject {
@private
    id<CNImSeq> _points;
    CNLazy* __lazy_index;
}
@property (nonatomic, readonly) id<CNImSeq> points;

+ (instancetype)railroadDamagesWithPoints:(id<CNImSeq>)points;
- (instancetype)initWithPoints:(id<CNImSeq>)points;
- (ODClassType*)type;
- (id<CNImMap>)index;
+ (ODClassType*)type;
@end


@interface TRRailroadState : NSObject {
@private
    CNImMapDefault* _connectorIndex;
    TRRailroadDamages* _damages;
    CNLazy* __lazy_rails;
    CNLazy* __lazy_switches;
    CNLazy* __lazy_lights;
}
@property (nonatomic, readonly) CNImMapDefault* connectorIndex;
@property (nonatomic, readonly) TRRailroadDamages* damages;

+ (instancetype)railroadStateWithConnectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages;
- (instancetype)initWithConnectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages;
- (ODClassType*)type;
- (id<CNImSeq>)rails;
- (id<CNImSeq>)switches;
- (id<CNImSeq>)lights;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailPointCorrection)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint)point;
- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint)from to:(CGFloat)to;
- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector;
- (BOOL)isLockedRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


