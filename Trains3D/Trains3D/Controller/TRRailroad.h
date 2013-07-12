#import "objd.h"
#import "EGTypes.h"
@class EGMapSsoTileIndex;
#import "TRRailPoint.h"

@class TRRail;
@class TRSwitch;
@class TRRailroad;
@class TRRailroadBuilder;

@interface TRRail : NSObject
@property (nonatomic, readonly) EGIPoint tile;
@property (nonatomic, readonly) TRRailForm* form;

+ (id)railWithTile:(EGIPoint)tile form:(TRRailForm*)form;
- (id)initWithTile:(EGIPoint)tile form:(TRRailForm*)form;
- (BOOL)hasConnector:(TRRailConnector*)connector;
@end


@interface TRSwitch : NSObject
@property (nonatomic, readonly) EGIPoint tile;
@property (nonatomic, readonly) TRRailConnector* connector;
@property (nonatomic, readonly) TRRail* rail1;
@property (nonatomic, readonly) TRRail* rail2;
@property (nonatomic) BOOL firstActive;

+ (id)switchWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (id)initWithTile:(EGIPoint)tile connector:(TRRailConnector*)connector rail1:(TRRail*)rail1 rail2:(TRRail*)rail2;
- (TRRail*)activeRail;
@end


@interface TRRailroad : NSObject
@property (nonatomic, readonly) EGISize mapSize;
@property (nonatomic, readonly) NSArray* rails;
@property (nonatomic, readonly) NSArray* switches;
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (BOOL)canAddRail:(TRRail*)rail;
- (BOOL)tryAddRail:(TRRail*)rail;
- (TRRailPointCorrection)moveForLength:(CGFloat)length point:(TRRailPoint)point;
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


