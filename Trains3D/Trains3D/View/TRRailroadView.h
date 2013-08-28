#import "objd.h"
#import "EGGL.h"
@class EGMesh;
@class EGMeshModel;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class EG;
@class EGTexture;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;

@class TRRailroadView;
@class TRRailView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;

@interface TRRailroadView : NSObject
+ (id)railroadView;
- (id)init;
- (void)drawRailroad:(TRRailroad*)railroad;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRRailView : NSObject
+ (id)railView;
- (id)init;
- (void)drawRail:(TRRail*)rail;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRSwitchView : NSObject
+ (id)switchView;
- (id)init;
- (void)drawTheSwitch:(TRSwitch*)theSwitch;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRLightView : NSObject
+ (id)lightView;
- (id)init;
- (void)drawLight:(TRLight*)light;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRDamageView : NSObject
+ (id)damageView;
- (id)init;
- (void)drawPoint:(TRRailPoint*)point;
- (ODType*)type;
+ (ODType*)type;
@end


