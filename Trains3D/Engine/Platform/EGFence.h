#import "objd.h"

@class EGFence;

@interface EGFence : NSObject
- (instancetype)initWithName:(NSString *)name;
+ (instancetype)fenceWithName:(NSString *)name;

- (CNClassType*)type;
- (void)set;
- (void)clientWait;
- (void)wait;
+ (CNClassType*)type;

- (void)syncF:(void (^)())pFunction;
@end


