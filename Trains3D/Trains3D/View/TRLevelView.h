#import "objd.h"
#import "EGTypes.h"
#import "EGCamera.h"
#import "EG.h"
#import "EGGL.h"
#import "EGMap.h"
#import "TRLevel.h"
#import "TRLevelBackgroundView.h"
#import "TRCityView.h"

@class TRLevelView;

@interface TRLevelView : NSObject
+ (id)levelView;
- (id)init;
- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize;
- (void)processController:(TRLevel*)controller event:(EGEvent*)event;
@end


