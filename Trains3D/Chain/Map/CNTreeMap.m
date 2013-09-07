#import "objd.h"
#import "CNTreeMap.h"

#import "CNChain.h"
@implementation CNMutableTreeMap{
    NSInteger(^_comparator)(id, id);
    CNTreeMapEntry* _root;
    NSUInteger __size;
    CNTreeMapKeySet* _keys;
    CNTreeMapValues* _values;
}
static NSInteger _CNMutableTreeMap_BLACK = 0;
static NSInteger _CNMutableTreeMap_RED = 1;
static ODClassType* _CNMutableTreeMap_type;
@synthesize comparator = _comparator;
@synthesize keys = _keys;
@synthesize values = _values;

+ (id)mutableTreeMapWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNMutableTreeMap alloc] initWithComparator:comparator];
}

- (id)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super init];
    if(self) {
        _comparator = comparator;
        _root = nil;
        __size = 0;
        _keys = [CNTreeMapKeySet treeMapKeySetWithMap:self];
        _values = [CNTreeMapValues treeMapValuesWithMap:self];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNMutableTreeMap_type = [ODClassType classTypeWithCls:[CNMutableTreeMap class]];
}

+ (CNMutableTreeMap*)new {
    return [CNMutableTreeMap mutableTreeMapWithComparator:^NSInteger(id a, id b) {
        return [a compareTo:b];
    }];
}

- (NSUInteger)count {
    return __size;
}

- (BOOL)isEmpty {
    return _root == nil;
}

- (id)applyKey:(id)key {
    return [CNOption opt:[self entryForKey:key].object];
}

- (void)clear {
    __size = 0;
    _root = nil;
}

- (id<CNIterator>)iterator {
    return [CNTreeMapIterator newMap:self entry:self.firstEntry];
}

- (CNTreeMapIterator*)iteratorHigherThanKey:(id)key {
    return [CNTreeMapIterator newMap:self entry:((CNTreeMapEntry*)([[self higherEntryThanKey:key] getOr:nil]))];
}

- (CNTreeMapEntry*)entryForKey:(id)key {
    CNTreeMapEntry* p = _root;
    while(p != nil) {
        NSInteger cmp = _comparator(key, p.key);
        if(cmp < 0) {
            p = p.left;
        } else {
            if(cmp > 0) p = p.right;
            else break;
        }
    }
    return p;
}

- (void)setObject:(id)object forKey:(id)forKey {
    CNTreeMapEntry* t = _root;
    if(t == nil) {
        _root = [CNTreeMapEntry newWithKey:forKey object:object parent:nil];
        __size = 1;
    } else {
        NSInteger cmp = 0;
        CNTreeMapEntry* parent = nil;
        do {
            parent = t;
            cmp = _comparator(forKey, t.key);
            if(cmp < 0) {
                t = t.left;
            } else {
                if(cmp > 0) {
                    t = t.right;
                } else {
                    t.object = object;
                    return ;
                }
            }
        } while(t != nil);
        CNTreeMapEntry* e = [CNTreeMapEntry newWithKey:forKey object:object parent:parent];
        if(cmp < 0) parent.left = e;
        else parent.right = e;
        [self fixAfterInsertionEntry:e];
        __size++;
    }
}

- (id)removeForKey:(id)key {
    CNTreeMapEntry* entry = [self entryForKey:key];
    if(entry != nil) return [CNOption opt:[self deleteEntry:entry]];
    else return [CNOption none];
}

- (id)deleteEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* p = entry;
    __size--;
    if(p.left != nil && p.right != nil) {
        CNTreeMapEntry* s = [p next];
        p.key = s.key;
        p.object = s.object;
        p = s;
    }
    CNTreeMapEntry* replacement = ((p.left != nil) ? p.left : p.right);
    if(replacement != nil) {
        replacement.parent = p.parent;
        if(p.parent == nil) {
            _root = replacement;
        } else {
            if(p == p.parent.left) p.parent.left = replacement;
            else p.parent.right = replacement;
        }
        p.left = nil;
        p.right = nil;
        p.parent = nil;
        if(p.color == _CNMutableTreeMap_BLACK) [self fixAfterDeletionEntry:replacement];
    } else {
        if(p.parent == nil) {
            _root = nil;
        } else {
            if(p.color == _CNMutableTreeMap_BLACK) [self fixAfterDeletionEntry:p];
            if(p.parent != nil) {
                if(p == p.parent.left) {
                    p.parent.left = nil;
                } else {
                    if(p == p.parent.right) p.parent.right = nil;
                }
                p.parent = nil;
            }
        }
    }
    return entry.object;
}

- (void)fixAfterInsertionEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* x = entry;
    x.color = _CNMutableTreeMap_RED;
    while(x != nil && x != _root && x.parent.color == _CNMutableTreeMap_RED) {
        if(x.parent == x.parent.parent.left) {
            CNTreeMapEntry* y = x.parent.parent.right;
            if(y.color == _CNMutableTreeMap_RED) {
                x.parent.color = _CNMutableTreeMap_BLACK;
                y.color = _CNMutableTreeMap_BLACK;
                x.parent.parent.color = _CNMutableTreeMap_RED;
                x = x.parent.parent;
            } else {
                if(x == x.parent.right) {
                    x = x.parent;
                    [self rotateLeftP:x];
                }
                x.parent.color = _CNMutableTreeMap_BLACK;
                x.parent.parent.color = _CNMutableTreeMap_RED;
                [self rotateRightP:x.parent.parent];
            }
        } else {
            CNTreeMapEntry* y = x.parent.parent.left;
            if(y.color == _CNMutableTreeMap_RED) {
                x.parent.color = _CNMutableTreeMap_BLACK;
                y.color = _CNMutableTreeMap_BLACK;
                x.parent.parent.color = _CNMutableTreeMap_RED;
                x = x.parent.parent;
            } else {
                if(x == x.parent.left) {
                    x = x.parent;
                    [self rotateRightP:x];
                }
                x.parent.color = _CNMutableTreeMap_BLACK;
                x.parent.parent.color = _CNMutableTreeMap_RED;
                [self rotateLeftP:x.parent.parent];
            }
        }
    }
    _root.color = _CNMutableTreeMap_BLACK;
}

- (void)fixAfterDeletionEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* x = entry;
    while(x != _root && x.color == _CNMutableTreeMap_BLACK) {
        if(x == x.parent.left) {
            CNTreeMapEntry* sib = x.parent.right;
            if(sib.color == _CNMutableTreeMap_RED) {
                sib.color = _CNMutableTreeMap_BLACK;
                x.parent.color = _CNMutableTreeMap_RED;
                [self rotateLeftP:x.parent];
                sib = x.parent.right;
            }
            if(sib.left.color == _CNMutableTreeMap_BLACK && sib.right.color == _CNMutableTreeMap_BLACK) {
                sib.color = _CNMutableTreeMap_RED;
                x = x.parent;
            } else {
                if(sib.right.color == _CNMutableTreeMap_BLACK) {
                    sib.left.color = _CNMutableTreeMap_BLACK;
                    sib.color = _CNMutableTreeMap_RED;
                    [self rotateRightP:sib];
                    sib = x.parent.right;
                }
                sib.color = x.parent.color;
                x.parent.color = _CNMutableTreeMap_BLACK;
                sib.right.color = _CNMutableTreeMap_BLACK;
                [self rotateLeftP:x.parent];
                x = _root;
            }
        } else {
            CNTreeMapEntry* sib = x.parent.left;
            if(sib.color == _CNMutableTreeMap_RED) {
                sib.color = _CNMutableTreeMap_BLACK;
                x.parent.color = _CNMutableTreeMap_RED;
                [self rotateRightP:x.parent];
                sib = x.parent.left;
            }
            if(sib.right.color == _CNMutableTreeMap_BLACK && sib.left.color == _CNMutableTreeMap_BLACK) {
                sib.color = _CNMutableTreeMap_RED;
                x = x.parent;
            } else {
                if(sib.left.color == _CNMutableTreeMap_BLACK) {
                    sib.right.color = _CNMutableTreeMap_BLACK;
                    sib.color = _CNMutableTreeMap_RED;
                    [self rotateLeftP:sib];
                    sib = x.parent.left;
                }
                sib.color = x.parent.color;
                x.parent.color = _CNMutableTreeMap_BLACK;
                sib.left.color = _CNMutableTreeMap_BLACK;
                [self rotateRightP:x.parent];
                x = _root;
            }
        }
    }
    x.color = _CNMutableTreeMap_BLACK;
}

- (void)rotateLeftP:(CNTreeMapEntry*)p {
    if(p != nil) {
        CNTreeMapEntry* r = p.right;
        p.right = r.left;
        if(r.left != nil) r.left.parent = p;
        r.parent = p.parent;
        if(p.parent == nil) {
            _root = r;
        } else {
            if(p.parent.left == p) p.parent.left = r;
            else p.parent.right = r;
        }
        r.left = p;
        p.parent = r;
    }
}

- (void)rotateRightP:(CNTreeMapEntry*)p {
    if(p != nil) {
        CNTreeMapEntry* l = p.left;
        p.left = l.right;
        if(l.right != nil) l.right.parent = p;
        l.parent = p.parent;
        if(p.parent == nil) {
            _root = l;
        } else {
            if(p.parent.right == p) p.parent.right = l;
            else p.parent.left = l;
        }
        l.right = p;
        p.parent = l;
    }
}

- (CNTreeMapEntry*)firstEntry {
    CNTreeMapEntry* p = _root;
    if(p != nil) while(p.left != nil) {
        p = p.left;
    }
    return p;
}

- (CNTreeMapEntry*)lastEntry {
    CNTreeMapEntry* p = _root;
    if(p != nil) while(p.right != nil) {
        p = p.right;
    }
    return p;
}

- (id)pollFirst {
    CNTreeMapEntry* entry = self.firstEntry;
    if(entry == nil) {
        return [CNOption none];
    } else {
        [self deleteEntry:entry];
        return [CNOption opt:tuple(entry.key, entry.object)];
    }
}

- (id)firstKey {
    if(_root == nil) return [CNOption none];
    else return [CNOption opt:self.firstEntry.key];
}

- (id)lastKey {
    if(_root == nil) return [CNOption none];
    else return [CNOption opt:self.lastEntry.key];
}

- (id)lowerKeyThanKey:(id)key {
    return [[self lowerEntryThanKey:key] map:^id(CNTreeMapEntry* _) {
        return _.key;
    }];
}

- (id)higherKeyThanKey:(id)key {
    return [[self higherEntryThanKey:key] map:^id(CNTreeMapEntry* _) {
        return _.key;
    }];
}

- (id)lowerEntryThanKey:(id)key {
    CNTreeMapEntry* p = _root;
    while(p != nil) {
        NSInteger cmp = _comparator(key, p.key);
        if(cmp > 0) {
            if(p.right != nil) p = p.right;
            else return p;
        } else {
            if(p.left != nil) {
                p = p.left;
            } else {
                CNTreeMapEntry* parent = p.parent;
                CNTreeMapEntry* ch = p;
                while(parent != nil && ch == parent.left) {
                    ch = parent;
                    parent = parent.parent;
                }
                return parent;
            }
        }
    }
    return [CNOption none];
}

- (id)higherEntryThanKey:(id)key {
    CNTreeMapEntry* p = _root;
    while(p != nil) {
        NSInteger cmp = _comparator(key, p.key);
        if(cmp < 0) {
            if(p.left != nil) p = p.left;
            else return p;
        } else {
            if(p.right != nil) {
                p = p.right;
            } else {
                CNTreeMapEntry* parent = p.parent;
                CNTreeMapEntry* ch = p;
                while(parent != nil && ch == parent.right) {
                    ch = parent;
                    parent = parent.parent;
                }
                return parent;
            }
        }
    }
    return [CNOption none];
}

- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith {
    id o = [self applyKey:key];
    if([o isDefined]) {
        return [o get];
    } else {
        id init = orUpdateWith();
        [self setObject:init forKey:key];
        return init;
    }
}

- (id)modifyBy:(id(^)(id))by forKey:(id)forKey {
    id newObject = by([self applyKey:forKey]);
    if([newObject isEmpty]) [self removeForKey:forKey];
    else [self setObject:newObject forKey:forKey];
    return newObject;
}

- (void)addObject:(CNTuple*)object {
    [self setObject:object.a forKey:object.b];
}

- (void)removeObject:(CNTuple*)object {
    [self removeForKey:object.a];
}

- (BOOL)containsKey:(id)key {
    return [[self applyKey:key] isDefined];
}

- (id)head {
    if([self.iterator hasNext]) return [CNOption opt:[self.iterator next]];
    else return [CNOption none];
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        each([i next]);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsObject:(id)object {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (NSString*)description {
    return [self.chain toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = self.iterator;
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
    return [CNMutableTreeMap type];
}

+ (NSInteger)BLACK {
    return _CNMutableTreeMap_BLACK;
}

+ (NSInteger)RED {
    return _CNMutableTreeMap_RED;
}

+ (ODClassType*)type {
    return _CNMutableTreeMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMutableTreeMap* o = ((CNMutableTreeMap*)(other));
    return [self.comparator isEqual:o.comparator];
}

@end


@implementation CNTreeMapEntry{
    id _key;
    id _object;
    CNTreeMapEntry* _left;
    CNTreeMapEntry* _right;
    NSInteger _color;
    __weak CNTreeMapEntry* _parent;
}
static ODClassType* _CNTreeMapEntry_type;
@synthesize key = _key;
@synthesize object = _object;
@synthesize left = _left;
@synthesize right = _right;
@synthesize color = _color;
@synthesize parent = _parent;

+ (id)treeMapEntry {
    return [[CNTreeMapEntry alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _left = nil;
        _right = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapEntry_type = [ODClassType classTypeWithCls:[CNTreeMapEntry class]];
}

+ (CNTreeMapEntry*)newWithKey:(id)key object:(id)object parent:(CNTreeMapEntry*)parent {
    CNTreeMapEntry* r = [CNTreeMapEntry treeMapEntry];
    r.key = key;
    r.object = object;
    r.parent = parent;
    return r;
}

- (CNTreeMapEntry*)next {
    if(_right != nil) {
        CNTreeMapEntry* p = _right;
        while(p.left != nil) {
            p = p.left;
        }
        return p;
    } else {
        CNTreeMapEntry* p = _parent;
        CNTreeMapEntry* ch = self;
        while(p != nil && ch == p.right) {
            ch = p;
            p = p.parent;
        }
        return p;
    }
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


@implementation CNTreeMapKeySet{
    CNMutableTreeMap* _map;
}
static ODClassType* _CNTreeMapKeySet_type;
@synthesize map = _map;

+ (id)treeMapKeySetWithMap:(CNMutableTreeMap*)map {
    return [[CNTreeMapKeySet alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapKeySet_type = [ODClassType classTypeWithCls:[CNTreeMapKeySet class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [CNTreeMapKeyIterator newMap:_map entry:[_map firstEntry]];
}

- (id<CNIterator>)iteratorHigherThanKey:(id)key {
    return [CNTreeMapKeyIterator newMap:_map entry:((CNTreeMapEntry*)([[_map higherEntryThanKey:key] getOr:nil]))];
}

- (id)head {
    if([self.iterator hasNext]) return [CNOption opt:[self.iterator next]];
    else return [CNOption none];
}

- (BOOL)isEmpty {
    return !([self.iterator hasNext]);
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        each([i next]);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsObject:(id)object {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (NSString*)description {
    return [self.chain toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = self.iterator;
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
    return [CNTreeMapKeySet type];
}

+ (ODClassType*)type {
    return _CNTreeMapKeySet_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapKeySet* o = ((CNTreeMapKeySet*)(other));
    return [self.map isEqual:o.map];
}

@end


@implementation CNTreeMapKeyIterator{
    CNMutableTreeMap* _map;
    CNTreeMapEntry* _entry;
}
static ODClassType* _CNTreeMapKeyIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (id)treeMapKeyIteratorWithMap:(CNMutableTreeMap*)map {
    return [[CNTreeMapKeyIterator alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapKeyIterator_type = [ODClassType classTypeWithCls:[CNTreeMapKeyIterator class]];
}

+ (CNTreeMapKeyIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapKeyIterator* ret = [CNTreeMapKeyIterator treeMapKeyIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    id ret = _entry.key;
    _entry = [_entry next];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapKeyIterator* o = ((CNTreeMapKeyIterator*)(other));
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


@implementation CNTreeMapValues{
    CNMutableTreeMap* _map;
}
static ODClassType* _CNTreeMapValues_type;
@synthesize map = _map;

+ (id)treeMapValuesWithMap:(CNMutableTreeMap*)map {
    return [[CNTreeMapValues alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapValues_type = [ODClassType classTypeWithCls:[CNTreeMapValues class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [CNTreeMapValuesIterator newMap:_map entry:[_map firstEntry]];
}

- (id)head {
    if([self.iterator hasNext]) return [CNOption opt:[self.iterator next]];
    else return [CNOption none];
}

- (BOOL)isEmpty {
    return !([self.iterator hasNext]);
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        each([i next]);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsObject:(id)object {
    id<CNIterator> i = self.iterator;
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (NSString*)description {
    return [self.chain toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = self.iterator;
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
    return [CNTreeMapValues type];
}

+ (ODClassType*)type {
    return _CNTreeMapValues_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapValues* o = ((CNTreeMapValues*)(other));
    return [self.map isEqual:o.map];
}

@end


@implementation CNTreeMapValuesIterator{
    CNMutableTreeMap* _map;
    CNTreeMapEntry* _entry;
}
static ODClassType* _CNTreeMapValuesIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (id)treeMapValuesIteratorWithMap:(CNMutableTreeMap*)map {
    return [[CNTreeMapValuesIterator alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapValuesIterator_type = [ODClassType classTypeWithCls:[CNTreeMapValuesIterator class]];
}

+ (CNTreeMapValuesIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapValuesIterator* ret = [CNTreeMapValuesIterator treeMapValuesIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    id ret = _entry.object;
    _entry = [_entry next];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapValuesIterator* o = ((CNTreeMapValuesIterator*)(other));
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


@implementation CNTreeMapIterator{
    CNMutableTreeMap* _map;
    CNTreeMapEntry* _entry;
}
static ODClassType* _CNTreeMapIterator_type;
@synthesize map = _map;
@synthesize entry = _entry;

+ (id)treeMapIteratorWithMap:(CNMutableTreeMap*)map {
    return [[CNTreeMapIterator alloc] initWithMap:map];
}

- (id)initWithMap:(CNMutableTreeMap*)map {
    self = [super init];
    if(self) _map = map;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNTreeMapIterator_type = [ODClassType classTypeWithCls:[CNTreeMapIterator class]];
}

+ (CNTreeMapIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry {
    CNTreeMapIterator* ret = [CNTreeMapIterator treeMapIteratorWithMap:map];
    ret.entry = entry;
    return ret;
}

- (BOOL)hasNext {
    return _entry != nil;
}

- (id)next {
    CNTuple* ret = tuple(_entry.key, _entry.object);
    _entry = [_entry next];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTreeMapIterator* o = ((CNTreeMapIterator*)(other));
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


