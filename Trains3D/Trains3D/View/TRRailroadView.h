#import "objd.h"
#import "GEVec.h"
@class TRRailroad;
@class EGViewportSurface;
@class EGGlobal;
@class EGContext;
@class TRRailroadBuilder;
@class EGStandardMaterial;
@class EGColorSource;
@class EGTexture;
@class EGMeshModel;
@class TRModels;
@class EGMaterial;
@class TRRail;
@class GEMat4;
@class EGMatrixModel;
@class TRRailForm;
@class EGMatrixStack;
@class TRSwitch;
@class TRRailConnector;
@class EGVertexArray;
@class EGTextureRegion;
@class EGMesh;
@class TRRailLight;
@class EGRenderTarget;
@class EGBlendFunction;
@class EGEnablingState;
@class TRRailPoint;
@class EGMapSso;
@class EGMapSsoView;
@class EGShadowDrawParam;
@class EGPlatform;
@class EGShadowDrawShaderSystem;

@class TRRailroadView;
@class TRRailView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;
@class TRBackgroundView;

@interface TRRailroadView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)railroadViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)_init;
- (void)drawBackground;
- (void)drawForeground;
- (void)prepare;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* railMaterial;
@property (nonatomic, readonly) EGTexture* gravel;
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
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGVertexArray* redBodyVao;
@property (nonatomic, readonly) EGVertexArray* greenBodyVao;
@property (nonatomic, readonly) EGVertexArray* greenGlowVao;
@property (nonatomic, readonly) EGVertexArray* redGlowVao;

+ (id)lightViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)prepare;
- (void)drawBodies;
- (void)drawGlows;
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


@interface TRBackgroundView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMapSsoView* mapView;
@property (nonatomic, readonly) EGShadowDrawParam* shadowParam;
@property (nonatomic, readonly) id shadowVao;

+ (id)backgroundViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)draw;
- (void)drawShadow;
+ (ODClassType*)type;
@end


