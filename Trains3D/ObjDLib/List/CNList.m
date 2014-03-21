#import "objd.h"
#import "CNList.h"

#import "ODType.h"
#import "CNChain.h"
#import "CNSet.h"
#import "CNDispatchQueue.h"
@implementation CNImList
static ODClassType* _CNImList_type;

+ (instancetype)imList {
    return [[CNImList alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImList class]) _CNImList_type = [ODClassType classTypeWithCls:[CNImList class]];
}

+ (CNImList*)apply {
    return ((CNImList*)(CNEmptyList.instance));
}

+ (CNImList*)applyItem:(id)item {
    return [CNFilledList filledListWithHead:item tail:CNEmptyList.instance];
}

+ (CNImList*)applyItem:(id)item tail:(CNImList*)tail {
    return [CNFilledList filledListWithHead:item tail:tail];
}

- (id<CNIterator>)iterator {
    CNListIterator* i = [CNListIterator listIterator];
    i.list = self;
    return i;
}

- (CNImList*)tail {
    @throw @"Method tail is abstract";
}

- (CNImList*)filterF:(BOOL(^)(id))f {
    @throw @"Method filter is abstract";
}

- (CNImList*)reverse {
    @throw @"Method reverse is abstract";
}

- (id<CNImSeq>)addItem:(id)item {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendItem:item];
    return [builder build];
}

- (id<CNImSeq>)addSeq:(id<CNSeq>)seq {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder appendAllItems:self];
    [builder appendAllItems:seq];
    return [builder build];
}

- (id<CNImSeq>)subItem:(id)item {
    return [[[self chain] filter:^BOOL(id _) {
        return !([_ isEqual:item]);
    }] toArray];
}

- (id<CNMSeq>)mCopy {
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

- (BOOL)_isEqualSeq:(id<CNSeq>)seq {
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

- (id)head {
    return [self applyIndex:0];
}

- (id)headOpt {
    return [self optIndex:0];
}

- (id)last {
    return [self applyIndex:[self count] - 1];
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

- (ODClassType*)type {
    return [CNImList type];
}

+ (ODClassType*)type {
    return _CNImList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other)) return NO;
    if([other conformsToProtocol:@protocol(CNSeq)]) return [self _isEqualSeq:((id<CNSeq>)(other))];
    return NO;
}

@end


@implementation CNFilledList
static ODClassType* _CNFilledList_type;
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize count = _count;

+ (instancetype)filledListWithHead:(id)head tail:(CNImList*)tail {
    return [[CNFilledList alloc] initWithHead:head tail:tail];
}

- (instancetype)initWithHead:(id)head tail:(CNImList*)tail {
    self = [super init];
    if(self) {
        _head = head;
        _tail = tail;
        _count = [_tail count] + 1;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNFilledList class]) _CNFilledList_type = [ODClassType classTypeWithCls:[CNFilledList class]];
}

- (id)headOpt {
    return [CNOption applyValue:_head];
}

- (BOOL)isEmpty {
    return NO;
}

- (CNImList*)filterF:(BOOL(^)(id))f {
    if(f(_head)) return [CNFilledList filledListWithHead:_head tail:[_tail filterF:f]];
    else return [_tail filterF:f];
}

- (CNImList*)reverse {
    CNFilledList* ret = [CNFilledList filledListWithHead:_head tail:CNEmptyList.instance];
    CNImList* list = _tail;
    while(!([list isEmpty])) {
        ret = [CNFilledList filledListWithHead:((CNFilledList*)(list)).head tail:ret];
        list = [list tail];
    }
    return ret;
}

- (void)forEach:(void(^)(id))each {
    CNFilledList* list = self;
    while(YES) {
        each(list.head);
        CNImList* tail = list.tail;
        if([tail isEmpty]) return ;
        list = ((CNFilledList*)(tail));
    }
}

- (ODClassType*)type {
    return [CNFilledList type];
}

+ (ODClassType*)type {
    return _CNFilledList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNFilledList* o = ((CNFilledList*)(other));
    return [self.head isEqual:o.head] && [self.tail isEqual:o.tail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.head hash];
    hash = hash * 31 + [self.tail hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"head=%@", self.head];
    [description appendFormat:@", tail=%@", self.tail];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNEmptyList
static CNEmptyList* _CNEmptyList_instance;
static ODClassType* _CNEmptyList_type;

+ (instancetype)emptyList {
    return [[CNEmptyList alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNEmptyList class]) {
        _CNEmptyList_type = [ODClassType classTypeWithCls:[CNEmptyList class]];
        _CNEmptyList_instance = [CNEmptyList emptyList];
    }
}

- (NSUInteger)count {
    return 0;
}

- (id)head {
    @throw @"List is empty";
}

- (id)headOpt {
    return [CNOption none];
}

- (CNImList*)tail {
    return self;
}

- (BOOL)isEmpty {
    return YES;
}

- (CNImList*)filterF:(BOOL(^)(id))f {
    return self;
}

- (CNImList*)reverse {
    return self;
}

- (void)forEach:(void(^)(id))each {
}

- (ODClassType*)type {
    return [CNEmptyList type];
}

+ (CNEmptyList*)instance {
    return _CNEmptyList_instance;
}

+ (ODClassType*)type {
    return _CNEmptyList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNListIterator
static ODClassType* _CNListIterator_type;
@synthesize list = _list;

+ (instancetype)listIterator {
    return [[CNListIterator alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNListIterator class]) _CNListIterator_type = [ODClassType classTypeWithCls:[CNListIterator class]];
}

- (BOOL)hasNext {
    return !([_list isEmpty]);
}

- (id)next {
    id ret = [_list head];
    _list = [_list tail];
    return ret;
}

- (ODClassType*)type {
    return [CNListIterator type];
}

+ (ODClassType*)type {
    return _CNListIterator_type;
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


@implementation CNImListBuilder
static ODClassType* _CNImListBuilder_type;

+ (instancetype)imListBuilder {
    return [[CNImListBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _list = [CNImList apply];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNImListBuilder class]) _CNImListBuilder_type = [ODClassType classTypeWithCls:[CNImListBuilder class]];
}

- (void)appendItem:(id)item {
    _list = [CNImList applyItem:item tail:_list];
}

- (CNImList*)build {
    return [_list reverse];
}

- (void)appendAllItems:(id<CNTraversable>)items {
    [items forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (ODClassType*)type {
    return [CNImListBuilder type];
}

+ (ODClassType*)type {
    return _CNImListBuilder_type;
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


