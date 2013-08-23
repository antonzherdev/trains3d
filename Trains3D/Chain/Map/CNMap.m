#import "CNMap.h"
#import "CNOption.h"

#import "CNChain.h"
#import "CNTuple.h"
@implementation CNMapDefault{
    id(^_defaultFunc)(id);
    id<CNMutableMap> _map;
}
@synthesize defaultFunc = _defaultFunc;
@synthesize map = _map;

+ (id)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map {
    return [[CNMapDefault alloc] initWithDefaultFunc:defaultFunc map:map];
}

- (id)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map {
    self = [super init];
    if(self) {
        _defaultFunc = defaultFunc;
        _map = map;
    }
    
    return self;
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [_map iterator];
}

- (id)applyKey:(id)key {
    return [_map objectForKey:key orUpdateWith:^id() {
        return _defaultFunc(key);
    }];
}

- (id<CNIterable>)keys {
    return [_map keys];
}

- (id<CNIterable>)values {
    return [_map values];
}

- (BOOL)containsKey:(id)key {
    return [_map containsKey:key];
}

- (void)setObject:(id)object forKey:(id)forKey {
    [_map setObject:object forKey:forKey];
}

- (id)modifyBy:(id(^)(id))by forKey:(id)forKey {
    id object = by([self applyKey:forKey]);
    [_map setObject:object forKey:forKey];
    return object;
}

- (void)addObject:(CNTuple*)object {
    [_map addObject:object];
}

- (void)removeObject:(CNTuple*)object {
    [_map removeObject:object];
}

- (id)head {
    if([[self iterator] hasNext]) return [CNOption opt:[[self iterator] next]];
    else return [CNOption none];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        each([i next]);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsObject:(id)object {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder addObject:x];
    }];
    return [builder build];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMapDefault* o = ((CNMapDefault*)(other));
    return [self.defaultFunc isEqual:o.defaultFunc] && [self.map isEqual:o.map];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.defaultFunc hash];
    hash = hash * 31 + [self.map hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


