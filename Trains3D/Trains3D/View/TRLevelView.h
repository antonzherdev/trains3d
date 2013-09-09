#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@class TRLevel;
@class TRLevelBackgroundView;
@class TRCityView;
@class TRRailroadView;
@class TRTrainView;
@class EGMapSso;
@class EGCameraIso;

@class TRLevelView;

@interface TRLevelView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGEnvironment* environment;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)drawView;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


