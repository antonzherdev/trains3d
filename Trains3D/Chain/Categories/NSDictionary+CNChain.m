#import "NSDictionary+CNChain.h"
#import "NSArray+CNChain.h"
#import "CNChain.h"
#import "CNTuple.h"
#import "CNEnumerator.h"
#import "CNOption.h"


@implementation NSDictionary (CNChain)
- (id <CNIterable>)values {
    return [self allValues];
}
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key {
    NSMutableDictionary * ret = [NSMutableDictionary dictionaryWithDictionary:self];
    [ret setObject:key forKey:key];
    return ret;
}

- (id)applyKey:(id)key {
    id ret = self[key];
    return ret == nil ? [NSNull null] : ret;
}

- (CNChain *)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(cnP)p {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        p(tuple(key, obj));
    }];
}

- (BOOL)goOn:(BOOL(^)(id))on {
    __block BOOL ret = YES;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(!on(tuple(key, obj))) {
            ret = NO;
            *stop = YES;
        }
    }];
    return ret;
}

- (id <CNIterator>)iterator {
    return nil;
}

- (BOOL)containsKey:(id)key {
    return [self objectForKey:key] != nil;
}

- (id <CNIterable>)keys {
    return [self allKeys];
}

- (id)head {
    if([[self iterator] hasNext]) return [CNOption opt:[[self iterator] next]];
    else return [CNOption none];
}

- (BOOL)containsObject:(id)object {
    return [[self allValues] containsObject:object];
}


- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = [CNOption none];
    [self goOn:^BOOL(id x) {
        if(where(ret)) {
            ret = [CNOption opt:x];
            NO;
        }
        return YES;
    }];
    return ret;
}

- (id)convertWithBuilder:(id <CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder addObject:x];
    }];
    return [builder build];
}

- (BOOL)isEmpty {
    return self.count == 0;
}
@end