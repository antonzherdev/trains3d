#import "CNMap.h"

@implementation CNMap

+ (id)map {
    return [[CNMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (id)objectForKey:(id)key {
    @throw @"Method objectFor is abstract";
}

- (NSArray*)keys {
    @throw @"Method keys is abstract";
}

- (NSArray*)values {
    @throw @"Method values is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMap* o = ((CNMap*)other);
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNMutableMap

+ (id)mutableMap {
    return [[CNMutableMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (id)setObject:(id)object forKey:(id)forKey {
    @throw @"Method set is abstract";
}

- (id)removeObjectForKey:(id)key {
    @throw @"Method removeObjectFor is abstract";
}

- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith {
    id o = [self objectForKey:key];
    if([o isDefined]) {
        return [o get];
    } else {
        id init = orUpdateWith;
        [self setObject:init forKey:key];
        return init;
    }
}

- (id)modifyWith:(id(^)(id))with forKey:(id)forKey {
    id newObject = with([self objectForKey:forKey]);
    if([newObject isEmpty]) [self removeObjectForKey:forKey];
    else [self setObject:newObject forKey:forKey];
    return newObject;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMutableMap* o = ((CNMutableMap*)other);
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


