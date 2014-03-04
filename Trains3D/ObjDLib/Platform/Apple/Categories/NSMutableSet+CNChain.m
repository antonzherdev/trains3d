#import "NSMutableSet+CNChain.h"
#import "NSSet+CNChain.h"
#import "CNEnumerator.h"


@implementation NSMutableSet (CNChain)
+ (id)mutableSet {
    return [NSMutableSet set];
}

- (void)appendItem:(id)object {
    [self addObject:object];
}

- (BOOL)removeItem:(id)object {
    NSUInteger oldCount = self.count;
    [self removeObject:object];
    return oldCount > self.count;
}


- (void)mutableFilterBy:(BOOL(^)(id))by {
    @throw @"Hasn't implemented yet";
}


- (void)clear {
    [self removeAllObjects];
}

- (id <CNMutableIterator>)mutableIterator {
    return [CNMutableEnumerator enumeratorWithEnumerator:[self objectEnumerator]];
}
@end