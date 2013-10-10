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
@class GEMat4;
@class EGDirectLight;
@class EGMapSso;
@class EGCameraIso;
@class TRRailroadBuilderProcessor;
@class TRRailroad;
@class TRSwitchProcessor;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGDirector;

@class TRLevelView;

@interface TRLevelView : NSObject<EGLayerView, EGInputProcessor>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)_init;
- (void)draw;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


