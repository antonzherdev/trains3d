#import "objd.h"
#import "CNTreeSet.h"

#import "CNTreeMap.h"
#import "ODType.h"
#import "CNChain.h"
#import "CNDispatchQueue.h"
#import "ObjC.h"
@implementation CNTreeSet
static ODClassType* _CNTreeSet_type;
@synthesize map = _map;

+ (instancetype)treeSetWithMap:(CNTreeMap*)map {
    return [[CNTreeSet alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeSet class]) _CNTreeSet_type = [ODClassType classTypeWithCls:[CNTreeSet class]];
}

- (id)higherThanItem:(id)item {
    return [_map higherKeyThanKey:item];
}

- (id)lowerThanItem:(id)item {
    return [_map lowerKeyThanKey:item];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [[_map keys] iterator];
}

- (id<CNIterator>)iteratorHigherThanItem:(id)item {
    return [[_map keys] iteratorHigherThanKey:item];
}

- (id)head {
    return [[_map firstKey] get];
}

- (id)headOpt {
    return [_map firstKey];
}

- (id)last {
    return [_map lastKey];
}

- (BOOL)containsItem:(id)item {
    return [_map containsKey:item];
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

- (void)parForEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        id v = [i next];
        [CNDispatchQueue.aDefault asyncF:^void() {
            each(v);
        }];
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
        if(where(x)) {
            ret = [CNOption applyValue:x];
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)existsWhere:(BOOL(^)(id))where {
    __block BOOL ret = NO;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = YES;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)allConfirm:(BOOL(^)(id))confirm {
    __block BOOL ret = YES;
    [self goOn:^BOOL(id x) {
        if(!(confirm(x))) {
            ret = NO;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder appendItem:x];
    }];
    return [builder build];
}

- (ODClassType*)type {
    return [CNTreeSet type];
}

+ (ODClassType*)type {
    return _CNTreeSet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNImTreeSet
static ODClassType* _CNImTreeSet_type;

+ (instancetype)imTreeSetWithMap:(CNTreeMap*)map {
    return [[CNImTreeSet alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super initWithMap:map];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImTreeSet class]) _CNImTreeSet_type = [ODClassType classTypeWithCls:[CNImTreeSet class]];
}

- (ODClassType*)type {
    return [CNImTreeSet type];
}

+ (ODClassType*)type {
    return _CNImTreeSet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNTreeSetBuilder
static ODClassType* _CNTreeSetBuilder_type;
@synthesize comparator = _comparator;

+ (instancetype)treeSetBuilderWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNTreeSetBuilder alloc] initWithComparator:comparator];
}

- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super init];
    if(self) {
        _comparator = [comparator copy];
        _set = [CNMTreeSet applyComparator:_comparator];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeSetBuilder class]) _CNTreeSetBuilder_type = [ODClassType classTypeWithCls:[CNTreeSetBuilder class]];
}

+ (CNTreeSetBuilder*)apply {
    return [CNTreeSetBuilder treeSetBuilderWithComparator:^NSInteger(id a, id b) {
        return [a compareTo:b];
    }];
}

- (void)appendItem:(id)item {
    [_set appendItem:item];
}

- (CNTreeSet*)build {
    return _set;
}

- (void)appendAllItems:(id<CNTraversable>)items {
    [items forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (ODClassType*)type {
    return [CNTreeSetBuilder type];
}

+ (ODClassType*)type {
    return _CNTreeSetBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNMTreeSet
static NSObject* _CNMTreeSet_obj;
static ODClassType* _CNMTreeSet_type;
@synthesize mmap = _mmap;

+ (instancetype)treeSetWithMmap:(CNMTreeMap*)mmap {
    return [[CNMTreeSet alloc] initWithMmap:mmap];
}

- (instancetype)initWithMmap:(CNMTreeMap*)mmap {
    self = [super initWithMap:mmap];
    if(self) _mmap = mmap;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMTreeSet class]) {
        _CNMTreeSet_type = [ODClassType classTypeWithCls:[CNMTreeSet class]];
        _CNMTreeSet_obj = [NSObject object];
    }
}

+ (CNMTreeSet*)applyComparator:(NSInteger(^)(id, id))comparator {
    return [CNMTreeSet treeSetWithMmap:[CNMTreeMap treeMapWithComparator:comparator]];
}

+ (CNMTreeSet*)apply {
    return [CNMTreeSet treeSetWithMmap:[CNMTreeMap apply]];
}

- (id<CNMIterator>)mutableIterator {
    return [_mmap.keys mutableIterator];
}

- (void)appendItem:(id)item {
    [_mmap setKey:item value:_CNMTreeSet_obj];
}

- (BOOL)removeItem:(id)item {
    return [[_mmap removeForKey:item] isDefined];
}

- (void)clear {
    [_mmap clear];
}

- (void)addAllObjects:(id<CNTraversable>)objects {
    [objects forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (CNMTreeSet*)reorder {
    CNMTreeSet* ret = [CNMTreeSet treeSetWithMmap:[CNMTreeMap treeMapWithComparator:_mmap.comparator]];
    [ret addAllObjects:self];
    return ret;
}

- (id<CNImSet>)im {
    return [self imCopy];
}

- (id<CNImSet>)imCopy {
    NSMutableSet* arr = [NSMutableSet mutableSet];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return [arr im];
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    id<CNMIterator> i = [self mutableIterator];
    while([i hasNext]) {
        if(by([i next])) [i remove];
    }
}

- (ODClassType*)type {
    return [CNMTreeSet type];
}

+ (ODClassType*)type {
    return _CNMTreeSet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mmap=%@", self.mmap];
    [description appendString:@">"];
    return description;
}

@end


