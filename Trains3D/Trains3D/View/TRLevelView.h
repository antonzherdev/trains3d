#import <Foundation/Foundation.h>
#import "EGTypes.h"

@interface TRLevelView : NSObject
+ (id)levelView;
- (id)init;
- (void)drawController:(id)controller viewSize:(CGSize)viewSize;
@end


