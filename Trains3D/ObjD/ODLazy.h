#import "objdcore.h"

@class ODLazy;

@interface ODLazy : NSObject
@property (nonatomic, readonly) id(^f)();

+ (id)lazyWithF:(id(^)())f;
- (id)initWithF:(id(^)())f;
- (ODClassType*)type;
- (id)get;
+ (ODClassType*)type;
@end


