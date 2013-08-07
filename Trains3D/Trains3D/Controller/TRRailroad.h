#import "objd.h"
@class EGMapSso;
#import "EGTypes.h"
@class EGMapSsoTileIndex;
#import "TRRailPoint.h"

@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;

@interface TRRailroadConnectorContent : NSObject
+ (id)railroadConnectorContent;
- (id)init;
- (BOOL)canAddRail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
- (NSArray*)rails;
- (BOOL)isGreen;
@end


@interface TREmptyConnector : TRRailroadConnectorContent
+ (id)emptyConnector;
- (id)init;
- (NSArray*)rails;
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
- (NSArray*)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
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
- (BOOL)canAddRail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (NSArray*)rails;
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
- (BOOL)canAddRail;
- (TRRailroadConnectorContent*)connectRail:(TRRail*)rail to:(TRRailConnector*)to;
- (NSArray*)rails;
- (TRRailroadConnectorContent*)buildLightInConnector:(TRRailConnector*)connector;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (NSArray*)rails;
- (NSArray*)switches;
- (NSArray*)lights;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
- (id)contentInTile:(EGPointI)tile connector:(TRRailConnector*)connector;
- (TRRailPointCorrection)moveConsideringLights:(BOOL)consideringLights forLength:(double)forLength point:(TRRailPoint)point;
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


