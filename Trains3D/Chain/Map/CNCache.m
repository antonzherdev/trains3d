#import "CNCache.h"

@implementation CNCache{
    NSDictionary* _map;
}

+ (id)cache {
    return [[CNCache alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _map = @{};
    }
    
    return self;
}

- (id)lookupWithKey:(id)key value:(id(^)())value {
    return [[_map optionObjectForKey:key] getOrElse:^id() {
        return [self updateWithKey:key value:value];
    }];
}

- (id)updateWithKey:(id)key value:(id)value {
    _map = [_map dictionaryByAddingValue:value forKey:key];
    return value;
}

- (void)clear {
    _map = @{};
}

@end


