#import "CNTreeMap.h"

@implementation CNTreeMap{
    NSInteger(^_comparator)(id, id);
    CNTreeMapEntry* _root;
    NSUInteger __size;
}
static NSInteger _BLACK;
static NSInteger _RED;
@synthesize comparator = _comparator;

+ (id)treeMapWithComparator:(NSInteger(^)(id, id))comparator {
    return [[CNTreeMap alloc] initWithComparator:comparator];
}

- (id)initWithComparator:(NSInteger(^)(id, id))comparator {
    self = [super init];
    if(self) {
        _comparator = comparator;
        _root = nil;
        __size = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _BLACK = 0;
    _RED = 1;
}

- (NSUInteger)count {
    return __size;
}

- (id)objectForKey:(id)key {
    return [CNOption opt:[self entryForKey:key].object];
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

- (id)setObject:(id)object forKey:(id)forKey {
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
                    return object;
                }
            }
        } while(t != nil);
        CNTreeMapEntry* e = [CNTreeMapEntry newWithKey:forKey object:object parent:parent];
        if(cmp < 0) parent.left = e;
        else parent.right = e;
        [self fixAfterInsertionEntry:e];
        __size++;
    }
    return object;
}

- (id)removeObjectForKey:(id)key {
    CNTreeMapEntry* entry = [self entryForKey:key];
    if(entry != nil) return [CNOption opt:[self deleteEntry:entry]];
    else return [CNOption none];
}

- (id)deleteEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* p = entry;
    __size--;
    if(p.left != nil && p.right != nil) {
        CNTreeMapEntry* s = [self successorT:p];
        p.key = s.key;
        p.object = s.object;
        p = s;
    }
    CNTreeMapEntry* replacement = p.left != nil ? p.left : p.right;
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
        if(p.color == _BLACK) [self fixAfterDeletionEntry:replacement];
    } else {
        if(p.parent == nil) {
            _root = nil;
        } else {
            if(p.color == _BLACK) [self fixAfterDeletionEntry:p];
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

- (CNTreeMapEntry*)successorT:(CNTreeMapEntry*)t {
    if(t == nil) {
        return nil;
    } else {
        if(t.right != nil) {
            CNTreeMapEntry* p = t.right;
            while(p.left != nil) {
                p = p.left;
            }
            return p;
        } else {
            CNTreeMapEntry* p = t.parent;
            CNTreeMapEntry* ch = t;
            while(p != nil && ch == p.right) {
                ch = p;
                p = p.parent;
            }
            return p;
        }
    }
}

- (void)fixAfterInsertionEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* x = entry;
    x.color = _RED;
    while(x != nil && x != _root && x.parent.color == _RED) {
        if(x.parent == x.parent.parent.left) {
            CNTreeMapEntry* y = x.parent.parent.right;
            if(y.color == _RED) {
                x.parent.color = _BLACK;
                y.color = _BLACK;
                x.parent.parent.color = _RED;
                x = x.parent.parent;
            } else {
                if(x == x.parent.right) {
                    x = x.parent;
                    [self rotateLeftP:x];
                }
                x.parent.color = _BLACK;
                x.parent.parent.color = _RED;
                [self rotateRightP:x.parent.parent];
            }
        } else {
            CNTreeMapEntry* y = x.parent.parent.left;
            if(y.color == _RED) {
                x.parent.color = _BLACK;
                y.color = _BLACK;
                x.parent.parent.color = _RED;
                x = x.parent.parent;
            } else {
                if(x == x.parent.left) {
                    x = x.parent;
                    [self rotateRightP:x];
                }
                x.parent.color = _BLACK;
                x.parent.parent.color = _RED;
                [self rotateLeftP:x.parent.parent];
            }
        }
    }
    _root.color = _BLACK;
}

- (void)fixAfterDeletionEntry:(CNTreeMapEntry*)entry {
    CNTreeMapEntry* x = entry;
    while(x != _root && x.color == _BLACK) {
        if(x == x.parent.left) {
            CNTreeMapEntry* sib = x.parent.right;
            if(sib.color == _RED) {
                sib.color = _BLACK;
                x.parent.color = _RED;
                [self rotateLeftP:x.parent];
                sib = x.parent.right;
            }
            if(sib.left.color == _BLACK && sib.right.color == _BLACK) {
                sib.color = _RED;
                x = x.parent;
            } else {
                if(sib.right.color == _BLACK) {
                    sib.left.color = _BLACK;
                    sib.color = _RED;
                    [self rotateRightP:sib];
                    sib = x.parent.right;
                }
                sib.color = x.parent.color;
                x.parent.color = _BLACK;
                sib.right.color = _BLACK;
                [self rotateLeftP:x.parent];
                x = _root;
            }
        } else {
            CNTreeMapEntry* sib = x.parent.left;
            if(sib.color == _RED) {
                sib.color = _BLACK;
                x.parent.color = _RED;
                [self rotateRightP:x.parent];
                sib = x.parent.left;
            }
            if(sib.right.color == _BLACK && sib.left.color == _BLACK) {
                sib.color = _RED;
                x = x.parent;
            } else {
                if(sib.left.color == _BLACK) {
                    sib.right.color = _BLACK;
                    sib.color = _RED;
                    [self rotateLeftP:sib];
                    sib = x.parent.left;
                }
                sib.color = x.parent.color;
                x.parent.color = _BLACK;
                sib.left.color = _BLACK;
                [self rotateRightP:x.parent];
                x = _root;
            }
        }
    }
    x.color = _BLACK;
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

+ (NSInteger)BLACK {
    return _BLACK;
}

+ (NSInteger)RED {
    return _RED;
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


@implementation CNTreeMapEntry{
    id _key;
    id _object;
    CNTreeMapEntry* _left;
    CNTreeMapEntry* _right;
    NSInteger _color;
    __weak CNTreeMapEntry* _parent;
}
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

+ (CNTreeMapEntry*)newWithKey:(id)key object:(id)object parent:(CNTreeMapEntry*)parent {
    CNTreeMapEntry* r = [CNTreeMapEntry treeMapEntry];
    r.key = key;
    r.object = object;
    r.parent = parent;
    return r;
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


