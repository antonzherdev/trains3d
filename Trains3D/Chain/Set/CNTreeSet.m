#import "objd.h"
#import "CNTreeSet.h"

#import "ODObject.h"
#import "CNTreeMap.h"
#import "CNCollection.h"
@implementation CNMutableTreeSet{
    CNMutableTreeMap* _map;
}
static NSObject* _CNMutableTreeSet_obj;
static ODClassType* _CNMutableTreeSet_type;
@synthesize map = _map;

+ (id)mutableTreeSetWithMap:(CNMutableTreeMap*)map {
    return [[CNMutableTreeSet alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNMutableTreeSet_type = [ODClassType classTypeWithCls:[CNMutableTreeSet class]];
    _CNMutableTreeSet_obj = [NSObject object];
}

+ (CNMutableTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator {
    return [CNMutableTreeSet mutableTreeSetWithMap:[CNMutableTreeMap mutableTreeMapWithComparator:comparator]];
}

+ (CNMutableTreeSet*)new {
    return [CNMutableTreeSet mutableTreeSetWithMap:[CNMutableTreeMap new]];
}

- (id<CNSeq>)betweenA:(id)a b:(id)b {
    @throw @"Method between is abstract";
}

- (void)addObject:(id)object {
    [_map setObject:_CNMutableTreeSet_obj forKey:object];
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

- (CNMutableTreeSet*)reorder {
    CNMutableTreeSet* ret = [CNMutableTreeSet mutableTreeSetWithMap:[CNMutableTreeMap mutableTreeMapWithComparator:_map.comparator]];
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

- (NSString*)description {
    return [[self chain] toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        ret = ret * 31 + [[i next] hash];
    }
    return ret;
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

- (ODClassType*)type {
    return [CNMutableTreeSet type];
}

+ (ODClassType*)type {
    return _CNMutableTreeSet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMutableTreeSet* o = ((CNMutableTreeSet*)(other));
    return [self.map isEqual:o.map];
}

@end


