#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRRailroad;
@class TRRailroadBuilder;
@class EGMeshModel;
@class TR3D;
@class EG;
@class EGMaterial;
@class EGColorSource;
@class EGStandardMaterial;
@class TRRail;
@class GEMatrix;
@class EGMatrixModel;
@class TRRailForm;
@class EGMatrixStack;
@class TRSwitch;
@class TRRailConnector;
@class TRLight;
@class TRRailPoint;

@class TRRailroadView;
@class TRRailView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;

@interface TRRailroadView : NSObject
+ (id)railroadView;
- (id)init;
- (ODClassType*)type;
- (void)drawRailroad:(TRRailroad*)railroad;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject
@property (nonatomic, readonly) EGMeshModel* railModel;
@property (nonatomic, readonly) EGMeshModel* railTurnModel;

+ (id)railView;
- (id)init;
- (ODClassType*)type;
- (void)drawRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRSwitchView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* material;
@property (nonatomic, readonly) EGMeshModel* switchStraightModel;
@property (nonatomic, readonly) EGMeshModel* switchTurnModel;

+ (id)switchView;
- (id)init;
- (ODClassType*)type;
- (void)drawTheSwitch:(TRSwitch*)theSwitch;
+ (ODClassType*)type;
@end


@interface TRLightView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* greenMaterial;
@property (nonatomic, readonly) EGStandardMaterial* redMaterial;

+ (id)lightView;
- (id)init;
- (ODClassType*)type;
- (void)drawLight:(TRLight*)light;
+ (ODClassType*)type;
@end


@interface TRDamageView : NSObject
@property (nonatomic, readonly) EGMeshModel* model;

+ (id)damageView;
- (id)init;
- (ODClassType*)type;
- (void)drawPoint:(TRRailPoint*)point;
+ (ODClassType*)type;
@end


