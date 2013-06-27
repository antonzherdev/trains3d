#import <Foundation/Foundation.h>

typedef id (^LazyBlock)();

@interface ODLazy : NSObject
- (id)initWithBlock:(LazyBlock)aBlock;

+ (id)lazyWithBlock:(LazyBlock)aBlock;

- (id) get;
@end