#import "CNTreeSet.h"
#import "NSObject+CNOption.h"

#import "CNCollection.h"
#import "CNChain.h"
#import "CNOption.h"
@implementation CNMutableTreeSet{
    CNMutableTreeMap* _map;
}
static NSObject* _CNMutableTreeSet_obj;
static ODType* _CNMutableTreeSet_type;
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
    _CNMutableTreeSet_obj = [NSObject object];
    _CNMutableTreeSet_type = [ODType typeWithCls:[CNMutableTreeSet class]];
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

- (ODType*)type {
    return _CNMutableTreeSet_type;
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

+ (ODType*)type {
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

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    return hash;
}

@end


