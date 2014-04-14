#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGMapIso.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainModels;
@class TRTreeView;
@class TRCallRepairerView;
@class ATObserver;
@class EGDirector;
@class TRTrainView;
@class TRTrain;
@class TRTrainType;
@class TRGameDirector;
@class TRStr;
@class TRStrings;
@class ATSignal;
@class TRRailroadBuilder;
@class EGCameraIsoMove;
@class TRRailroadBuilderMode;
@class EGEnvironment;
@class TRLevelRules;
@class TRWeatherRules;
@class GEMat4;
@class EGDirectLight;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class EGGlobal;
@class EGContext;
@class EGD2D;
@class TRPrecipitation;
@class EGPlatform;
@class ATVar;
@class ATSlot;
@class EGCameraIso;
@class TRRailroad;
@class EGRenderTarget;
@class EGMatrixStack;
@class ATReact;
@class TRPrecipitationType;
@class TRRainView;
@class TRSnowView;
@class TRWeather;
@class EGProgress;
@class EGSprite;
@class TRRewindButton;
@class EGCounter;
@class TRHistory;
@class EGTextureFormat;
@class EGTexture;
@class EGColorSource;
@class EGEnablingState;
@class EGBlendFunction;

@class TRLevelView;
@class TRPrecipitationView;
@class TRRewindButtonView;

@interface TRLevelView : NSObject<EGLayerView, EGInputProcessor> {
@protected
    TRLevel* _level;
    NSString* _name;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainModels* _trainModels;
    NSMutableArray* _trainsView;
    TRTreeView* _treeView;
    TRCallRepairerView* _callRepairerView;
    TRPrecipitationView* _precipitationView;
    TRRewindButtonView* _rewindButtonView;
    ATObserver* _onTrainAdd;
    ATObserver* _onTrainRemove;
    CNNotificationObserver* _modeChangeObs;
    EGEnvironment* _environment;
    ATObserver* _moveScaleObserver;
    EGCameraIsoMove* __move;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) TRTrainModels* trainModels;
@property (nonatomic, readonly) NSMutableArray* trainsView;
@property (nonatomic, readonly) EGEnvironment* environment;

+ (instancetype)levelViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)prepare;
- (void)complete;
- (void)draw;
- (id<EGCamera>)camera;
- (EGCameraIsoMove*)cameraMove;
- (void)updateWithDelta:(CGFloat)delta;
- (EGRecognizers*)recognizers;
- (void)reshapeWithViewport:(GERect)viewport;
+ (ODClassType*)type;
@end


@interface TRPrecipitationView : NSObject<EGUpdatable>
+ (instancetype)precipitationView;
- (instancetype)init;
- (ODClassType*)type;
+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation;
- (void)draw;
- (void)complete;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRewindButtonView : NSObject<EGInputProcessor> {
@protected
    TRLevel* _level;
    BOOL _empty;
    ATVar* _buttonPos;
    float(^_animation)(float);
    EGSprite* _button;
    ATObserver* _buttonObs;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)rewindButtonViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (EGRecognizers*)recognizers;
+ (ODClassType*)type;
@end


