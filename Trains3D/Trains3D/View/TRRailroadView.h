#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGFont.h"
#import "EGMesh.h"
@class TRLevel;
@class TRRailroad;
@class EGViewportSurface;
@class TRRailroadBuilder;
@class EGGlobal;
@class EGContext;
@class EGShadowDrawParam;
@class EGPlatform;
@class EGMapSsoView;
@class EGShadowDrawShaderSystem;
@class EGRenderTarget;
@class EGEnablingState;
@class EGBlendFunction;
@class EGDirector;
@class EGStandardMaterial;
@class EGColorSource;
@class EGTexture;
@class TRModels;
@class EGMaterial;
@class TRRailBuilding;
@class TRRail;
@class GEMat4;
@class EGMatrixModel;
@class TRRailForm;
@class TRRailConnector;
@class EGMatrixStack;
@class TRStr;
@protocol TRStrings;
@class EGBillboard;
@class TRSwitch;
@class TRRailLight;
@class TRRailPoint;
@class TRLevelRules;
@class TRLevelTheme;

@class TRRailroadView;
@class TRRailView;
@class TRUndoView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;
@class TRBackgroundView;

@interface TRRailroadView : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) id shadowVao;
@property (nonatomic) BOOL _changed;

+ (id)railroadViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)drawBackground;
- (void)drawLightGlows;
- (void)drawForeground;
- (void)prepare;
- (void)reshape;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGStandardMaterial* railMaterial;
@property (nonatomic, readonly) EGTexture* gravel;
@property (nonatomic, readonly) EGMeshModel* railModel;
@property (nonatomic, readonly) EGMeshModel* railTurnModel;

+ (id)railViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawRailBuilding:(TRRailBuilding*)railBuilding;
- (void)drawRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRUndoView : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (void)reshape;
- (void)draw;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


@interface TRSwitchView : NSObject
@property (nonatomic, readonly) EGColorSource* material;
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
@property (nonatomic) BOOL _matrixChanged;
@property (nonatomic) BOOL _bodyChanged;
@property (nonatomic) BOOL _matrixShadowChanged;
@property (nonatomic) BOOL _lightGlowChanged;

+ (id)lightViewWithRailroad:(TRRailroad*)railroad;
- (id)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawBodies;
- (void)drawShadow;
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
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (id)backgroundViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


