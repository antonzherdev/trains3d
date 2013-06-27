#import "NSArray+CNChain.h"
#import "CNChain.h"


@implementation NSArray (CNChain)
- (id)chain:(void (^)(CNChain *))block {
    CNChain *chain = [CNChain chainWithCollection:self];
    block(chain);
    return [chain array];
}

- (CNChain *)chain {
    return [CNChain chainWithCollection:self];
}

- (CNChain *)filter:(cnPredicate)predicate {
    return [[self chain] filter:predicate];
}

- (CNChain *)filter:(cnPredicate)predicate selectivity:(double)selectivity {
    return [[self chain] filter:predicate selectivity:selectivity];
}

- (CNChain *)map:(cnF)f {
    return [[self chain] map:f];
}


@end