#import "objd.h"
#import "EGScene.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainView;
@class TRTreeView;
@class TRCallRepairerView;
@class EGEnvironment;
@class TRLevelRules;
@class TRWeatherRules;
@class EGMapSso;
@class GEMat4;
@class EGDirectLight;
@class EGCameraIsoMove;
@class EGCameraIso;
@class TRRailroadBuilderProcessor;
@class TRRailroad;
@class TRSwitchProcessor;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGMatrixStack;
@class EGDirector;
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
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) EGCameraIsoMove* move;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
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


@interface TRPrecipitationView : NSObject<EGController>
+ (id)precipitationView;
- (id)init;
- (ODClassType*)type;
+ (TRPrecipitationView*)applyWeather:(TRWeather*)weather precipitation:(TRPrecipitation*)precipitation;
- (void)draw;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


