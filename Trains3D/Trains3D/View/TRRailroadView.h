#import "objd.h"
#import "TR3DRail.h"
#import "TR3DRailTurn.h"
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;
#import "TRRailPoint.h"

@class TRRailroadView;
@class TRRailView;
@class TRSwitchView;
@class TRLightView;

@interface TRRailroadView : NSObject
+ (id)railroadView;
- (id)init;
- (void)drawRailroad:(TRRailroad*)railroad;
@end


@interface TRRailView : NSObject
+ (id)railView;
- (id)init;
- (void)drawRail:(TRRail*)rail;
@end


@interface TRSwitchView : NSObject
+ (id)switchView;
- (id)init;
- (void)drawTheSwitch:(TRSwitch*)theSwitch;
@end


@interface TRLightView : NSObject
+ (id)lightView;
- (id)init;
- (void)drawLight:(TRLight*)light;
@end


