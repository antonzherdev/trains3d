#import "NSSet+CNChain.h"
#import "CNChain.h"
#import "CNOption.h"
#import "CNEnumerator.h"


@implementation NSSet (CNChain)
- (id <CNIterator>)iterator {
    return [CNEnumerator enumeratorWithEnumerator:[self objectEnumerator]];
}

- (id)head {
    return [[self iterator] next];
}

- (BOOL)isEmpty {
    return self.count == 0;
}

- (CNChain *)chain {
    return [CNChain chainWithCollection:self];
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

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    for(id x in self)  {
        [builder addObject:x];
    }
    return [builder build];
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
@end