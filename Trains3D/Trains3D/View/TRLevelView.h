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
@class EGDirector;
@class TRTrainView;
@class TRTrain;
@class TRRailroadBuilder;
@class EGCameraIsoMove;
@class TRRailroadBuilderMode;
@class EGEnvironment;
@class TRLevelRules;
@class TRWeatherRules;
@class TRGameDirector;
@class GEMat4;
@class EGDirectLight;
@class ATObserver;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class EGGlobal;
@class EGContext;
@class EGD2D;
@class EGPlatform;
@class ATVar;
@class ATSlot;
@class EGCameraIso;
@class TRStr;
@class TRStrings;
@class TRRailroad;
@class EGRenderTarget;
@class EGMatrixStack;
@class ATReact;
@class TRPrecipitation;
@class TRPrecipitationType;
@class TRRainView;
@class TRSnowView;
@class TRWeather;

@class TRLevelView;
@class TRPrecipitationView;

@interface TRLevelView : NSObject<EGLayerView, EGInputProcessor> {
@private
    TRLevel* _level;
    NSString* _name;
    TRCityView* _cityView;
    TRRailroadView* _railroadView;
    TRTrainModels* _trainModels;
    NSMutableArray* _trainsView;
    TRTreeView* _treeView;
    TRCallRepairerView* _callRepairerView;
    id _precipitationView;
    CNNotificationObserver* _onTrainAdd;
    CNNotificationObserver* _onTrainRemove;
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


