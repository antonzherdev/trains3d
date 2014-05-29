#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
#import "EGTexture.h"
#import "EGMesh.h"
#import "TRLevel.h"
@class TRLevelView;
@class TRRailroad;
@class EGPlatform;
@class EGOS;
@class EGViewportSurface;
@class TRGameDirector;
@class EGVertexArray;
@class CNReactFlag;
@class TRRailroadBuilder;
@class EGCameraIsoMove;
@class EGGlobal;
@class EGContext;
@class EGShadowDrawParam;
@class EGMapSsoView;
@class EGShadowDrawShaderSystem;
@class EGRenderTarget;
@class EGCullFace;
@class EGEnablingState;
@class TRRailroadState;
@class EGBlendFunction;
@class CNFuture;
@class TRRailroadBuilderState;
@class TRRailBuilding;
@class TRRail;
@class EGStandardMaterial;
@class EGColorSource;
@class TRModels;
@class EGMatrixStack;
@class GEMat4;
@class EGMMatrixModel;
@class CNVar;
@class EGSprite;
@class CNReact;
@class TRSwitchState;
@class CNChain;
@class TRRailLightState;
@class EGMatrixModel;
@class EGMutableCounterArray;
@class CNObserver;
@class EGLengthCounter;
@class CNSignal;
@class TRRailroadDamages;
@class EGCounterData;
@class EGD2D;

@class TRRailroadView;
@class TRRailView;
@class TRUndoView;
@class TRSwitchView;
@class TRLightView;
@class TRDamageView;
@class TRBackgroundView;

@interface TRRailroadView : EGInputProcessor_impl {
@protected
    __weak TRLevelView* _levelView;
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
    EGVertexArray* _shadowVao;
    CNReactFlag* __changed;
}
@property (nonatomic, readonly, weak) TRLevelView* levelView;
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGVertexArray* shadowVao;

+ (instancetype)railroadViewWithLevelView:(TRLevelView*)levelView level:(TRLevel*)level;
- (instancetype)initWithLevelView:(TRLevelView*)levelView level:(TRLevel*)level;
- (CNClassType*)type;
- (void)_init;
- (void)drawBackgroundRrState:(TRRailroadState*)rrState;
- (void)drawLightGlowsRrState:(TRRailroadState*)rrState;
- (void)drawSwitchesRrState:(TRRailroadState*)rrState;
- (void)drawForegroundRrState:(TRRailroadState*)rrState;
- (void)prepare;
- (void)drawSurface;
- (EGRecognizers*)recognizers;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRailView : NSObject {
@protected
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
- (CNClassType*)type;
- (void)drawRailBuilding:(TRRailBuilding*)railBuilding;
- (void)drawRail:(TRRail*)rail;
- (void)drawRail:(TRRail*)rail count:(unsigned int)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRUndoView : EGInputProcessor_impl {
@protected
    TRRailroadBuilder* _builder;
    BOOL _empty;
    CNVar* _buttonPos;
    EGSprite* _button;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (CNClassType*)type;
- (void)draw;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRSwitchView : NSObject {
@protected
    EGColorSource* _material;
    EGMeshModel* _switchStraightModel;
    EGMeshModel* _switchTurnModel;
}
@property (nonatomic, readonly) EGColorSource* material;
@property (nonatomic, readonly) EGMeshModel* switchStraightModel;
@property (nonatomic, readonly) EGMeshModel* switchTurnModel;

+ (instancetype)switchView;
- (instancetype)init;
- (CNClassType*)type;
- (void)drawTheSwitch:(TRSwitchState*)theSwitch;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRLightView : NSObject {
@protected
    CNReactFlag* __matrixChanged;
    CNReactFlag* __matrixShadowChanged;
    CNReactFlag* __lightGlowChanged;
    NSUInteger __lastId;
    NSUInteger __lastShadowId;
    NSArray* __matrixArr;
    EGMeshUnite* _bodies;
    EGMeshUnite* _shadows;
    EGMeshUnite* _glows;
}
+ (instancetype)lightViewWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad;
- (instancetype)initWithLevelView:(TRLevelView*)levelView railroad:(TRRailroad*)railroad;
- (CNClassType*)type;
- (void)drawBodiesRrState:(TRRailroadState*)rrState;
- (void)drawShadowRrState:(TRRailroadState*)rrState;
- (void)drawGlows;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRDamageView : NSObject {
@protected
    TRRailroad* _railroad;
    EGMeshModel* _model;
    EGMutableCounterArray* _sporadicAnimations;
    CNObserver* _spObs;
}
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) EGMeshModel* model;
@property (nonatomic, readonly) EGMutableCounterArray* sporadicAnimations;
@property (nonatomic, readonly) CNObserver* spObs;

+ (instancetype)damageViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (CNClassType*)type;
- (void)drawPoint:(TRRailPoint)point;
- (void)drawRrState:(TRRailroadState*)rrState;
- (void)drawForeground;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRBackgroundView : NSObject {
@protected
    EGMapSsoView* _mapView;
}
@property (nonatomic, readonly) EGMapSsoView* mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


