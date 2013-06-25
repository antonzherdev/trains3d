#import <Foundation/Foundation.h>
#import "EGTypes.h"

@interface EGText : NSObject
+ (id)text;
- (id)init;
+ (void)glutDrawText:(NSString*)text font:(void*)font position:(CGPoint)position;
@end


