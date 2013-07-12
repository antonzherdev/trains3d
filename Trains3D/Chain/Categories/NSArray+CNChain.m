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

- (CNChain *)reverse {
    return [[self chain] reverse];
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

- (CNChain *)append:(id)collection {
    return [[self chain] append:collection];
}

- (CNChain *)prepend:(id)collection {
    return [[self chain] prepend:collection];
}

- (CNChain *)exclude:(id)collection {
    return [[self chain] exclude:collection];
}

- (CNChain *)intersect:(id)collection {
    return [[self chain] intersect:collection];
}

- (CNChain *)mul:(id)collection {
    return [[self chain] mul:collection];
}

- (id)head {
    if(self.count == 0) return nil;
    return [self objectAtIndex : 0];
}

- (id)randomItem {
    return [[self chain] randomItem];
}

- (void)forEach:(cnP)p {
    for(id item in self)  {
        p(item);
    }
}

- (id)fold:(cnF2)f withStart:(id)start {
    return [[self chain] fold:f withStart:start];
}

- (id)find:(cnPredicate)predicate {
    return [[self chain] find:predicate];
}


@end