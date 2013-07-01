#import "CNCache.h"

@implementation CNCache{
    NSMutableDictionary* _map;
}

+ (id)cache {
    return [[CNCache alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _map = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)lookupWithDef:(id(^)())def forKey:(id)forKey {
    id v = [_map objectForKey:forKey];
    if(v == nil) {
        v = [self setObject:def() forKey:forKey];
    }
    return v;
}

- (id)setObject:(id)object forKey:(id)forKey {
    [_map setObject:object forKey:forKey];
    return object;
}

- (void)clear {
    [_map removeAllObjects];
}

@end

