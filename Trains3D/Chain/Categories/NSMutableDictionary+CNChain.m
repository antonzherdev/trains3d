#import "chain.h"


@implementation NSMutableDictionary (CNChain)
- (id)removeForKey:(id)key {
    id ret = [self applyKey:key];
    [self removeObjectForKey:key];
    return ret;
}

- (id)applyKey:(id)key {
    return [CNOption opt:[self objectForKey:key]];
}

- (id)objectForKey:(id)key orUpdateWith:(id (^)())with {
    id v = [self objectForKey:key];
    if(v != nil) return v;
    v = with();
    [self setObject:v forKey:key];
    return v;
}

- (id)modifyWith:(id (^)(id))with forKey:(id)key {
    id v = with([self optionObjectForKey:key]);
    if([v isEmpty]) {
        [self removeObjectForKey:v];
    } else {
        [self setObject:v forKey:key];
    }
    return v;
}
@end