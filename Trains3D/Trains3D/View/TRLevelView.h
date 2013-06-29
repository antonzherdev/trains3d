#import "objd.h"
#import "EGTypes.h"
#import "EGCamera.h"
#import "EGGL.h"
#import "EGMap.h"
#import "TRLevel.h"
#import "TRLevelBackgroundView.h"

@interface TRLevelView : NSObject
+ (id)levelView;
- (id)init;
- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize;
@end


