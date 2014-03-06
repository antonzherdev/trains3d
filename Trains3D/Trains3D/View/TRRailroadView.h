#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGMesh.h"
#import "TRRailPoint.h"
@class TRLevel;
@class TRRailroad;
@class EGPlatform;
@class EGViewportSurface;
@class TRGameDirector;
@class TRRailroadBuilder;
@class EGCameraIsoMove;
@class EGGlobal;
@class EGContext;
@class EGShadowDrawParam;
@class EGMapSsoView;
@class EGShadowDrawShaderSystem;
@class EGRenderTarget;
@class EGVertexArray;
@class EGCullFace;
@class EGEnablingState;
@class EGBlendFunction;
@class TRRailBuilding;
@class EGDirector;
@class EGStandardMaterial;
@class EGColorSource;
@class EGTexture;
@class TRModels;
@class EGMaterial;
@class TRRail;
@class GEMat4;
@class EGMMatrixModel;
@class EGMatrixStack;
@class EGBillboard;
@class EGTextureFormat;
@class EGTextureFilter;
@class TRSwitch;
@class TRRailLight;
@class EGMatrixModel;
@class EGMutableCounterArray;
@class EGLengthCounter;
@class EGCounterData;
@class EGD2D;
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

+ (instancetype)railroadViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)drawBackground;
- (void)drawLightGlows;
- (void)drawForeground;
- (void)prepare;
- (void)drawSurface;
- (void)reshape;
- (EGRecognizers*)recognizers;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGStandardMaterial* railMaterial;
@property (nonatomic, readonly) EGTexture* gravel;
@property (nonatomic, readonly) EGMeshModel* railModel;
@property (nonatomic, readonly) EGMeshModel* railTurnModel;

+ (instancetype)railViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawRailBuilding:(TRRailBuilding*)railBuilding;
- (void)drawRail:(TRRail*)rail;
- (void)drawRail:(TRRail*)rail count:(unsigned int)count;
+ (ODClassType*)type;
@end


@interface TRUndoView : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
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

+ (instancetype)switchView;
- (instancetype)init;
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

+ (instancetype)lightViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawBodies;
- (void)drawShadow;
- (void)drawGlows;
+ (ODClassType*)type;
@end


@interface TRDamageView : NSObject
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGMeshModel* model;
@property (nonatomic, readonly) EGMutableCounterArray* sporadicAnimations;
@property (nonatomic, readonly) CNNotificationObserver* spObs;

+ (instancetype)damageViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawPoint:(TRRailPoint)point;
- (void)draw;
- (void)drawForeground;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRBackgroundView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


