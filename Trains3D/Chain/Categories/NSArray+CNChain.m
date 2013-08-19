#import "CNCollection.h"
#import "NSArray+CNChain.h"
#import "NSSet+CNChain.h"
#import "CNChain.h"
#import "CNOption.h"
#import "CNEnumerator.h"


@implementation NSArray (CNChain)
- (id)chain:(void (^)(CNChain *))block {
    CNChain *chain = [CNChain chainWithCollection:self];
    block(chain);
    return [chain toArray];
}

- (CNChain *)chain {
    return [CNChain chainWithCollection:self];
}

- (id <CNIterator>)iterator {
    return [CNEnumerator enumeratorWithEnumerator:[self objectEnumerator]];
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (id)head {
    if(self.count == 0) return [CNOption none];
    return [self objectAtIndex : 0];
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    for(id x in self)  {
        [builder addObject:x];
    }
    return [builder build];
}


- (id)randomItem {
    if([self isEmpty]) return [CNOption none];
    else return [self objectAtIndex:randomWith([self count] - 1)];
}

- (id)findWhere:(BOOL(^)(id))where {
    id ret = [CNOption none];
    for(id item in self)  {
        if(where(item)) {
            ret = item;
            break;
        }
    }
    return ret;
}

- (void)forEach:(cnP)p {
    for(id item in self)  {
        p(item);
    }
}

- (BOOL)goOn:(BOOL (^)(id))on {
    for(id item in self)  {
        if(!on(item)) return NO;
    }
    return YES;
}


- (NSArray *)arrayByRemovingObject:(id)object {
    return [[[self chain] filter:^BOOL(id x) {
        return ![x isEqual:object];
    }] toArray];
}

- (id <CNSet>)toSet {
    return [NSSet setWithArray:self];
}

- (id)applyIndex:(NSUInteger)index {
    if(index >= self.count) return [CNOption none];
    return [self objectAtIndex:index];
}

@end