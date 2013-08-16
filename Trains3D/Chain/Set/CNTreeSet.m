#import "CNTreeSet.h"

#import "CNCollection.h"
#import "CNChain.h"
@implementation CNTreeSet{
    CNTreeMap* _map;
}
static NSObject* _obj;
@synthesize map = _map;

+ (id)treeSetWithMap:(CNTreeMap*)map {
    return [[CNTreeSet alloc] initWithMap:map];
}

- (id)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _obj = [NSObject object];
}

+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator {
    return [CNTreeSet treeSetWithMap:[CNTreeMap treeMapWithComparator:comparator]];
}

+ (CNTreeSet*)new {
    return [CNTreeSet treeSetWithMap:[CNTreeMap new]];
}

- (id<CNList>)betweenA:(id)a b:(id)b {
    @throw @"Method between is abstract";
}

- (void)addObject:(id)object {
    ((NSObject*)[_map setObject:_obj forKey:object]);
}

- (BOOL)removeObject:(id)object {
    return [[_map removeForKey:object] isDefined];
}

- (id)higherThanObject:(id)object {
    return [_map higherKeyThanKey:object];
}

- (id)lowerThanObject:(id)object {
    return [_map lowerKeyThanKey:object];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [_map.keys iterator];
}

- (id<CNIterator>)iteratorHigherThanObject:(id)object {
    return [_map.keys iteratorHigherThanKey:object];
}

- (id)head {
    return [_map firstKey];
}

- (id)last {
    return [_map lastKey];
}

- (BOOL)containsObject:(id)object {
    return [_map containsKey:object];
}

- (void)clear {
    [_map clear];
}

- (void)addAllObjects:(id<CNTraversable>)objects {
    [objects forEach:^void(id _) {
        [self addObject:_];
    }];
}

- (CNTreeSet*)reorder {
    CNTreeSet* ret = [CNTreeSet treeSetWithMap:[CNTreeMap treeMapWithComparator:_map.comparator]];
    [ret addAllObjects:self];
    return ret;
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
    CNTreeSet* o = ((CNTreeSet*)other);
    return [self.map isEqual:o.map];
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


