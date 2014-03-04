#import "NSMutableArray+CNChain.h"
#import "NSArray+CNChain.h"
#import "CNEnumerator.h"


@implementation NSMutableArray (CNChain)
+ (NSMutableArray *)mutableArray {
    return [NSMutableArray array];
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
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    NSUInteger i = 0;
    for(id item in self) {
        if(!by(item)) {
            [indexSet addIndex:i];
        }
        i++;
    }
    [self removeObjectsAtIndexes:indexSet];
}


- (void)clear {
    [self removeAllObjects];
}

- (void)removeIndex:(NSUInteger)index1 {
    [self removeObjectAtIndex:index1];
}

- (id <CNMutableIterator>)mutableIterator {
    return [CNMutableEnumerator enumeratorWithEnumerator:[self objectEnumerator]];
}
@end