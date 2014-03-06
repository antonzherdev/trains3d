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
@class EGDirector;
@class TRTrainView;
@class TRTrain;
@class EGEnvironment;
@class TRLevelRules;
@class TRWeatherRules;
@class TRGameDirector;
@class EGMapSso;
@class GEMat4;
@class EGDirectLight;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class EGRenderTarget;
@class TRRailroadBuilder;
@class EGPlatform;
@class EGMatrixStack;
@class TRPrecipitation;
@class TRPrecipitationType;
@class TRRainView;
@class TRSnowView;
@class TRWeather;

@class TRLevelView;
@class TRPrecipitationView;

@interface TRLevelView : NSObject<EGLayerView, EGInputProcessor>
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
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


