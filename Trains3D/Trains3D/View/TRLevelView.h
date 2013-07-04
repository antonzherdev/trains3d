#import "objd.h"
#import "EGTypes.h"
#import "EGCameraIso.h"
#import "EG.h"
#import "EGGL.h"
#import "EGMapIso.h"
#import "TRLevel.h"
#import "TRLevelBackgroundView.h"
#import "TRCityView.h"
#import "TRRailroadView.h"

@class TRLevelView;

@interface TRLevelView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) id camera;

+ (id)levelViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (void)drawView;
@end


