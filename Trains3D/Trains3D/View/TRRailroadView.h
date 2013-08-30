#import "objd.h"
#import "EGGL.h"
@class EGMesh;
@class EGMeshModel;
@class EG;
@class EGTexture;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGContext;
@class EGMutableMatrix;
#import "EGTypes.h"
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
@class TR3D;

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
@property (nonatomic, readonly) EGMeshModel* railModel;
@property (nonatomic, readonly) EGMeshModel* railTurnModel;

+ (id)railView;
- (id)init;
- (void)drawRail:(TRRail*)rail;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRSwitchView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* material;
@property (nonatomic, readonly) EGMeshModel* switchStraightModel;
@property (nonatomic, readonly) EGMeshModel* switchTurnModel;

+ (id)switchView;
- (id)init;
- (void)drawTheSwitch:(TRSwitch*)theSwitch;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRLightView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* greenMaterial;
@property (nonatomic, readonly) EGStandardMaterial* redMaterial;

+ (id)lightView;
- (id)init;
- (void)drawLight:(TRLight*)light;
- (ODType*)type;
+ (ODType*)type;
@end


@interface TRDamageView : NSObject
@property (nonatomic, readonly) EGMeshModel* model;

+ (id)damageView;
- (id)init;
- (void)drawPoint:(TRRailPoint*)point;
- (ODType*)type;
+ (ODType*)type;
@end


