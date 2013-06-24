#import <Foundation/Foundation.h>

@interface EGStat : NSObject
+ (id)stat;
- (id)init;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
@end


