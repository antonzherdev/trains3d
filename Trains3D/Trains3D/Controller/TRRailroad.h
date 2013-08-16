#import "objd.h"
#import "CNTreeMap.h"
@class EGMapSso;
#import "EGTypes.h"
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TRScoreRules;
@class TRScore;
@class TRTrainScore;

@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRObstacleType;

@interface TRRailroadConnectorContent : NSObject
+ (id)railroadConnectorContent;
- (id)init;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
- (id<CNList>)rails;
- (BOOL)isGreen;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (id)emptyConnector;
- (id)init;
- (id<CNList>)rails;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
+ (TRRailroadConnectorContent*)instance;
@end


@interface TRRail : TRRailroadConnectorContent
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (id)railWithTile:(EGPointI)tile form:(TRRailForm*)form;
- (id)initWithTile:(EGPointI)tile form:(TRRailForm*)form;
- (BOOL)hasConnector:(TRRailConnector*)connector;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNList>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
- (BOOL)canAddRail:(TRRail*)rail;
@end


@interface TRSwitch : TRRailroadConnectorContent
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;
@property (nonatomic) BOOL firstActive;

+ (id)switchWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (TRRail*)activeRail;
- (void)turn;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNList>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
@end


@interface TRLight : TRRailroadConnectorContent
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail;
@property (nonatomic) BOOL isGreen;

+ (id)lightWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail:(TRRail*)rail;
- (void)turn;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (id<CNList>)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
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
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRScore* score;
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadWithMap:(EGMapSso*)map score:(TRScore*)score;
- (id)initWithMap:(EGMapSso*)map score:(TRScore*)score;
- (id<CNList>)rails;
- (id<CNList>)switches;
- (id<CNList>)lights;
- (id<CNList>)damagesPoints;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
- (TRRailroadConnectorContent*)contentInTile:(EGPointI)tile connector:(TRRailConnector*)connector;
- (TRRailPointCorrection*)moveWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor forLength:(double)forLength point:(TRRailPoint*)point;
- (id)checkDamagesWithObstacleProcessor:(BOOL(^)(TRObstacle*))obstacleProcessor from:(TRRailPoint*)from to:(double)to;
- (void)addDamageAtPoint:(TRRailPoint*)point;
- (void)fixDamageAtPoint:(TRRailPoint*)point;
@end


@interface TRRailroadBuilder : NSObject
@property (nonatomic, readonly, weak) TRRailroad* railroad;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (id)rail;
- (BOOL)tryBuildRail:(TRRail*)rail;
- (void)clear;
- (void)fix;
@end


