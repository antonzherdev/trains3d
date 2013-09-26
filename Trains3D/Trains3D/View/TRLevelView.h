#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainView;
@class TRTreeView;
@class EGEnvironment;
@class EGDirectLight;
@class EGMapSso;
@class EGCameraIso;
@class TRTree;

@class TRLevelView;

@interface TRLevelView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (id<EGCamera>)cameraWithViewport:(GERect)viewport;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


