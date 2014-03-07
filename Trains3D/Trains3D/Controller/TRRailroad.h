#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@class TRForest;
@class EGMapSso;
@class TRScore;

@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRSwitchState;
@class TRRailLight;
@class TRRailLightState;
@class TRObstacle;
@class TRRailroad;
@class TRObstacleType;

@interface TRRailroadConnectorContent : NSObject
+ (instancetype)railroadConnectorContent;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (id<CNSeq>)rails;
- (BOOL)isGreen;
- (BOOL)isEmpty;
- (void)cutDownTreesInForest:(TRForest*)forest;
+ (ODClassType*)type;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (instancetype)emptyConnector;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (BOOL)isEmpty;
+ (TRRailroadConnectorContent*)instance;
+ (ODClassType*)type;
@end


@interface TRRail : TRRailroadConnectorContent
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (instancetype)railWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (instancetype)initWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (ODClassType*)type;
- (BOOL)hasConnector:(TRRailConnector*)connector;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (BOOL)canAddRail:(TRRail*)rail;
- (GELine2)line;
+ (ODClassType*)type;
@end


@interface TRSwitch : NSObject
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;

+ (instancetype)switchWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (ODClassType*)type;
- (id<CNSeq>)rails;
- (TRRailPoint)railPoint1;
- (TRRailPoint)railPoint2;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRSwitchState : TRRailroadConnectorContent
@property (nonatomic, readonly) TRSwitch* aSwitch;
@property (nonatomic, readonly) BOOL firstActive;

+ (instancetype)switchStateWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (instancetype)initWithASwitch:(TRSwitch*)aSwitch firstActive:(BOOL)firstActive;
- (ODClassType*)type;
- (TRRail*)activeRail;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)disconnectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (void)cutDownTreesInForest:(TRForest*)forest;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRSwitchState*)turn;
- (TRRailConnector*)connector;
- (GEVec2i)tile;
+ (ODClassType*)type;
@end


@interface TRRailLight : NSObject
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail;

+ (instancetype)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (instancetype)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRailLightState : TRRailroadConnectorContent
@property (nonatomic, readonly) TRRailLight* light;
@property (nonatomic, readonly) BOOL isGreen;

+ (instancetype)railLightStateWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (instancetype)initWithLight:(TRRailLight*)light isGreen:(BOOL)isGreen;
- (ODClassType*)type;
- (TRRailroadConnectorContent*)checkLightInConnector:(TRRailConnector*)connector mustBe:(BOOL)mustBe;
- (id<CNSeq>)rails;
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


@interface TRObstacle : NSObject
@property (nonatomic, readonly) TRObstacleType* obstacleType;
@property (nonatomic, readonly) TRRailPoint point;

+ (instancetype)obstacleWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point;
- (instancetype)initWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)railroadWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (instancetype)initWithMap:(EGMapSso*)map score:(TRScore*)score forest:(TRForest*)forest;
- (ODClassType*)type;
- (id<CNSeq>)rails;
- (id<CNSeq>)switches;
- (id<CNSeq>)lights;
- (id<CNSeq>)damagesPoints;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
- (void)turnASwitch:(TRSwitch*)aSwitch;
- (void)turnLight:(TRRailLight*)light;
- (void)addRail:(TRRail*)rail;
- (void)removeRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector;
- (TRRailPointCorrection)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint)point;
- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint)from to:(CGFloat)to;
- (TRRailPoint)addDamageAtPoint:(TRRailPoint)point;
- (void)fixDamageAtPoint:(TRRailPoint)point;
- (void)updateWithDelta:(CGFloat)delta;
+ (CNNotificationHandle*)switchTurnNotification;
+ (CNNotificationHandle*)lightTurnNotification;
+ (CNNotificationHandle*)changedNotification;
+ (ODClassType*)type;
@end


