#import "objd.h"
#import "PGScene.h"
#import "PGInput.h"
#import "TRTrain.h"
#import "TRRailroadBuilder.h"
#import "PGVec.h"
#import "PGMapIso.h"
#import "PGController.h"
#import "TRWeather.h"
#import "PGTexture.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainModels;
@class TRTreeView;
@class TRCallRepairerView;
@class CNObserver;
@class PGDirector;
@class TRTrainView;
@class TRGameDirector;
@class TRStr;
@class TRStrings;
@class CNSignal;
@class CNChain;
@class PGCameraIsoMove;
@class CNVar;
@class PGEnvironment;
@class TRLevelRules;
@class PGMat4;
@class PGDirectLight;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class PGGlobal;
@class PGContext;
@class PGD2D;
@class PGPlatform;
@class PGOS;
@class CNSlot;
@class PGCameraIso;
@class TRRailroad;
@class CNFuture;
@class PGRenderTarget;
@class PGMatrixStack;
@class CNReact;
@class TRRainView;
@class TRSnowView;
@class PGProgress;
@class PGSprite;
@class TRRewindButton;
@class PGCounter;
@class TRHistory;
@class PGColorSource;
@class PGEnablingState;
@class PGBlendFunction;

@class TRLevelView;
@class TRPrecipitationView;
@class TRRewindButtonView;

@interface TRLevelView : PGLayerView_impl<PGInputProcessor> {
@public
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
    PGEnvironment* _environment;
    CNObserver* _moveScaleObserver;
    PGCameraIsoMove* __move;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) TRTrainModels* trainModels;
@property (nonatomic, readonly) PGEnvironment* environment;

+ (instancetype)levelViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)_init;
- (void)prepare;
- (void)complete;
- (void)draw;
- (id<PGCamera>)camera;
- (PGCameraIsoMove*)cameraMove;
- (void)updateWithDelta:(CGFloat)delta;
- (PGRecognizers*)recognizers;
- (void)reshapeWithViewport:(PGRect)viewport;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRPrecipitationView : PGUpdatable_impl
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


@interface TRRewindButtonView : PGInputProcessor_impl {
@public
    BOOL _empty;
    CNVar* _buttonPos;
    float(^_animation)(float);
    PGSprite* _button;
    CNObserver* _buttonObs;
}
+ (instancetype)rewindButtonViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (void)draw;
- (PGRecognizers*)recognizers;
- (NSString*)description;
+ (CNClassType*)type;
@end


