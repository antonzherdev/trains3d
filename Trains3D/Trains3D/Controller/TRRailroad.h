#import "objd.h"
#import "TRRailPoint.h"
#import "GEVec.h"
#import "CNActor.h"
@class TRForest;
@class EGMapSso;
@class TRScore;
@class CNSignal;
@class CNFuture;
@class CNChain;

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

typedef enum TRObstacleTypeR {
    TRObstacleType_Nil = 0,
    TRObstacleType_damage = 1,
    TRObstacleType_switch = 2,
    TRObstacleType_light = 3,
    TRObstacleType_end = 4
} TRObstacleTypeR;
@interface TRObstacleType : CNEnum
+ (NSArray*)values;
@end
extern TRObstacleType* TRObstacleType_Values[5];
extern TRObstacleType* TRObstacleType_damage_Desc;
extern TRObstacleType* TRObstacleType_switch_Desc;
extern TRObstacleType* TRObstacleType_light_Desc;
extern TRObstacleType* TRObstacleType_end_Desc;


@interface TRRailroadConnectorContent : NSObject
+ (instancetype)railroadConnectorContent;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe;
- (NSArray*)rails;
- (BOOL)isGreen;
- (BOOL)isEmpty;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (instancetype)emptyConnector;
- (instancetype)init;
- (CNClassType*)type;
- (NSArray*)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (BOOL)isEmpty;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (TRRailroadConnectorContent*)instance;
+ (CNClassType*)type;
@end


@interface TRRail : TRRailroadConnectorContent {
@protected
    GEVec2i _tile;
    TRRailFormR _form;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailFormR form;

+ (instancetype)railWithTile:(GEVec2i)tile form:(TRRailFormR)form;
- (instancetype)initWithTile:(GEVec2i)tile form:(TRRailFormR)form;
- (CNClassType*)type;
- (BOOL)hasConnector:(TRRailConnectorR)connector;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (NSArray*)rails;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe;
- (BOOL)canAddRail:(TRRail*)rail;
- (GELine2)line;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRSwitch : NSObject {
@protected
    GEVec2i _tile;
    TRRailConnectorR _connector;
    TRRail* _rail1;
    TRRail* _rail2;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnectorR connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;

+ (instancetype)switchWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (CNClassType*)type;
- (NSArray*)rails;
- (TRRailPoint)railPoint1;
- (TRRailPoint)railPoint2;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRSwitchState : TRRailroadConnectorContent {
@protected
    TRSwitch* _switch;
    BOOL _firstActive;
}
@property (nonatomic, readonly) TRSwitch* aSwitch;
@property (nonatomic, readonly) BOOL firstActive;

+ (instancetype)switchStateWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (instancetype)initWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (CNClassType*)type;
- (TRRail*)activeRail;
- (NSArray*)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRSwitchState*)turn;
- (TRRailConnectorR)connector;
- (GEVec2i)tile;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailLight : NSObject {
@protected
    GEVec2i _tile;
    TRRailConnectorR _connector;
    TRRail* _rail;
}
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnectorR connector;
@property (nonatomic, readonly) TRRail* rail;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail:(TRRail*)rail;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnectorR)connector rail:(TRRail*)rail;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailLightState : TRRailroadConnectorContent {
@protected
    TRRailLight* _light;
    BOOL _isGreen;
}
@property (nonatomic, readonly) TRRailLight* light;
@property (nonatomic, readonly) BOOL isGreen;

+ (instancetype)railLightStateWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (instancetype)initWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (CNClassType*)type;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnectorR)connector mustBe:(BOOL)mustBe;
- (NSArray*)rails;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnectorR)to;
- (TRRailLightState*)turn;
- (TRRailConnectorR)connector;
- (GEVec2i)tile;
- (GEVec3)shift;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRObstacle : NSObject {
@protected
    TRObstacleTypeR _obstacleType;
    TRRailPoint _point;
}
@property (nonatomic, readonly) TRObstacleTypeR obstacleType;
@property (nonatomic, readonly) TRRailPoint point;

+ (instancetype)obstacleWithObstacleType:(TRObstacleTypeR)obstacleType point:(TRRailPoint)point;
- (instancetype)initWithObstacleType:(TRObstacleTypeR)obstacleType point:(TRRailPoint)point;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailroad : CNActor {
@protected
    EGMapSso* _map;
    TRScore* _score;
    TRForest* _forest;
    CNMMapDefault* __connectorIndex;
    TRRailroadState* __state;
    CNSignal* _stateWasRestored;
    CNSignal* _switchWasTurned;
    CNSignal* _lightWasTurned;
    CNSignal* _railWasBuilt;
    CNSignal* _railWasRemoved;
    CNSignal* _lightWasBuiltOrRemoved;
}
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) CNSignal* stateWasRestored;
@property (nonatomic, readonly) CNSignal* switchWasTurned;
@property (nonatomic, readonly) CNSignal* lightWasTurned;
@property (nonatomic, readonly) CNSignal* railWasBuilt;
@property (nonatomic, readonly) CNSignal* railWasRemoved;
@property (nonatomic, readonly) CNSignal* lightWasBuiltOrRemoved;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRailroadDamages : NSObject {
@protected
    NSArray* _points;
    CNLazy* __lazy_index;
}
@property (nonatomic, readonly) NSArray* points;

+ (instancetype)railroadDamagesWithPoints:(NSArray*)points;
- (instancetype)initWithPoints:(NSArray*)points;
- (CNClassType*)type;
- (NSDictionary*)index;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRRailroadState : NSObject {
@protected
    NSUInteger _id;
    CNImMapDefault* _connectorIndex;
    TRRailroadDamages* _damages;
    CNLazy* __lazy_rails;
    CNLazy* __lazy_switches;
    CNLazy* __lazy_lights;
}
@property (nonatomic, readonly) NSUInteger id;
@property (nonatomic, readonly) CNImMapDefault* connectorIndex;
@property (nonatomic, readonly) TRRailroadDamages* damages;

+ (instancetype)railroadStateWithId:(NSUInteger)id connectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages;
- (instancetype)initWithId:(NSUInteger)id connectorIndex:(CNImMapDefault*)connectorIndex damages:(TRRailroadDamages*)damages;
- (CNClassType*)type;
- (NSArray*)rails;
- (NSArray*)switches;
- (NSArray*)lights;
- (NSArray*)railsInTile:(GEVec2i)tile;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailPointCorrection)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint)point;
- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint)from to:(CGFloat)to;
- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnectorR)connector;
- (BOOL)isLockedRail:(TRRail*)rail;
- (BOOL)isConnectedA:(TRRailPoint)a b:(TRRailPoint)b;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


