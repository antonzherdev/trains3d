#import "objd.h"

@class EGFence;

@interface EGFence : NSObject
- (instancetype)initWithName:(NSString *)name;
+ (instancetype)fenceWithName:(NSString *)name;

- (ODClassType*)type;
- (void)set;
- (void)clientWait;
- (void)wait;
+ (ODClassType*)type;

- (void)syncF:(void (^)())pFunction;
@end


