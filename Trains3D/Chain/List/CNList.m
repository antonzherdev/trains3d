#import "CNList.h"
#import "NSArray+CNChain.h"

#import "CNOption.h"
#import "CNChain.h"
@implementation CNList

+ (id)list {
    return [[CNList alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
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

- (NSUInteger)count {
    id<CNIterator> i = [self iterator];
    NSUInteger n = ((NSUInteger)(0));
    while([i hasNext]) {
        [i next];
        n++;
    }
    return n;
}

- (id)head {
    return [CNOption opt:[[self iterator] next]];
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


@implementation CNFilledList{
    id _item;
    CNList* _tail;
}
@synthesize item = _item;
@synthesize tail = _tail;

+ (id)filledListWithItem:(id)item tail:(CNList*)tail {
    return [[CNFilledList alloc] initWithItem:item tail:tail];
}

- (id)initWithItem:(id)item tail:(CNList*)tail {
    self = [super init];
    if(self) {
        _item = item;
        _tail = tail;
    }
    
    return self;
}

- (id)head {
    return [CNOption opt:_item];
}

- (BOOL)isEmpty {
    return NO;
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
static CNEmptyList* _instance;

+ (id)emptyList {
    return [[CNEmptyList alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _instance = [CNEmptyList emptyList];
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

+ (CNEmptyList*)instance {
    return _instance;
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
@synthesize list = _list;

+ (id)listIterator {
    return [[CNListIterator alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (BOOL)hasNext {
    return [_list isEmpty];
}

- (id)next {
    id ret = [[_list head] get];
    _list = [_list tail];
    return ret;
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


