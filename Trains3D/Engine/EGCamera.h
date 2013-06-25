#import <Foundation/Foundation.h>
#import "EGTypes.h"

@interface EGCamera : NSObject
+ (id)camera;
- (id)init;
+ (void)isometricFocusWithViewSize:(CGSize)viewSize tilesOnScreen:(CGSize)tilesOnScreen center:(CGPoint)center;
@end


