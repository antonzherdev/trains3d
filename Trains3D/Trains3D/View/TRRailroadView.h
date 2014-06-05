#import "objd.h"
#import "PGInput.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "PGMapIso.h"
#import "PGTexture.h"
#import "TRLevel.h"
@class TRLevelView;
@class TRRailroad;
@class TRLightView;
@class PGPlatform;
@class PGOS;
@class PGViewportSurface;
@class TRGameDirector;
@class PGVertexArray;
@class CNReactFlag;
@class TRRailroadBuilder;
@class PGCameraIsoMove;
@class PGGlobal;
@class PGContext;
@class PGShadowDrawParam;
@class PGMapSsoView;
@class PGShadowDrawShaderSystem;
@class PGMesh;
@class PGRenderTarget;
@class PGCullFace;
@class PGEnablingState;
@class TRRailroadState;
@class PGBlendFunction;
@class CNFuture;
@class TRRailroadBuilderState;
@class TRRailBuilding;
@class TRRail;
@class PGStandardMaterial;
@class PGColorSource;
@class PGMeshModel;
@class TRModels;
@class PGMatrixStack;
@class PGMat4;
@class PGMMatrixModel;
@class CNVar;
@class PGSprite;
@class CNReact;
@class TRSwitchState;
@class PGMutableCounterArray;
@class CNObserver;
@class PGLengthCounter;
@class CNSignal;
@class TRRailroadDamages;
@class PGCounterData;
@class PGD2D;

@class TRRailroadView;
@class TRRailView;
@class TRUndoView;
@class TRSwitchView;
@class TRDamageView;
@class TRBackgroundView;

@interface TRRailroadView : PGInputProcessor_impl {
@public
    __weak TRLevelView* _levelView;
    TRLevel* _level;
    TRRailroad* _railroad;
    TRRailView* _railView;
    TRSwitchView* _switchView;
    TRLightView* _lightView;
    TRDamageView* _damageView;
    BOOL _iOS6;
    PGViewportSurface* _railroadSurface;
    TRBackgroundView* _backgroundView;
    TRUndoView* _undoView;
    PGVertexArray* _shadowVao;
    CNReactFlag* __changed;
}
@property (nonatomic, readonly, weak) TRLevelView* levelView;
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) PGVertexArray* shadowVao;

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
- (PGRecognizers*)recognizers;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRailView : NSObject {
@public
    TRRailroad* _railroad;
    PGStandardMaterial* _railMaterial;
    PGTexture* _gravel;
    PGMeshModel* _railModel;
    PGMeshModel* _railTurnModel;
}
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) PGStandardMaterial* railMaterial;
@property (nonatomic, readonly) PGTexture* gravel;
@property (nonatomic, readonly) PGMeshModel* railModel;
@property (nonatomic, readonly) PGMeshModel* railTurnModel;

+ (instancetype)railViewWithRailroad:(TRRailroad*)railroad;
- (instancetype)initWithRailroad:(TRRailroad*)railroad;
- (CNClassType*)type;
- (void)drawRailBuilding:(TRRailBuilding*)railBuilding;
- (void)drawRail:(TRRail*)rail;
- (void)drawRail:(TRRail*)rail count:(unsigned int)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRUndoView : PGInputProcessor_impl {
@public
    TRRailroadBuilder* _builder;
    BOOL _empty;
    CNVar* _buttonPos;
    PGSprite* _button;
}
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (instancetype)undoViewWithBuilder:(TRRailroadBuilder*)builder;
- (instancetype)initWithBuilder:(TRRailroadBuilder*)builder;
- (CNClassType*)type;
- (void)draw;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRSwitchView : NSObject {
@public
    PGColorSource* _material;
    PGMeshModel* _switchStraightModel;
    PGMeshModel* _switchTurnModel;
}
@property (nonatomic, readonly) PGColorSource* material;
@property (nonatomic, readonly) PGMeshModel* switchStraightModel;
@property (nonatomic, readonly) PGMeshModel* switchTurnModel;

+ (instancetype)switchView;
- (instancetype)init;
- (CNClassType*)type;
- (void)drawTheSwitch:(TRSwitchState*)theSwitch;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRDamageView : NSObject {
@public
    TRRailroad* _railroad;
    PGMeshModel* _model;
    PGMutableCounterArray* _sporadicAnimations;
    CNObserver* _spObs;
}
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) PGMeshModel* model;
@property (nonatomic, readonly) PGMutableCounterArray* sporadicAnimations;
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
@public
    PGMapSsoView* _mapView;
}
@property (nonatomic, readonly) PGMapSsoView* mapView;

+ (instancetype)backgroundViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


