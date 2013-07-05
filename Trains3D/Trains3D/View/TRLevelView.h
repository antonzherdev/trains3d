#import "objd.h"
#import "EGTypes.h"
@class EGCameraIso;
@class TRLevel;
@class TRLevelBackgroundView;
@class TRCityView;
#import "TRRailroadView.h"
#import "TRTrainView.h"

@class TRLevelView;

@interface TRLevelView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)drawView;
@end


