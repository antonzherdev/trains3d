#import "NSDictionary+CNMap.h"


@implementation NSDictionary (CNMap)
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key {
    NSMutableDictionary * ret = [NSMutableDictionary dictionaryWithDictionary:self];
    [ret setObject:key forKey:key];
    return ret;
}

- (id)optionObjectForKey:(id)key {
    id ret = self[key];
    return ret == nil ? [NSNull null] : ret;
}


@end