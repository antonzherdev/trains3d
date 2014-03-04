#import "chain.h"


@implementation NSMutableDictionary (CNChain)
- (void)setKey:(id)key value:(id)value {
    [self setObject:value forKey:key];
}

- (id)removeForKey:(id)key {
    id ret = [self optKey:key];
    if([ret isDefined]) [self removeObjectForKey:key];
    return ret;
}

+ (NSMutableDictionary *)mutableDictionary {
    return [NSMutableDictionary dictionary];
}

- (id)objectForKey:(id)key orUpdateWith:(id (^)())with {
    id v = [self objectForKey:key];
    if(v != nil) return v;
    v = with();
    [self setObject:v forKey:key];
    return v;
}

- (id)takeKey:(id)key {
    id ret = self[key];
    if(ret != nil) [self removeObjectForKey:key];
    return ret == nil ? [CNOption none] : [CNSome someWithValue:ret];;
}


- (id)modifyKey:(id)key by:(id(^)(id))by {
    id v = by([self optKey:key]);
    if([v isEmpty]) {
        [self removeObjectForKey:v];
    } else {
        [self setObject:[v get] forKey:key];
    }
    return v;
}

- (void)appendItem:(CNTuple *)object {
    [self setObject:object.b forKey:object.a];
}

- (BOOL)removeItem:(CNTuple *)object {
    NSUInteger oldCount = self.count;
    [self removeObjectForKey:object.a];
    return oldCount > self.count;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    @throw @"Hasn't implemented yet";
}


- (void)clear {
    [self removeAllObjects];
}

- (id <CNMutableIterator>)mutableIterator {
    @throw @"Hasn't implemented yet";
}
@end