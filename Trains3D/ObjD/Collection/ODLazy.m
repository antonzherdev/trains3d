#import "ODLazy.h"


@implementation ODLazy {
    BOOL evaluated;
    id value;
    LazyBlock block;
}
- (id)initWithBlock:(LazyBlock)aBlock {
    self = [super init];
    if (self) {
        block = aBlock;
        evaluated = NO;
    }

    return self;
}

+ (id)lazyWithBlock:(LazyBlock)aBlock {
    return [[self alloc] initWithBlock:aBlock];
}


- (id)get {
    if(evaluated) return value;
    value = block;
    return value;
}

@end