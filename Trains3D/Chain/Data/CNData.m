#import "CNData.h"

#import "CNOption.h"
#import "CNChain.h"
@implementation CNPArray{
    NSUInteger _stride;
    id(^_wrap)(VoidRef, NSUInteger);
    NSUInteger _count;
    NSUInteger _length;
    VoidRef _bytes;
    BOOL _copied;
}
static ODType* _CNPArray_type;
@synthesize stride = _stride;
@synthesize wrap = _wrap;
@synthesize count = _count;
@synthesize length = _length;
@synthesize bytes = _bytes;
@synthesize copied = _copied;

+ (id)arrayWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied {
    return [[CNPArray alloc] initWithStride:stride wrap:wrap count:count length:length bytes:bytes copied:copied];
}

- (id)initWithStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count length:(NSUInteger)length bytes:(VoidRef)bytes copied:(BOOL)copied {
    self = [super init];
    if(self) {
        _stride = stride;
        _wrap = wrap;
        _count = count;
        _length = length;
        _bytes = bytes;
        _copied = copied;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNPArray_type = [ODType typeWithCls:[CNPArray class]];
}

+ (CNPArray*)applyStride:(NSUInteger)stride wrap:(id(^)(VoidRef, NSUInteger))wrap count:(NSUInteger)count copyBytes:(VoidRef)copyBytes {
    NSUInteger len = count * stride;
    return [CNPArray arrayWithStride:stride wrap:wrap count:count length:len bytes:copy(copyBytes, count * stride) copied:YES];
}

- (id<CNIterator>)iterator {
    return [CNPArrayIterator arrayIteratorWithArray:self];
}

- (id)applyIndex:(NSUInteger)index {
    if(index >= _count) return [CNOption none];
    else return [CNOption opt:_wrap(_bytes, index)];
}

- (void)dealloc {
    if(_copied) free(_bytes);
}

- (ODType*)type {
    return _CNPArray_type;
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

+ (ODType*)type {
    return _CNPArray_type;
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

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.stride;
    hash = hash * 31 + [self.wrap hash];
    hash = hash * 31 + self.count;
    hash = hash * 31 + self.length;
    hash = hash * 31 + VoidRefHash(self.bytes);
    hash = hash * 31 + self.copied;
    return hash;
}

@end


@implementation CNPArrayIterator{
    CNPArray* _array;
    NSInteger _i;
}
static ODType* _CNPArrayIterator_type;
@synthesize array = _array;

+ (id)arrayIteratorWithArray:(CNPArray*)array {
    return [[CNPArrayIterator alloc] initWithArray:array];
}

- (id)initWithArray:(CNPArray*)array {
    self = [super init];
    if(self) {
        _array = array;
        _i = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNPArrayIterator_type = [ODType typeWithCls:[CNPArrayIterator class]];
}

- (BOOL)hasNext {
    return _i < _array.count;
}

- (id)next {
    id ret = [_array applyIndex:((NSUInteger)(_i))];
    _i++;
    return ret;
}

- (ODType*)type {
    return _CNPArrayIterator_type;
}

+ (ODType*)type {
    return _CNPArrayIterator_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNPArrayIterator* o = ((CNPArrayIterator*)(other));
    return [self.array isEqual:o.array];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.array hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"array=%@", self.array];
    [description appendString:@">"];
    return description;
}

@end


