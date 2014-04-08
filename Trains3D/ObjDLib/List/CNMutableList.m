#import "objd.h"
#import "CNMutableList.h"

#import "ODType.h"
#import "CNSet.h"
#import "CNDispatchQueue.h"
#import "CNChain.h"
@implementation CNMList
static ODClassType* _CNMList_type;

+ (instancetype)list {
    return [[CNMList alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMList class]) _CNMList_type = [ODClassType classTypeWithCls:[CNMList class]];
}

- (NSUInteger)count {
    return __count;
}

- (id<CNIterator>)iterator {
    CNMListImmutableIterator* i = [CNMListImmutableIterator listImmutableIterator];
    i.item = _headItem;
    return i;
}

- (id<CNMIterator>)mutableIterator {
    CNMListIterator* i = [CNMListIterator listIteratorWithList:self];
    i.item = _headItem;
    return i;
}

- (void)insertIndex:(NSUInteger)index item:(id)item {
    if(index == 0) {
        [self prependItem:item];
    } else {
        if(index >= __count) {
            [self appendItem:item];
        } else {
            CNMListItem* c = _headItem;
            NSUInteger i = index;
            while(c != nil && i > 0) {
                c = ((CNMListItem*)(c)).next;
            }
            if(c != nil) {
                CNMListItem* li = [CNMListItem listItem];
                li.data = item;
                {
                    CNMListItem* __tmp_0_3_2 = ((CNMListItem*)(c)).next;
                    if(__tmp_0_3_2 != nil) ((CNMListItem*)(__tmp_0_3_2)).prev = li;
                }
                ((CNMListItem*)(c)).next = li;
            } else {
                [self appendItem:item];
            }
        }
    }
}

- (void)prependItem:(id)item {
    CNMListItem* i = [CNMListItem listItem];
    i.data = item;
    if(_headItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i.next = ((CNMListItem*)(_headItem));
        ((CNMListItem*)(_headItem)).prev = i;
        _headItem = i;
        __count++;
    }
}

- (void)appendItem:(id)item {
    CNMListItem* i = [CNMListItem listItem];
    i.data = item;
    if(_lastItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i.prev = ((CNMListItem*)(_lastItem));
        ((CNMListItem*)(_lastItem)).next = i;
        _lastItem = i;
        __count++;
    }
}

- (void)removeListItem:(CNMListItem*)listItem {
    if([listItem isEqual:_headItem]) {
        _headItem = ((CNMListItem*)(nonnil(_headItem))).next;
        if(_headItem == nil) _lastItem = nil;
        else ((CNMListItem*)(_headItem)).prev = nil;
    } else {
        if([listItem isEqual:_lastItem]) {
            _lastItem = ((CNMListItem*)(nonnil(_lastItem))).prev;
            ((CNMListItem*)(nonnil(_lastItem))).next = nil;
        } else {
            {
                CNMListItem* __tmp_0_0 = listItem.prev;
                if(__tmp_0_0 != nil) ((CNMListItem*)(__tmp_0_0)).next = listItem.next;
            }
            {
                CNMListItem* __tmp_0_1 = listItem.next;
                if(__tmp_0_1 != nil) ((CNMListItem*)(__tmp_0_1)).prev = listItem.prev;
            }
        }
    }
    __count--;
}

- (void)clear {
    _headItem = nil;
    _lastItem = nil;
}

- (void)removeHead {
    CNMListItem* _ = ((CNMListItem*)(_headItem));
    if(_ != nil) [self removeListItem:_];
}

- (void)removeLast {
    CNMListItem* _ = ((CNMListItem*)(_lastItem));
    if(_ != nil) [self removeListItem:_];
}

- (id)takeHead {
    CNMListItem* h = ((CNMListItem*)(_headItem));
    if(h != nil) {
        id r = ((CNMListItem*)(h)).data;
        [self removeListItem:h];
        return r;
    } else {
        return nil;
    }
}

- (id)takeLast {
    CNMListItem* h = ((CNMListItem*)(_lastItem));
    if(h != nil) {
        id r = ((CNMListItem*)(h)).data;
        [self removeListItem:h];
        return r;
    } else {
        return nil;
    }
}

- (void)forEach:(void(^)(id))each {
    CNMListItem* i = _headItem;
    while(i != nil) {
        each(((CNMListItem*)(i)).data);
        i = ((CNMListItem*)(i)).next;
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    CNMListItem* i = _headItem;
    while(i != nil) {
        if(!(on(((CNMListItem*)(i)).data))) return NO;
        i = ((CNMListItem*)(i)).next;
    }
    return YES;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    CNMListItem* i = _headItem;
    while(i != nil) {
        if(!(by(((CNMListItem*)(i)).data))) [self removeListItem:i];
        i = ((CNMListItem*)(i)).next;
    }
}

- (id)headOpt {
    return ((CNMListItem*)(_headItem)).data;
}

- (id)head {
    if(_headItem == nil) @throw @"List is empty";
    else return ((CNMListItem*)(_headItem)).data;
}

- (BOOL)removeIndex:(NSUInteger)index {
    id<CNMIterator> i = [self mutableIterator];
    NSUInteger j = index;
    BOOL ret = NO;
    while([i hasNext]) {
        [i next];
        if(j == 0) {
            [i remove];
            ret = YES;
            break;
        }
        j--;
    }
    return ret;
}

- (void)setIndex:(NSUInteger)index item:(id)item {
    id<CNMIterator> i = [self mutableIterator];
    NSUInteger n = index;
    while([i hasNext]) {
        if(n == 0) {
            [i next];
            [i setValue:item];
            return ;
        }
        [i next];
        n--;
    }
    @throw @"Incorrect index";
}

- (id<CNImSeq>)im {
    return [self imCopy];
}

- (id<CNImSeq>)imCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return arr;
}

- (id)applyIndex:(NSUInteger)index {
    id<CNIterator> i = [self iterator];
    NSUInteger n = index;
    while([i hasNext]) {
        if(n == 0) return [i next];
        [i next];
        n--;
    }
    @throw @"Incorrect index";
}

- (id)optIndex:(NSUInteger)index {
    if(index >= [self count]) return nil;
    else return [self applyIndex:index];
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[CNHashSetBuilder hashSetBuilder]];
}

- (BOOL)isEqualSeq:(id<CNSeq>)seq {
    if([self count] != [seq count]) return NO;
    id<CNIterator> ia = [self iterator];
    id<CNIterator> ib = [seq iterator];
    while([ia hasNext] && [ib hasNext]) {
        if(!([[ia next] isEqual:[ib next]])) return NO;
    }
    return YES;
}

- (BOOL)isEmpty {
    return [self count] == 0;
}

- (id<CNImSeq>)tail {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    id<CNIterator> i = [self iterator];
    if([i hasNext]) {
        [i next];
        while([i hasNext]) {
            [builder appendItem:[i next]];
        }
    }
    return [builder build];
}

- (id)last {
    return [self applyIndex:[self count] - 1];
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

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
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

- (BOOL)removeItem:(id)item {
    id<CNMIterator> i = [self mutableIterator];
    BOOL ret = NO;
    while([i hasNext]) {
        if([[i next] isEqual:item]) {
            [i remove];
            ret = YES;
        }
    }
    return ret;
}

- (ODClassType*)type {
    return [CNMList type];
}

+ (ODClassType*)type {
    return _CNMList_type;
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


@implementation CNMListItem
static ODClassType* _CNMListItem_type;
@synthesize data = _data;
@synthesize next = _next;
@synthesize prev = _prev;

+ (instancetype)listItem {
    return [[CNMListItem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListItem class]) _CNMListItem_type = [ODClassType classTypeWithCls:[CNMListItem class]];
}

- (ODClassType*)type {
    return [CNMListItem type];
}

+ (ODClassType*)type {
    return _CNMListItem_type;
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


@implementation CNMListIterator
static ODClassType* _CNMListIterator_type;
@synthesize list = _list;
@synthesize item = _item;

+ (instancetype)listIteratorWithList:(CNMList*)list {
    return [[CNMListIterator alloc] initWithList:list];
}

- (instancetype)initWithList:(CNMList*)list {
    self = [super init];
    if(self) _list = list;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListIterator class]) _CNMListIterator_type = [ODClassType classTypeWithCls:[CNMListIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    _prev = _item;
    _item = ((CNMListItem*)(nonnil(_item))).next;
    return ((CNMListItem*)(nonnil(_prev))).data;
}

- (void)remove {
    [_list removeListItem:((CNMListItem*)(nonnil(_prev)))];
}

- (void)setValue:(id)value {
    ((CNMListItem*)(nonnil(_prev))).data = value;
}

- (ODClassType*)type {
    return [CNMListIterator type];
}

+ (ODClassType*)type {
    return _CNMListIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"list=%@", self.list];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNMListImmutableIterator
static ODClassType* _CNMListImmutableIterator_type;
@synthesize item = _item;

+ (instancetype)listImmutableIterator {
    return [[CNMListImmutableIterator alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMListImmutableIterator class]) _CNMListImmutableIterator_type = [ODClassType classTypeWithCls:[CNMListImmutableIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    CNMListItem* r = _item;
    _item = ((CNMListItem*)(nonnil(_item))).next;
    return ((CNMListItem*)(nonnil(r))).data;
}

- (ODClassType*)type {
    return [CNMListImmutableIterator type];
}

+ (ODClassType*)type {
    return _CNMListImmutableIterator_type;
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


