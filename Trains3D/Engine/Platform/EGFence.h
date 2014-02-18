#import "objd.h"

@class EGFence;

@interface EGFence : NSObject
+ (id)fence;
- (id)init;
- (ODClassType*)type;
- (void)set;
- (void)clientWait;
+ (ODClassType*)type;

- (void)syncF:(void (^)())pFunction;
@end


