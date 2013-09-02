#import "CNList.h"
#import "NSArray+CNChain.h"

#import "CNOption.h"
#import "CNChain.h"
@implementation CNList
static ODClassType* _CNList_type;

+ (id)list {
    return [[CNList alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNList_type = [ODClassType classTypeWithCls:[CNList class]];
}

+ (CNList*)apply {
    return CNEmptyList.instance;
}

+ (CNList*)applyObject:(id)object {
    return [CNFilledList filledListWithItem:object tail:CNEmptyList.instance];
}

+ (CNList*)applyObject:(id)object tail:(CNList*)tail {
    return [CNFilledList filledListWithItem:object tail:tail];
}

- (id<CNIterator>)iterator {
    CNListIterator* i = [CNListIterator listIterator];
    i.list = self;
    return i;
}

- (CNList*)tail {
    @throw @"Method tail is abstract";
}

- (CNList*)filterF:(BOOL(^)(id))f {
    @throw @"Method filter is abstract";
}

- (id)applyIndex:(NSUInteger)index {
    id<CNIterator> i = [self iterator];
    NSUInteger n = index;
    while([i hasNext]) {
        if(n == 0) return [i next];
        [i next];
        n--;
    }
    return [CNOption none];
}

- (id)randomItem {
    if([self isEmpty]) return [CNOption none];
    else return [self applyIndex:randomWith([self count] - 1)];
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[CNHashSetBuilder hashSetBuilder]];
}

- (id<CNSeq>)arrayByAddingObject:(id)object {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder addAllObject:self];
    [builder addObject:object];
    return ((NSArray*)([builder build]));
}

- (id<CNSeq>)arrayByRemovingObject:(id)object {
    return [[[self chain] filter:^BOOL(id _) {
        return !([_ isEqual:object]);
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
    if([[self iterator] hasNext]) return [CNOption opt:[[self iterator] next]];
    else return [CNOption none];
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

- (BOOL)containsObject:(id)object {
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
    return [CNList type];
}

+ (ODClassType*)type {
    return _CNList_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other)) return NO;
    if([other conformsToProtocol:@protocol(CNSeq)]) return [self isEqualToSeq:((id<CNSeq>)(other))];
    return NO;
}

@end


@implementation CNFilledList{
    id _item;
    CNList* _tail;
    NSUInteger _count;
}
static ODClassType* _CNFilledList_type;
@synthesize item = _item;
@synthesize tail = _tail;
@synthesize count = _count;

+ (id)filledListWithItem:(id)item tail:(CNList*)tail {
    return [[CNFilledList alloc] initWithItem:item tail:tail];
}

- (id)initWithItem:(id)item tail:(CNList*)tail {
    self = [super init];
    if(self) {
        _item = item;
        _tail = tail;
        _count = [_tail count] + 1;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNFilledList_type = [ODClassType classTypeWithCls:[CNFilledList class]];
}

- (id)head {
    return [CNOption opt:_item];
}

- (BOOL)isEmpty {
    return NO;
}

- (CNList*)filterF:(BOOL(^)(id))f {
    if(f(_item)) return [CNFilledList filledListWithItem:_item tail:[_tail filterF:f]];
    else return [_tail filterF:f];
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
    return [self.item isEqual:o.item] && [self.tail isEqual:o.tail];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.item hash];
    hash = hash * 31 + [self.tail hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"item=%@", self.item];
    [description appendFormat:@", tail=%@", self.tail];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNEmptyList
static CNEmptyList* _CNEmptyList_instance;
static ODClassType* _CNEmptyList_type;

+ (id)emptyList {
    return [[CNEmptyList alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNEmptyList_type = [ODClassType classTypeWithCls:[CNEmptyList class]];
    _CNEmptyList_instance = [CNEmptyList emptyList];
}

- (NSUInteger)count {
    return 0;
}

- (id)head {
    return [CNOption none];
}

- (CNList*)tail {
    return self;
}

- (BOOL)isEmpty {
    return YES;
}

- (CNList*)filterF:(BOOL(^)(id))f {
    return self;
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


@implementation CNListIterator{
    CNList* _list;
}
static ODClassType* _CNListIterator_type;
@synthesize list = _list;

+ (id)listIterator {
    return [[CNListIterator alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNListIterator_type = [ODClassType classTypeWithCls:[CNListIterator class]];
}

- (BOOL)hasNext {
    return !([_list isEmpty]);
}

- (id)next {
    id ret = [[_list head] get];
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


