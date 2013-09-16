#import "objd.h"
#import "GEVec.h"
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class EGMapSso;
@class TRScore;
@class TRRailPointCorrection;

@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRRailLight;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRObstacleType;

@interface TRRailroadConnectorContent : NSObject
+ (id)railroadConnectorContent;
- (id)init;
- (ODClassType*)type;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
- (id<CNSeq>)rails;
- (BOOL)isGreen;
+ (ODClassType*)type;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (id)emptyConnector;
- (id)init;
- (ODClassType*)type;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
+ (TRRailroadConnectorContent*)instance;
+ (ODClassType*)type;
@end


@interface TRRail : TRRailroadConnectorContent
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (id)railWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (id)initWithTile:(GEVec2i)tile form:(TRRailForm*)form;
- (ODClassType*)type;
- (BOOL)hasConnector:(TRRailConnector*)connector;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
- (BOOL)canAddRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRSwitch : TRRailroadConnectorContent
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;
@property (nonatomic) BOOL firstActive;

+ (id)switchWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (id)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (ODClassType*)type;
- (TRRail*)activeRail;
- (void)turn;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
+ (ODClassType*)type;
@end


@interface TRRailLight : TRRailroadConnectorContent
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic) BOOL isGreen;

+ (id)railLightWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (id)initWithTile:(GEVec2i)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (ODClassType*)type;
- (void)turn;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNSeq>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
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
@property (nonatomic, readonly) TRRailPoint* point;

+ (id)obstacleWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint*)point;
- (id)initWithObstacleType:(TRObstacleType*)obstacleType point:(TRRailPoint*)point;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroadBuilder* builder;
@property (nonatomic) BOOL changed;

+ (id)railroadWithMap:(EGMapSso*)map score:(TRScore*)score;
- (id)initWithMap:(EGMapSso*)map score:(TRScore*)score;
- (ODClassType*)type;
- (id<CNSeq>)rails;
- (id<CNSeq>)switches;
- (id<CNSeq>)lights;
- (id<CNSeq>)damagesPoints;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)contentInTile:(GEVec2i)tile connector:(TRRailConnector*)connector;
- (TRRailPointCorrection*)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(CGFloat)forLength point:(TRRailPoint*)point;
- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint*)from to:(CGFloat)to;
- (void)addDamageAtPoint:(TRRailPoint*)point;
- (void)fixDamageAtPoint:(TRRailPoint*)point;
+ (ODClassType*)type;
@end


@interface TRRailroadBuilder : NSObject
@property (nonatomic, readonly, weak) TRRailroad* railroad;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (id)rail;
- (BOOL)tryBuildRail:(TRRail*)rail;
- (void)clear;
- (void)fix;
+ (ODClassType*)type;
@end


