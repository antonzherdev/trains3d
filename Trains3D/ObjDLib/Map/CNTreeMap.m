#import "objd.h"
#import "CNTreeMap.h"

#import "ODType.h"
#import "CNDispatchQueue.h"
#import "CNChain.h"
@implementation CNTreeMap
static NSInteger _CNTreeMap_BLACK = 0;
static NSInteger _CNTreeMap_RED = 1;
static ODClassType* _CNTreeMap_type;
@synthesize comparator = _comparator;
@synthesize values = _values;

+ (instancetype)treeMapWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNTreeMap alloc] initWithComparator:comparator];
}

- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super init];
    if(self) {
        _comparator = [comparator copy];
        _values = [CNTreeMapValues treeMapValuesWithMap:self];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMap class]) _CNTreeMap_type = [ODClassType classTypeWithCls:[CNTreeMap class]];
}

- (id)applyKey:(id)key {
    return ((CNTreeMapEntry*)(nonnil([self entryForKey:key]))).value;
}

- (id)optKey:(id)key {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self entryForKey:key]));
    if(_ != nil) return ((CNTreeMapEntry*)(_)).value;
    else return nil;
}

- (CNTreeMapEntry*)root {
    @throw @"Method root is abstract";
}

- (BOOL)isEmpty {
    return [self root] == nil;
}

- (CNTreeMapEntry*)entryForKey:(id)key {
    CNTreeMapEntry* p = [self root];
    while(p != nil) {
        NSInteger cmp = _comparator(key, ((CNTreeMapEntry*)(nonnil(p))).key);
        if(cmp < 0) {
            p = ((CNTreeMapEntry*)(nonnil(p))).left;
        } else {
            if(cmp > 0) p = ((CNTreeMapEntry*)(nonnil(p))).right;
            else break;
        }
    }
    return p;
}

- (id<CNTreeMapKeySet>)keys {
    @throw @"Method keys is abstract";
}

- (id<CNIterator>)iterator {
    return [CNTreeMapIterator applyMap:self entry:[self firstEntry]];
}

- (CNTreeMapIterator*)iteratorHigherThanKey:(id)key {
    return [CNTreeMapIterator applyMap:self entry:[self higherEntryThanKey:key]];
}

- (CNTreeMapEntry*)firstEntry {
    CNTreeMapEntry* p = [self root];
    if(p != nil) while(((CNTreeMapEntry*)(nonnil(p))).left != nil) {
        p = ((CNTreeMapEntry*)(nonnil(p))).left;
    }
    return p;
}

- (id)firstKey {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self firstEntry]));
    if(_ != nil) return ((CNTreeMapEntry*)(_)).key;
    else return nil;
}

- (id)lastKey {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self lastEntry]));
    if(_ != nil) return ((CNTreeMapEntry*)(_)).key;
    else return nil;
}

- (id)lowerKeyThanKey:(id)key {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self lowerEntryThanKey:key]));
    if(_ != nil) return ((CNTreeMapEntry*)(_)).key;
    else return nil;
}

- (id)higherKeyThanKey:(id)key {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self higherEntryThanKey:key]));
    if(_ != nil) return ((CNTreeMapEntry*)(_)).key;
    else return nil;
}

- (CNTreeMapEntry*)lowerEntryThanKey:(id)key {
    CNTreeMapEntry* p = [self root];
    while(p != nil) {
        NSInteger cmp = _comparator(key, ((CNTreeMapEntry*)(nonnil(p))).key);
        if(cmp > 0) {
            if(((CNTreeMapEntry*)(nonnil(p))).right != nil) p = ((CNTreeMapEntry*)(nonnil(p))).right;
            else return p;
        } else {
            if(((CNTreeMapEntry*)(nonnil(p))).left != nil) {
                p = ((CNTreeMapEntry*)(nonnil(p))).left;
            } else {
                CNTreeMapEntry* parent = ((CNTreeMapEntry*)(nonnil(p))).parent;
                CNTreeMapEntry* ch = p;
                while(parent != nil && [ch isEqual:((CNTreeMapEntry*)(nonnil(parent))).left]) {
                    ch = parent;
                    parent = ((CNTreeMapEntry*)(nonnil(parent))).parent;
                }
                return parent;
            }
        }
    }
    return nil;
}

- (CNTreeMapEntry*)higherEntryThanKey:(id)key {
    CNTreeMapEntry* p = [self root];
    while(p != nil) {
        NSInteger cmp = _comparator(key, ((CNTreeMapEntry*)(nonnil(p))).key);
        if(cmp < 0) {
            if(((CNTreeMapEntry*)(nonnil(p))).left != nil) p = ((CNTreeMapEntry*)(nonnil(p))).left;
            else return p;
        } else {
            if(((CNTreeMapEntry*)(nonnil(p))).right != nil) {
                p = ((CNTreeMapEntry*)(nonnil(p))).right;
            } else {
                CNTreeMapEntry* parent = ((CNTreeMapEntry*)(nonnil(p))).parent;
                CNTreeMapEntry* ch = p;
                while(parent != nil && [ch isEqual:((CNTreeMapEntry*)(nonnil(parent))).right]) {
                    ch = parent;
                    parent = ((CNTreeMapEntry*)(nonnil(parent))).parent;
                }
                return parent;
            }
        }
    }
    return nil;
}

- (CNTreeMapEntry*)lastEntry {
    CNTreeMapEntry* p = [self root];
    if(p != nil) while(((CNTreeMapEntry*)(nonnil(p))).right != nil) {
        p = ((CNTreeMapEntry*)(nonnil(p))).right;
    }
    return p;
}

- (id<CNImMap>)addItem:(CNTuple*)item {
    CNHashMapBuilder* builder = [CNHashMapBuilder hashMapBuilder];
    [builder appendAllItems:self];
    [builder appendItem:item];
    return [builder build];
}

- (id<CNMMap>)mCopy {
    NSMutableDictionary* m = [NSMutableDictionary mutableDictionary];
    [m assignImMap:self];
    return m;
}

- (id)getKey:(id)key orValue:(id)orValue {
    id __tmp = [self optKey:key];
    if(__tmp != nil) return ((id)(__tmp));
    else return orValue;
}

- (BOOL)containsKey:(id)key {
    return [self optKey:key] != nil;
}

- (BOOL)isValueEqualKey:(id)key value:(id)value {
    id __tmp;
    {
        id _ = ((id)([self optKey:key]));
        if(_ != nil) __tmp = numb([_ isEqual:value]);
        else __tmp = nil;
    }
    if(__tmp != nil) return unumb(__tmp);
    else return NO;
}

- (NSUInteger)count {
    id<CNIterator> i = [self iterator];
    NSUInteger n = 0;
    while([i hasNext]) {
        [i next];
        n++;
    }
    return n;
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return nil;
    else return [self head];
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

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = nil;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = x;
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
    return [CNTreeMap type];
}

+ (NSInteger)BLACK {
    return _CNTreeMap_BLACK;
}

+ (NSInteger)RED {
    return _CNTreeMap_RED;
}

+ (ODClassType*)type {
    return _CNTreeMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNImTreeMap
static ODClassType* _CNImTreeMap_type;
@synthesize root = _root;
@synthesize count = _count;
@synthesize keys = _keys;

+ (instancetype)imTreeMapWithComparator:(NSInteger(^)(id, id))comparator root:(CNTreeMapEntry*)root count:(NSUInteger)count {
    return [[CNImTreeMap alloc] initWithComparator:comparator root:root count:count];
}

- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator root:(CNTreeMapEntry*)root count:(NSUInteger)count {
    self = [super initWithComparator:comparator];
    if(self) {
        _root = root;
        _count = count;
        _keys = [CNImTreeMapKeySet imTreeMapKeySetWithMap:self];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImTreeMap class]) _CNImTreeMap_type = [ODClassType classTypeWithCls:[CNImTreeMap class]];
}

- (BOOL)isEmpty {
    return _root == nil;
}

- (CNMTreeMap*)mCopy {
    CNMTreeMap* m = [CNMTreeMap treeMapWithComparator:self.comparator];
    [m assignImMap:self];
    return m;
}

- (ODClassType*)type {
    return [CNImTreeMap type];
}

+ (ODClassType*)type {
    return _CNImTreeMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"root=%@", self.root];
    [description appendFormat:@", count=%lu", (unsigned long)self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNTreeMapBuilder
static ODClassType* _CNTreeMapBuilder_type;
@synthesize comparator = _comparator;

+ (instancetype)treeMapBuilderWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNTreeMapBuilder alloc] initWithComparator:comparator];
}

- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super init];
    if(self) {
        _comparator = [comparator copy];
        _map = [CNMTreeMap treeMapWithComparator:_comparator];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapBuilder class]) _CNTreeMapBuilder_type = [ODClassType classTypeWithCls:[CNTreeMapBuilder class]];
}

+ (CNTreeMapBuilder*)apply {
    return [CNTreeMapBuilder treeMapBuilderWithComparator:^NSInteger(id a, id b) {
        return [a compareTo:b];
    }];
}

- (void)appendItem:(CNTuple*)item {
    [_map appendItem:item];
}

- (CNTreeMap*)build {
    return _map;
}

- (void)appendAllItems:(id<CNTraversable>)items {
    [items forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (ODClassType*)type {
    return [CNTreeMapBuilder type];
}

+ (ODClassType*)type {
    return _CNTreeMapBuilder_type;
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


@implementation CNMTreeMap
static ODClassType* _CNMTreeMap_type;
@synthesize keys = _keys;

+ (instancetype)treeMapWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNMTreeMap alloc] initWithComparator:comparator];
}

- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super initWithComparator:comparator];
    if(self) {
        __root = nil;
        __size = 0;
        _keys = [CNMTreeMapKeySet treeMapKeySetWithMap:self];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMTreeMap class]) _CNMTreeMap_type = [ODClassType classTypeWithCls:[CNMTreeMap class]];
}

+ (CNMTreeMap*)apply {
    return [CNMTreeMap treeMapWithComparator:^NSInteger(id a, id b) {
        return [a compareTo:b];
    }];
}

- (CNImTreeMap*)imCopy {
    return [CNImTreeMap imTreeMapWithComparator:self.comparator root:[__root copyParent:nil] count:__size];
}

- (CNImTreeMap*)im {
    return [CNImTreeMap imTreeMapWithComparator:self.comparator root:__root count:__size];
}

- (void)assignImMap:(id<CNImMap>)imMap {
    if([imMap isKindOfClass:[CNImTreeMap class]]) {
        CNImTreeMap* m = ((CNImTreeMap*)(imMap));
        __root = [m.root copyParent:nil];
        __size = m.count;
    } else {
        [self clear];
        [imMap forEach:^void(CNTuple* _) {
            [self appendItem:_];
        }];
    }
}

- (CNTreeMapEntry*)root {
    return __root;
}

- (NSUInteger)count {
    return __size;
}

- (void)clear {
    __size = 0;
    __root = nil;
}

- (id<CNMIterator>)mutableIterator {
    return [CNMTreeMapIterator applyMap:self entry:[self firstEntry]];
}

- (void)setKey:(id)key value:(id)value {
    NSInteger(^_comparator)(id, id) = self.comparator;
    CNTreeMapEntry* t = __root;
    if(t == nil) {
        __root = [CNTreeMapEntry applyKey:key value:value parent:nil];
        __size = 1;
    } else {
        NSInteger cmp = 0;
        CNTreeMapEntry* parent = nil;
        do {
            parent = t;
            cmp = _comparator(key, ((CNTreeMapEntry*)(nonnil(t))).key);
            if(cmp < 0) {
                t = ((CNTreeMapEntry*)(nonnil(t))).left;
            } else {
                if(cmp > 0) {
                    t = ((CNTreeMapEntry*)(nonnil(t))).right;
                } else {
                    ((CNTreeMapEntry*)(nonnil(t))).value = value;
                    return ;
                }
            }
        } while(t != nil);
        CNTreeMapEntry* e = [CNTreeMapEntry applyKey:key value:value parent:parent];
        if(cmp < 0) ((CNTreeMapEntry*)(nonnil(parent))).left = e;
        else ((CNTreeMapEntry*)(nonnil(parent))).right = e;
        [self fixAfterInsertionEntry:e];
        __size++;
    }
}

- (id)removeForKey:(id)key {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)([self entryForKey:key]));
    if(_ != nil) return [self deleteEntry:_];
    else return nil;
}

- (id)deleteEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* p = entry;
    __size--;
    if(p.left != nil && p.right != nil) {
        CNTreeMapEntry* s = ((CNTreeMapEntry*)(nonnil([p next])));
        p.key = s.key;
        p.value = s.value;
        p = s;
    }
    CNTreeMapEntry* replacement = ((p.left != nil) ? p.left : p.right);
    if(replacement != nil) {
        ((CNTreeMapEntry*)(nonnil(replacement))).parent = p.parent;
        if(p.parent == nil) {
            __root = replacement;
        } else {
            if([p isEqual:((CNTreeMapEntry*)(nonnil(p.parent))).left]) ((CNTreeMapEntry*)(nonnil(p.parent))).left = replacement;
            else ((CNTreeMapEntry*)(nonnil(p.parent))).right = replacement;
        }
        p.left = nil;
        p.right = nil;
        p.parent = nil;
        if(p.color == [CNMTreeMap BLACK]) [self fixAfterDeletionEntry:((CNTreeMapEntry*)(nonnil(replacement)))];
    } else {
        if(p.parent == nil) {
            __root = nil;
        } else {
            if(p.color == [CNMTreeMap BLACK]) [self fixAfterDeletionEntry:p];
            if(p.parent != nil) {
                if([p isEqual:((CNTreeMapEntry*)(nonnil(p.parent))).left]) {
                    ((CNTreeMapEntry*)(nonnil(p.parent))).left = nil;
                } else {
                    if([p isEqual:((CNTreeMapEntry*)(nonnil(p.parent))).right]) ((CNTreeMapEntry*)(nonnil(p.parent))).right = nil;
                }
                p.parent = nil;
            }
        }
    }
    return entry.value;
}

- (void)fixAfterInsertionEntry:(CNTreeMapEntry*)entry {
    entry.color = [CNMTreeMap RED];
    CNTreeMapEntry* x = entry;
    while(x != nil && !([x isEqual:__root]) && ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color == [CNMTreeMap RED]) {
        if([((CNTreeMapEntry*)(nonnil(x))).parent isEqual:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).left]) {
            CNTreeMapEntry* y = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).right;
            if(((CNTreeMapEntry*)(nonnil(y))).color == [CNMTreeMap RED]) {
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(y))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).color = [CNMTreeMap RED];
                x = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent;
            } else {
                if([x isEqual:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).right]) {
                    x = ((CNTreeMapEntry*)(nonnil(x))).parent;
                    [self rotateLeftP:x];
                }
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).color = [CNMTreeMap RED];
                [self rotateRightP:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent];
            }
        } else {
            CNTreeMapEntry* y = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).left;
            if(((CNTreeMapEntry*)(nonnil(y))).color == [CNMTreeMap RED]) {
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(y))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).color = [CNMTreeMap RED];
                x = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent;
            } else {
                if([x isEqual:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).left]) {
                    x = ((CNTreeMapEntry*)(nonnil(x))).parent;
                    [self rotateRightP:x];
                }
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent))).color = [CNMTreeMap RED];
                [self rotateLeftP:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).parent];
            }
        }
    }
    ((CNTreeMapEntry*)(nonnil(__root))).color = [CNMTreeMap BLACK];
}

- (void)fixAfterDeletionEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* x = entry;
    while(!([x isEqual:__root]) && ((CNTreeMapEntry*)(nonnil(x))).color == [CNMTreeMap BLACK]) {
        if([x isEqual:((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).left]) {
            CNTreeMapEntry* sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).right)));
            if(sib.color == [CNMTreeMap RED]) {
                sib.color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap RED];
                [self rotateLeftP:((CNTreeMapEntry*)(nonnil(x))).parent];
                sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).right)));
            }
            if(((CNTreeMapEntry*)(nonnil(sib.left))).color == [CNMTreeMap BLACK] && ((CNTreeMapEntry*)(nonnil(sib.right))).color == [CNMTreeMap BLACK]) {
                sib.color = [CNMTreeMap RED];
                x = ((CNTreeMapEntry*)(nonnil(x))).parent;
            } else {
                if(((CNTreeMapEntry*)(nonnil(sib.right))).color == [CNMTreeMap BLACK]) {
                    ((CNTreeMapEntry*)(nonnil(sib.left))).color = [CNMTreeMap BLACK];
                    sib.color = [CNMTreeMap RED];
                    [self rotateRightP:sib];
                    sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).right)));
                }
                sib.color = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color;
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(sib.right))).color = [CNMTreeMap BLACK];
                [self rotateLeftP:((CNTreeMapEntry*)(nonnil(x))).parent];
                x = __root;
            }
        } else {
            CNTreeMapEntry* sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).left)));
            if(sib.color == [CNMTreeMap RED]) {
                sib.color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap RED];
                [self rotateRightP:((CNTreeMapEntry*)(nonnil(x))).parent];
                sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).left)));
            }
            if(((CNTreeMapEntry*)(nonnil(sib.right))).color == [CNMTreeMap BLACK] && ((CNTreeMapEntry*)(nonnil(sib.left))).color == [CNMTreeMap BLACK]) {
                sib.color = [CNMTreeMap RED];
                x = ((CNTreeMapEntry*)(nonnil(x))).parent;
            } else {
                if(((CNTreeMapEntry*)(nonnil(sib.left))).color == [CNMTreeMap BLACK]) {
                    ((CNTreeMapEntry*)(nonnil(sib.right))).color = [CNMTreeMap BLACK];
                    sib.color = [CNMTreeMap RED];
                    [self rotateLeftP:sib];
                    sib = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).left)));
                }
                sib.color = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color;
                ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(x))).parent))).color = [CNMTreeMap BLACK];
                ((CNTreeMapEntry*)(nonnil(sib.left))).color = [CNMTreeMap BLACK];
                [self rotateRightP:((CNTreeMapEntry*)(nonnil(x))).parent];
                x = __root;
            }
        }
    }
    if(x != nil) ((CNTreeMapEntry*)(x)).color = [CNMTreeMap BLACK];
}

- (void)rotateLeftP:(CNTreeMapEntry*)p {
    if(p != nil) {
        CNTreeMapEntry* r = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).right)));
        ((CNTreeMapEntry*)(nonnil(p))).right = r.left;
        if(r.left != nil) ((CNTreeMapEntry*)(nonnil(r.left))).parent = p;
        r.parent = ((CNTreeMapEntry*)(nonnil(p))).parent;
        if(((CNTreeMapEntry*)(nonnil(p))).parent == nil) {
            __root = r;
        } else {
            if([((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).left isEqual:p]) ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).left = r;
            else ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).right = r;
        }
        r.left = p;
        ((CNTreeMapEntry*)(nonnil(p))).parent = r;
    }
}

- (void)rotateRightP:(CNTreeMapEntry*)p {
    if(p != nil) {
        CNTreeMapEntry* l = ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).left)));
        ((CNTreeMapEntry*)(nonnil(p))).left = l.right;
        if(l.right != nil) ((CNTreeMapEntry*)(nonnil(l.right))).parent = p;
        l.parent = ((CNTreeMapEntry*)(nonnil(p))).parent;
        if(((CNTreeMapEntry*)(nonnil(p))).parent == nil) {
            __root = l;
        } else {
            if([((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).right isEqual:p]) ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).right = l;
            else ((CNTreeMapEntry*)(nonnil(((CNTreeMapEntry*)(nonnil(p))).parent))).left = l;
        }
        l.right = p;
        ((CNTreeMapEntry*)(nonnil(p))).parent = l;
    }
}

- (CNTuple*)pollFirst {
    CNTreeMapEntry* entry = ((CNTreeMapEntry*)([self firstEntry]));
    if(entry != nil) {
        [self deleteEntry:entry];
        return tuple(((CNTreeMapEntry*)(entry)).key, ((CNTreeMapEntry*)(entry)).value);
    } else {
        return nil;
    }
}

- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith {
    id __tmp = [self optKey:key];
    if(__tmp != nil) {
        return ((id)(__tmp));
    } else {
        id init = orUpdateWith();
        [self setKey:key value:init];
        return init;
    }
}

- (id)modifyKey:(id)key by:(id(^)(id))by {
    id newObject = by([self optKey:key]);
    if(newObject == nil) [self removeForKey:key];
    else [self setKey:key value:((id)(nonnil(newObject)))];
    return newObject;
}

- (id)takeKey:(id)key {
    id ret = [self optKey:key];
    [self removeForKey:key];
    return ret;
}

- (void)appendItem:(CNTuple*)item {
    [self setKey:((CNTuple*)(item)).b value:((CNTuple*)(item)).a];
}

- (BOOL)removeItem:(CNTuple*)item {
    return [self removeForKey:((CNTuple*)(item)).a] != nil;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    id<CNMIterator> i = [self mutableIterator];
    while([i hasNext]) {
        if(by([i next])) [i remove];
    }
}

- (ODClassType*)type {
    return [CNMTreeMap type];
}

+ (ODClassType*)type {
    return _CNMTreeMap_type;
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


@implementation CNTreeMapEntry
static ODClassType* _CNTreeMapEntry_type;
@synthesize key = _key;
@synthesize value = _value;
@synthesize left = _left;
@synthesize right = _right;
@synthesize color = _color;
@synthesize parent = _parent;

+ (instancetype)treeMapEntry {
    return [[CNTreeMapEntry alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _left = nil;
        _right = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapEntry class]) _CNTreeMapEntry_type = [ODClassType classTypeWithCls:[CNTreeMapEntry class]];
}

+ (CNTreeMapEntry*)applyKey:(id)key value:(id)value parent:(CNTreeMapEntry*)parent {
    CNTreeMapEntry* r = [CNTreeMapEntry treeMapEntry];
    r.key = key;
    r.value = value;
    r.parent = parent;
    return r;
}

- (CNTreeMapEntry*)next {
    if(_right != nil) {
        CNTreeMapEntry* p = ((CNTreeMapEntry*)(nonnil(_right)));
        while(p.left != nil) {
            p = ((CNTreeMapEntry*)(nonnil(p.left)));
        }
        return p;
    } else {
        CNTreeMapEntry* p = _parent;
        CNTreeMapEntry* ch = self;
        while(p != nil && [ch isEqual:((CNTreeMapEntry*)(nonnil(p))).right]) {
            ch = ((CNTreeMapEntry*)(nonnil(p)));
            p = ((CNTreeMapEntry*)(nonnil(p))).parent;
        }
        return p;
    }
}

- (CNTreeMapEntry*)copyParent:(CNTreeMapEntry*)parent {
    CNTreeMapEntry* c = [CNTreeMapEntry treeMapEntry];
    c.key = _key;
    c.value = _value;
    c.left = ({
        CNTreeMapEntry* _ = ((CNTreeMapEntry*)(_left));
        ((_ != nil) ? [((CNTreeMapEntry*)(_)) copyParent:c] : nil);
    });
    c.right = ({
        CNTreeMapEntry* _ = ((CNTreeMapEntry*)(_right));
        ((_ != nil) ? [((CNTreeMapEntry*)(_)) copyParent:c] : nil);
    });
    c.color = _color;
    c.parent = parent;
    return c;
}

- (ODClassType*)type {
    return [CNTreeMapEntry type];
}

+ (ODClassType*)type {
    return _CNTreeMapEntry_type;
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


@implementation CNImTreeMapKeySet
static ODClassType* _CNImTreeMapKeySet_type;
@synthesize map = _map;

+ (instancetype)imTreeMapKeySetWithMap:(CNTreeMap*)map {
    return [[CNImTreeMapKeySet alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImTreeMapKeySet class]) _CNImTreeMapKeySet_type = [ODClassType classTypeWithCls:[CNImTreeMapKeySet class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [CNTreeMapKeyIterator applyMap:_map entry:[_map firstEntry]];
}

- (id<CNIterator>)iteratorHigherThanKey:(id)key {
    return [CNTreeMapKeyIterator applyMap:_map entry:[_map higherEntryThanKey:key]];
}

- (id<CNMIterable>)mCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return arr;
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return nil;
    else return [self head];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
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

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = nil;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = x;
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
    return [CNImTreeMapKeySet type];
}

+ (ODClassType*)type {
    return _CNImTreeMapKeySet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNTreeMapKeyIterator
static ODClassType* _CNTreeMapKeyIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (instancetype)treeMapKeyIteratorWithMap:(CNTreeMap*)map {
    return [[CNTreeMapKeyIterator alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapKeyIterator class]) _CNTreeMapKeyIterator_type = [ODClassType classTypeWithCls:[CNTreeMapKeyIterator class]];
}

+ (CNTreeMapKeyIterator*)applyMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapKeyIterator* ret = [CNTreeMapKeyIterator treeMapKeyIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    id ret = ((CNTreeMapEntry*)(nonnil(_entry))).key;
    _entry = [((CNTreeMapEntry*)(nonnil(_entry))) next];
    return ret;
}

- (ODClassType*)type {
    return [CNTreeMapKeyIterator type];
}

+ (ODClassType*)type {
    return _CNTreeMapKeyIterator_type;
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


@implementation CNMTreeMapKeySet
static ODClassType* _CNMTreeMapKeySet_type;
@synthesize map = _map;

+ (instancetype)treeMapKeySetWithMap:(CNMTreeMap*)map {
    return [[CNMTreeMapKeySet alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNMTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMTreeMapKeySet class]) _CNMTreeMapKeySet_type = [ODClassType classTypeWithCls:[CNMTreeMapKeySet class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [CNTreeMapKeyIterator applyMap:_map entry:[_map firstEntry]];
}

- (id<CNMIterator>)mutableIterator {
    return [CNMTreeMapKeyIterator applyMap:_map entry:[_map firstEntry]];
}

- (id<CNIterator>)iteratorHigherThanKey:(id)key {
    return [CNMTreeMapKeyIterator applyMap:_map entry:[_map higherEntryThanKey:key]];
}

- (id<CNMIterable>)mCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return arr;
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return nil;
    else return [self head];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
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

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = nil;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = x;
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
    return [CNMTreeMapKeySet type];
}

+ (ODClassType*)type {
    return _CNMTreeMapKeySet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNMTreeMapKeyIterator
static ODClassType* _CNMTreeMapKeyIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (instancetype)treeMapKeyIteratorWithMap:(CNMTreeMap*)map {
    return [[CNMTreeMapKeyIterator alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNMTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMTreeMapKeyIterator class]) _CNMTreeMapKeyIterator_type = [ODClassType classTypeWithCls:[CNMTreeMapKeyIterator class]];
}

+ (CNMTreeMapKeyIterator*)applyMap:(CNMTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNMTreeMapKeyIterator* ret = [CNMTreeMapKeyIterator treeMapKeyIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    id ret = ((CNTreeMapEntry*)(nonnil(_entry))).key;
    _prev = _entry;
    _entry = [((CNTreeMapEntry*)(nonnil(_entry))) next];
    return ret;
}

- (void)remove {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)(_prev));
    if(_ != nil) [_map deleteEntry:_];
}

- (void)setValue:(id)value {
    CNTreeMapEntry* p = ((CNTreeMapEntry*)(_prev));
    if(p != nil) {
        if(!([((CNTreeMapEntry*)(p)).key isEqual:value])) {
            [_map deleteEntry:p];
            [_map setKey:value value:((CNTreeMapEntry*)(p)).value];
        }
    }
}

- (ODClassType*)type {
    return [CNMTreeMapKeyIterator type];
}

+ (ODClassType*)type {
    return _CNMTreeMapKeyIterator_type;
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


@implementation CNTreeMapValues
static ODClassType* _CNTreeMapValues_type;
@synthesize map = _map;

+ (instancetype)treeMapValuesWithMap:(CNTreeMap*)map {
    return [[CNTreeMapValues alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapValues class]) _CNTreeMapValues_type = [ODClassType classTypeWithCls:[CNTreeMapValues class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [CNTreeMapValuesIterator applyMap:_map entry:[_map firstEntry]];
}

- (id<CNMIterable>)mCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return arr;
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return nil;
    else return [self head];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
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

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = nil;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = x;
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
    return [CNTreeMapValues type];
}

+ (ODClassType*)type {
    return _CNTreeMapValues_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNTreeMapValuesIterator
static ODClassType* _CNTreeMapValuesIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (instancetype)treeMapValuesIteratorWithMap:(CNTreeMap*)map {
    return [[CNTreeMapValuesIterator alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapValuesIterator class]) _CNTreeMapValuesIterator_type = [ODClassType classTypeWithCls:[CNTreeMapValuesIterator class]];
}

+ (CNTreeMapValuesIterator*)applyMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapValuesIterator* ret = [CNTreeMapValuesIterator treeMapValuesIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    id ret = ((CNTreeMapEntry*)(nonnil(_entry))).value;
    _entry = [((CNTreeMapEntry*)(nonnil(_entry))) next];
    return ret;
}

- (ODClassType*)type {
    return [CNTreeMapValuesIterator type];
}

+ (ODClassType*)type {
    return _CNTreeMapValuesIterator_type;
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


@implementation CNTreeMapIterator
static ODClassType* _CNTreeMapIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (instancetype)treeMapIteratorWithMap:(CNTreeMap*)map {
    return [[CNTreeMapIterator alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNTreeMapIterator class]) _CNTreeMapIterator_type = [ODClassType classTypeWithCls:[CNTreeMapIterator class]];
}

+ (CNTreeMapIterator*)applyMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapIterator* ret = [CNTreeMapIterator treeMapIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (CNTuple*)next {
    CNTuple* ret = tuple(((CNTreeMapEntry*)(nonnil(_entry))).key, ((CNTreeMapEntry*)(nonnil(_entry))).value);
    _entry = [((CNTreeMapEntry*)(nonnil(_entry))) next];
    return ret;
}

- (ODClassType*)type {
    return [CNTreeMapIterator type];
}

+ (ODClassType*)type {
    return _CNTreeMapIterator_type;
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


@implementation CNMTreeMapIterator
static ODClassType* _CNMTreeMapIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (instancetype)treeMapIteratorWithMap:(CNMTreeMap*)map {
    return [[CNMTreeMapIterator alloc] initWithMap:map];
}

- (instancetype)initWithMap:(CNMTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMTreeMapIterator class]) _CNMTreeMapIterator_type = [ODClassType classTypeWithCls:[CNMTreeMapIterator class]];
}

+ (CNMTreeMapIterator*)applyMap:(CNMTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNMTreeMapIterator* ret = [CNMTreeMapIterator treeMapIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (CNTuple*)next {
    CNTuple* ret = tuple(((CNTreeMapEntry*)(nonnil(_entry))).key, ((CNTreeMapEntry*)(nonnil(_entry))).value);
    _prev = _entry;
    _entry = [((CNTreeMapEntry*)(nonnil(_entry))) next];
    return ret;
}

- (void)remove {
    CNTreeMapEntry* _ = ((CNTreeMapEntry*)(_prev));
    if(_ != nil) [_map deleteEntry:_];
}

- (void)setValue:(CNTuple*)value {
    CNTreeMapEntry* p = ((CNTreeMapEntry*)(_prev));
    if(p != nil) {
        if([((CNTreeMapEntry*)(p)).key isEqual:((CNTuple*)(value)).a]) {
            ((CNTreeMapEntry*)(p)).value = value;
        } else {
            [_map deleteEntry:p];
            [_map setKey:((CNTuple*)(value)).a value:((CNTuple*)(value)).b];
        }
    }
}

- (ODClassType*)type {
    return [CNMTreeMapIterator type];
}

+ (ODClassType*)type {
    return _CNMTreeMapIterator_type;
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


