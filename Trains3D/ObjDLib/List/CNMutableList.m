#import "objd.h"
#import "CNMutableList.h"

#import "ODType.h"
#import "CNSet.h"
#import "CNChain.h"
#import "CNDispatchQueue.h"
@implementation CNMutableList{
    NSUInteger __count;
    CNMutableListItem* _headItem;
    CNMutableListItem* _lastItem;
}
static ODClassType* _CNMutableList_type;

+ (instancetype)mutableList {
    return [[CNMutableList alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMutableList class]) _CNMutableList_type = [ODClassType classTypeWithCls:[CNMutableList class]];
}

- (NSUInteger)count {
    return __count;
}

- (id<CNIterator>)iterator {
    CNMutableListImmutableIterator* i = [CNMutableListImmutableIterator mutableListImmutableIterator];
    i.item = _headItem;
    return i;
}

- (id<CNMutableIterator>)mutableIterator {
    CNMutableListIterator* i = [CNMutableListIterator mutableListIteratorWithList:self];
    i.item = _headItem;
    return i;
}

- (void)prependItem:(id)item {
    CNMutableListItem* i = [CNMutableListItem mutableListItem];
    i.data = item;
    if(_headItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i.next = _headItem;
        _headItem.prev = i;
        _headItem = i;
        __count++;
    }
}

- (void)appendItem:(id)item {
    CNMutableListItem* i = [CNMutableListItem mutableListItem];
    i.data = item;
    if(_headItem == nil) {
        _headItem = i;
        _lastItem = i;
        __count = 1;
    } else {
        i.prev = _lastItem;
        _lastItem.next = i;
        _lastItem = i;
        __count++;
    }
}

- (void)removeListItem:(CNMutableListItem*)listItem {
    if(listItem == _headItem) {
        _headItem = _headItem.next;
        if(_headItem == nil) _lastItem = nil;
        else _headItem.prev = nil;
    } else {
        if(listItem == _lastItem) {
            _lastItem = _lastItem.prev;
            _lastItem.next = nil;
        } else {
            listItem.prev.next = listItem.next;
            listItem.next.prev = listItem.prev;
        }
    }
    __count--;
}

- (void)clear {
    _headItem = nil;
    _lastItem = nil;
}

- (void)removeHead {
    [self removeListItem:_headItem];
}

- (void)forEach:(void(^)(id))each {
    CNMutableListItem* i = _headItem;
    while(i != nil) {
        each(i.data);
        i = i.next;
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    CNMutableListItem* i = _headItem;
    while(i != nil) {
        if(!(on(i.data))) return NO;
        i = i.next;
    }
    return YES;
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    CNMutableListItem* i = _headItem;
    while(i != nil) {
        if(!(by(i.data))) [self removeListItem:i];
        i = i.next;
    }
}

- (id)headOpt {
    if(_headItem == nil) return [CNOption none];
    else return [CNOption applyValue:_headItem.data];
}

- (id)head {
    if(_headItem == nil) @throw @"List is empty";
    else return _headItem.data;
}

- (BOOL)removeIndex:(NSUInteger)index {
    id<CNMutableIterator> i = [self mutableIterator];
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
    id<CNMutableIterator> i = [self mutableIterator];
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
    if(index >= [self count]) return [CNOption none];
    else return [CNOption applyValue:[self applyIndex:index]];
}

- (id)randomItem {
    NSUInteger c = [self count];
    if(c == 0) {
        return [CNOption none];
    } else {
        if(c == 1) return [CNOption applyValue:[self head]];
        else return [CNOption applyValue:[self applyIndex:oduIntRndMax([self count] - 1)]];
    }
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[CNHashSetBuilder hashSetBuilder]];
}

- (id<CNSeq>)addItem:(id)item {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendItem:item];
    return [builder build];
}

- (id<CNSeq>)addSeq:(id<CNSeq>)seq {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendAllItems:seq];
    return [builder build];
}

- (id<CNSeq>)subItem:(id)item {
    return [[[self chain] filter:^BOOL(id _) {
        return !([_ isEqual:item]);
    }] toArray];
}

- (BOOL)isEqualToSeq:(id<CNSeq>)seq {
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

- (id<CNSeq>)tail {
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

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
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

- (BOOL)removeItem:(id)item {
    id<CNMutableIterator> i = [self mutableIterator];
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
    return [CNMutableList type];
}

+ (ODClassType*)type {
    return _CNMutableList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation CNMutableListItem{
    id _data;
    CNMutableListItem* _next;
    __weak CNMutableListItem* _prev;
}
static ODClassType* _CNMutableListItem_type;
@synthesize data = _data;
@synthesize next = _next;
@synthesize prev = _prev;

+ (instancetype)mutableListItem {
    return [[CNMutableListItem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMutableListItem class]) _CNMutableListItem_type = [ODClassType classTypeWithCls:[CNMutableListItem class]];
}

- (ODClassType*)type {
    return [CNMutableListItem type];
}

+ (ODClassType*)type {
    return _CNMutableListItem_type;
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


@implementation CNMutableListIterator{
    CNMutableList* _list;
    CNMutableListItem* _prev;
    CNMutableListItem* _item;
}
static ODClassType* _CNMutableListIterator_type;
@synthesize list = _list;
@synthesize item = _item;

+ (instancetype)mutableListIteratorWithList:(CNMutableList*)list {
    return [[CNMutableListIterator alloc] initWithList:list];
}

- (instancetype)initWithList:(CNMutableList*)list {
    self = [super init];
    if(self) _list = list;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMutableListIterator class]) _CNMutableListIterator_type = [ODClassType classTypeWithCls:[CNMutableListIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    _prev = _item;
    _item = _item.next;
    return _prev.data;
}

- (void)remove {
    [_list removeListItem:_prev];
}

- (void)setValue:(id)value {
    _prev.data = value;
}

- (ODClassType*)type {
    return [CNMutableListIterator type];
}

+ (ODClassType*)type {
    return _CNMutableListIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMutableListIterator* o = ((CNMutableListIterator*)(other));
    return self.list == o.list;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.list hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"list=%@", self.list];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNMutableListImmutableIterator{
    __weak CNMutableListItem* _item;
}
static ODClassType* _CNMutableListImmutableIterator_type;
@synthesize item = _item;

+ (instancetype)mutableListImmutableIterator {
    return [[CNMutableListImmutableIterator alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMutableListImmutableIterator class]) _CNMutableListImmutableIterator_type = [ODClassType classTypeWithCls:[CNMutableListImmutableIterator class]];
}

- (BOOL)hasNext {
    return _item != nil;
}

- (id)next {
    CNMutableListItem* r = _item;
    _item = _item.next;
    return r.data;
}

- (ODClassType*)type {
    return [CNMutableListImmutableIterator type];
}

+ (ODClassType*)type {
    return _CNMutableListImmutableIterator_type;
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


