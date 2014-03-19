#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
#import "EGCameraIso.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainModels;
@class TRTreeView;
@class TRCallRepairerView;
@class EGGlobal;
@class EGContext;
@class ATVar;
@class EGDirector;
@class TRTrainView;
@class TRTrain;
@class TRRailroadBuilder;
@class TRRailroadBuilderMode;
@class EGEnvironment;
@class TRLevelRules;
@class TRWeatherRules;
@class TRGameDirector;
@class EGMapSso;
@class GEMat4;
@class EGDirectLight;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class EGD2D;
@class TRRailroad;
@class EGRenderTarget;
@class EGPlatform;
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
    CNNotificationObserver* _obs1;
    CNNotificationObserver* _onTrainAdd;
    CNNotificationObserver* _onTrainRemove;
    CNNotificationObserver* _modeChangeObs;
    EGEnvironment* _environment;
    EGCameraIsoMove* __move;
    TRRailroadBuilderProcessor* _railroadBuilderProcessor;
    TRSwitchProcessor* _switchProcessor;
}
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) TRTrainModels* trainModels;
@property (nonatomic, readonly) NSMutableArray* trainsView;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, retain) EGCameraIsoMove* _move;

+ (instancetype)levelViewWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)prepare;
- (void)complete;
- (void)draw;
- (id<EGCamera>)camera;
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


