#import "NSMutableArray+CNChain.h"
#import "NSArray+CNChain.h"


@implementation NSMutableArray (CNChain)
+ (NSMutableArray *)mutableArray {
    return [NSMutableArray array];
}

- (void)appendItem:(id)object {
    [self addObject:object];
}

- (void)removeItem:(id)object {
    [self removeObject:object];
}

@end