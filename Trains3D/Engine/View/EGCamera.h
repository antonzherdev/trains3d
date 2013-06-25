#import <Foundation/Foundation.h>
#import "EGTypes.h"

static const double ISO = 0.70710676908493;

@interface EGCamera : NSObject
+ (id)camera;
- (id)init;
+ (void)isometricFocusWithViewSize:(CGSize)viewSize tilesOnScreen:(CGSize)tilesOnScreen center:(CGPoint)center;
@end


