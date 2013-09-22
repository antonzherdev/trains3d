#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class TRLevel;
@class TRCityView;
@class TRRailroadView;
@class TRTrainView;
@class EGEnvironment;
@class EGDirectLight;
@class EGMapSso;
@class EGCameraIso;

@class TRLevelView;

@interface TRLevelView : NSObject<EGLayerView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) GERect viewportLayout;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


