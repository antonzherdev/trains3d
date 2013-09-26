#import "NSMutableSet+CNChain.h"
#import "NSSet+CNChain.h"


@implementation NSMutableSet (CNChain)
+ (id)mutableSet {
    return [NSMutableSet set];
}

- (void)appendItem:(id)object {
    [self addObject:object];
}

- (void)removeItem:(id)object {
    [self removeObject:object];
}
@end