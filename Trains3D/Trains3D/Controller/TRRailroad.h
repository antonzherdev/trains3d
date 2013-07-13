#import "objd.h"
@class EGMapSso;
#import "EGTypes.h"
#import "TRRailPoint.h"

@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;

@interface TRRail : NSObject
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (id)railWithTile:(EGPointI)tile form:(TRRailForm*)form;
- (id)initWithTile:(EGPointI)tile form:(TRRailForm*)form;
- (BOOL)hasConnector:(TRRailConnector*)connector;
@end


@interface TRSwitch : NSObject
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;
@property (nonatomic) BOOL firstActive;

+ (id)switchWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (TRRail*)activeRail;
- (void)turn;
@end


@interface TRLight : NSObject
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic) BOOL isGreen;

+ (id)lightWithTile:(EGPointI)tile connector:(TRRailConnector*)connector;
- (id)initWithTile:(EGPointI)tile connector:(TRRailConnector*)connector;
- (void)turn;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) NSArray* rails;
@property (nonatomic, readonly) NSArray* switches;
@property (nonatomic, readonly) NSArray* lights;
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (BOOL)canAddRail:(TRRail*)rail;
- (TRSwitch*)switchInTile:(EGPointI)tile connector:(TRRailConnector*)connector;
- (BOOL)tryAddRail:(TRRail*)rail;
- (TRRailPointCorrection)moveForLength:(double)length point:(TRRailPoint)point;
@end


@interface TRRailroadBuilder : NSObject
@property (nonatomic, readonly, weak) TRRailroad* railroad;
@property (nonatomic, readonly) TRRail* rail;

+ (id)railroadBuilderWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (BOOL)tryBuildRail:(TRRail*)rail;
- (void)clear;
- (void)fix;
@end


