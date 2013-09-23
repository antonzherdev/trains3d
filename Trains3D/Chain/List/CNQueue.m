#import "objd.h"
#import "CNQueue.h"

#import "CNList.h"
#import "CNOption.h"
#import "ODType.h"
#import "math.h"
#import "CNSet.h"
#import "CNChain.h"
@implementation CNQueue{
    CNList* _in;
    CNList* _out;
}
static CNQueue* _CNQueue_empty;
static ODClassType* _CNQueue_type;
@synthesize in = _in;
@synthesize out = _out;

+ (id)queueWithIn:(CNList*)in out:(CNList*)out {
    return [[CNQueue alloc] initWithIn:in out:out];
}

- (id)initWithIn:(CNList*)in out:(CNList*)out {
    self = [super init];
    if(self) {
        _in = in;
        _out = out;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNQueue_type = [ODClassType classTypeWithCls:[CNQueue class]];
    _CNQueue_empty = [CNQueue queueWithIn:[CNList apply] out:[CNList apply]];
}

+ (CNQueue*)apply {
    return _CNQueue_empty;
}

- (CNQueue*)enqueueItem:(id)item {
    return [CNQueue queueWithIn:[CNList applyItem:item tail:_in] out:_out];
}

- (id<CNIterator>)iterator {
    return [CNQueueIterator queueIteratorWithIn:_in out:_out];
}

- (BOOL)isEmpty {
    return [_in isEmpty] && [_out isEmpty];
}

- (NSUInteger)count {
    return [_in count] + [_out count];
}

- (id)applyIndex:(NSUInteger)index {
    if(index < [_out count]) {
        return [_out applyIndex:index];
    } else {
        if(index < [_out count] + [_in count]) return [_in applyIndex:[_in count] - index + [_out count]];
        else @throw [NSString stringWithFormat:@"Incorrect index=%li", index];
    }
}

- (CNTuple*)dequeue {
    if(!([_out isEmpty])) {
        return tuple([_out head], [CNQueue queueWithIn:_in out:[_out tail]]);
    } else {
        if([_in isEmpty]) {
            return tuple([CNOption none], self);
        } else {
            CNList* rev = [_in reverse];
            return tuple([rev head], [CNQueue queueWithIn:[CNList apply] out:[rev tail]]);
        }
    }
}

- (id)randomItem {
    if([self isEmpty]) return [CNOption none];
    else return [CNOption applyValue:[self applyIndex:randomMax([self count] - 1)]];
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[CNHashSetBuilder hashSetBuilder]];
}

- (id<CNSeq>)arrayByAddingItem:(id)item {
    CNArrayBuilder* builder = [CNArrayBuilder arrayBuilder];
    [builder addAllItem:self];
    [builder addItem:item];
    return ((NSArray*)([builder build]));
}

- (id<CNSeq>)arrayByRemovingItem:(id)item {
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

- (id)head {
    return [CNOption applyValue:[self applyIndex:0]];
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
        if(where(ret)) {
            ret = [CNOption applyValue:x];
            NO;
        }
        return YES;
    }];
    return ret;
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder addItem:x];
    }];
    return [builder build];
}

- (ODClassType*)type {
    return [CNQueue type];
}

+ (ODClassType*)type {
    return _CNQueue_type;
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


@implementation CNQueueIterator{
    CNList* _in;
    CNList* _out;
    id<CNIterator> _i;
    BOOL _isIn;
}
static ODClassType* _CNQueueIterator_type;
@synthesize in = _in;
@synthesize out = _out;

+ (id)queueIteratorWithIn:(CNList*)in out:(CNList*)out {
    return [[CNQueueIterator alloc] initWithIn:in out:out];
}

- (id)initWithIn:(CNList*)in out:(CNList*)out {
    self = [super init];
    if(self) {
        _in = in;
        _out = out;
        _i = [_in iterator];
        _isIn = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNQueueIterator_type = [ODClassType classTypeWithCls:[CNQueueIterator class]];
}

- (BOOL)hasNext {
    if([_i hasNext]) {
        return YES;
    } else {
        if(_isIn) {
            _isIn = NO;
            _i = [[_out reverse] iterator];
            return [_i hasNext];
        } else {
            return NO;
        }
    }
}

- (id)next {
    if(!([_i hasNext]) && _isIn) {
        _isIn = NO;
        _i = [[_out reverse] iterator];
    }
    return [_i next];
}

- (ODClassType*)type {
    return [CNQueueIterator type];
}

+ (ODClassType*)type {
    return _CNQueueIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNQueueIterator* o = ((CNQueueIterator*)(other));
    return [self.in isEqual:o.in] && [self.out isEqual:o.out];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.in hash];
    hash = hash * 31 + [self.out hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"in=%@", self.in];
    [description appendFormat:@", out=%@", self.out];
    [description appendString:@">"];
    return description;
}

@end


