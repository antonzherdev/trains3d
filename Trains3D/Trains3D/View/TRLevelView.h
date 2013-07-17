#import "objd.h"
#import "EGTypes.h"
@class EGCameraIso;
@class EGMapSso;
@class TRLevel;
@class TRLevelBackgroundView;
@class TRCityView;
#import "TRRailroadView.h"
#import "TRTrainView.h"

@class TRLevelView;

@interface TRLevelView : NSObject<EGView>
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id<EGCamera> camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)drawView;
@end


