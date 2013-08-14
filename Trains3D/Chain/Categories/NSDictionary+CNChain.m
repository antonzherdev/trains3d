#import "NSDictionary+CNChain.h"
#import "CNChain.h"
#import "CNTuple.h"


@implementation NSDictionary (CNChain)
- (NSArray *)values {
    return [self allValues];
}
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key {
    NSMutableDictionary * ret = [NSMutableDictionary dictionaryWithDictionary:self];
    [ret setObject:key forKey:key];
    return ret;
}

- (id)optionObjectForKey:(id)key {
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

- (BOOL)isEmpty {
    return self.count == 0;
}
@end