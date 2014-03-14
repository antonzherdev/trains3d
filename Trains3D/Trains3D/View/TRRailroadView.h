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
@class TRRailroadState;
@class EGBlendFunction;
@class TRRailroadBuilderState;
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
@class ATVar;
@class EGSprite;
@class EGTextureFormat;
@class ATReact;
@class EGTextureFilter;
@class TRSwitchState;
@class TRRailLightState;
@class EGMatrixModel;
@class EGMutableCounterArray;
@class EGLengthCounter;
@class TRRailroadDamages;
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

@interface TRRailroadView : NSObject<EGInputProcessor> {
@private
    TRLevel* _level;
    TRRailroad* _railroad;
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
    BOOL _iOS6;
    EGViewportSurface* _railroadSurface;
    TRBackgroundView* _backgroundView;
    TRUndoView* _undoView;
    id _shadowVao;
    CNNotificationObserver* _obs1;
    CNNotificationObserver* _obs2;
    CNNotificationObserver* _obs3;
    BOOL __changed;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) id shadowVao;
@property (nonatomic) BOOL _changed;

+ (instancetype)railroadViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)drawBackgroundRrState:(TRRailroadState*)rrState;
- (void)drawLightGlowsRrState:(TRRailroadState*)rrState;
- (void)drawForegroundRrState:(TRRailroadState*)rrState;
- (void)prepare;
- (void)drawSurface;
- (EGRecognizers*)recognizers;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRailView : NSObject {
@private
    TRRailroad* _railroad;
    EGStandardMaterial* _railMaterial;
    EGTexture* _gravel;
    EGMeshModel* _railModel;
    EGMeshModel* _railTurnModel;
}
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


@interface TRUndoView : NSObject<EGInputProcessor> {
@private
    TRRailroadBuilder* _builder;
    BOOL _empty;
    ATVar* _buttonPos;
    EGSprite* _button;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (void)draw;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


@interface TRSwitchView : NSObject {
@private
    EGColorSource* _material;
    EGMeshModel* _switchStraightModel;
    EGMeshModel* _switchTurnModel;
}
@property (nonatomic, readonly) EGColorSource* material;
@property (nonatomic, readonly) EGMeshModel* switchStraightModel;
@property (nonatomic, readonly) EGMeshModel* switchTurnModel;

+ (instancetype)switchView;
- (instancetype)init;
- (ODClassType*)type;
- (void)drawTheSwitch:(TRSwitchState*)theSwitch;
+ (ODClassType*)type;
@end


@interface TRLightView : NSObject {
@private
    TRRailroad* _railroad;
    BOOL __matrixChanged;
    BOOL __bodyChanged;
    BOOL __matrixShadowChanged;
    BOOL __lightGlowChanged;
    CNNotificationObserver* _obs1;
    CNNotificationObserver* _obs2;
    CNNotificationObserver* _obs3;
    id<CNImSeq> __matrixArr;
    EGMeshUnite* _bodies;
    EGMeshUnite* _shadows;
    EGMeshUnite* _glows;
}
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic) BOOL _matrixChanged;
@property (nonatomic) BOOL _bodyChanged;
@property (nonatomic) BOOL _matrixShadowChanged;
@property (nonatomic) BOOL _lightGlowChanged;

+ (instancetype)lightViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawBodiesRrState:(TRRailroadState*)rrState;
- (void)drawShadowRrState:(TRRailroadState*)rrState;
- (void)drawGlows;
+ (ODClassType*)type;
@end


@interface TRDamageView : NSObject {
@private
    TRRailroad* _railroad;
    EGMeshModel* _model;
    EGMutableCounterArray* _sporadicAnimations;
    CNNotificationObserver* _spObs;
}
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGMeshModel* model;
@property (nonatomic, readonly) EGMutableCounterArray* sporadicAnimations;
@property (nonatomic, readonly) CNNotificationObserver* spObs;

+ (instancetype)damageViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (ODClassType*)type;
- (void)drawPoint:(TRRailPoint)point;
- (void)drawRrState:(TRRailroadState*)rrState;
- (void)drawForeground;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRBackgroundView : NSObject {
@private
    TRLevel* _level;
    EGMapSsoView* _mapView;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


