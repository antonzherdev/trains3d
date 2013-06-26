#import <Foundation/Foundation.h>
#import "EGTypes.h"

@class TRLevel;

@interface TRLevelView : NSObject
+ (id)levelView;
- (id)init;
- (void)drawController:(TRLevel*)controller viewSize:(CGSize)viewSize;
@end


