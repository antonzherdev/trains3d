#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "TRTrain.h"
#import "TRRailroadBuilder.h"
#import "GEVec.h"
#import "EGMapIso.h"
#import "EGController.h"
#import "TRWeather.h"
#import "EGTexture.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainModels;
@class TRTreeView;
@class TRCallRepairerView;
@class CNObserver;
@class EGDirector;
@class TRTrainView;
@class TRGameDirector;
@class TRStr;
@class TRStrings;
@class CNSignal;
@class CNChain;
@class EGCameraIsoMove;
@class CNVar;
@class EGEnvironment;
@class TRLevelRules;
@class GEMat4;
@class EGDirectLight;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class EGGlobal;
@class EGContext;
@class EGD2D;
@class EGPlatform;
@class EGOS;
@class CNSlot;
@class EGCameraIso;
@class TRRailroad;
@class CNFuture;
@class EGRenderTarget;
@class EGMatrixStack;
@class CNReact;
@class TRRainView;
@class TRSnowView;
@class EGProgress;
@class EGSprite;
@class TRRewindButton;
@class EGCounter;
@class TRHistory;
@class EGColorSource;
@class EGEnablingState;
@class EGBlendFunction;

@class TRLevelView;
@class TRPrecipitationView;
@class TRRewindButtonView;

@interface TRLevelView : EGLayerView_impl<EGInputProcessor> {
@protected
    TRLevel* _level;
    NSString* _name;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainModels* _trainModels;
    volatile NSArray* _trainsView;
    TRTreeView* _treeView;
    TRCallRepairerView* _callRepairerView;
    TRPrecipitationView* _precipitationView;
    TRRewindButtonView* _rewindButtonView;
    CNObserver* _onTrainAdd;
    CNObserver* _onTrainRemove;
    CNObserver* _modeChangeObs;
    EGEnvironment* _environment;
    CNObserver* _moveScaleObserver;
    EGCameraIsoMove* __move;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) TRTrainModels* trainModels;
@property (nonatomic, readonly) EGEnvironment* environment;

+ (instancetype)levelViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)_init;
- (void)prepare;
- (void)complete;
- (void)draw;
- (id<EGCamera>)camera;
- (EGCameraIsoMove*)cameraMove;
- (void)updateWithDelta:(CGFloat)delta;
- (EGRecognizers*)recognizers;
- (void)reshapeWithViewport:(GERect)viewport;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRPrecipitationView : EGUpdatable_impl
+ (instancetype)precipitationView;
- (instancetype)init;
- (CNClassType*)type;
+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation;
- (void)draw;
- (void)complete;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRewindButtonView : EGInputProcessor_impl {
@protected
    BOOL _empty;
    CNVar* _buttonPos;
    float(^_animation)(float);
    EGSprite* _button;
    CNObserver* _buttonObs;
}
+ (instancetype)rewindButtonViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)draw;
- (EGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


