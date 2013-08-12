#import "CNTreeSet.h"

@implementation CNTreeSet{
    CNTreeMap* _map;
}
@synthesize map = _map;

+ (id)treeSetWithMap:(CNTreeMap*)map {
    return [[CNTreeSet alloc] initWithMap:map];
}

- (id)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator {
    return [CNTreeSet treeSetWithMap:[CNTreeMap treeMapWithComparator:comparator]];
}

+ (CNTreeSet*)new {
    return [CNTreeSet treeSetWithMap:[CNTreeMap new]];
}

- (void)addObject:(id)object {
    ((NSObject*)[_map setObject:nil forKey:object]);
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [[_map keys] iterator];
}

- (id)head {
    return [_map firstKey];
}

- (id)last {
    return [_map lastKey];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeSet* o = ((CNTreeSet*)other);
    return self.map == o.map;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
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


