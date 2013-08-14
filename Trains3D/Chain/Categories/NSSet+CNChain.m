#import "NSSet+CNChain.h"
#import "CNChain.h"


@implementation NSSet (CNChain)
- (id <CNIterator>)iterator {
    return nil;
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