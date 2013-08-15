#import "CNRange.h"

#import "CNChain.h"
@implementation CNRange{
    NSInteger _start;
    NSInteger _end;
    NSInteger _step;
    NSUInteger _count;
}
@synthesize start = _start;
@synthesize end = _end;
@synthesize step = _step;
@synthesize count = _count;

+ (id)rangeWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    return [[CNRange alloc] initWithStart:start end:end step:step];
}

- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    self = [super init];
    if(self) {
        _start = start;
        _end = end;
        _step = step;
        _count = (_end - _start) / _step;
    }
    
    return self;
}

- (id)atIndex:(NSUInteger)index {
    if(index >= _count) return [CNOption none];
    else return [CNOption opt:numi(_start + _step * index)];
}

- (id<CNIterator>)iterator {
    return [CNRangeIterator rangeIteratorWithStart:_start end:_end step:_step];
}

- (id)randomItem {
    if([self isEmpty]) return [CNOption none];
    else return [self atIndex:randomWith([self count] - 1)];
}

- (id<CNSet>)toSet {
    return [self convertWithBuilder:[NSSetBuilder setBuilder]];
}

- (id)head {
    return [CNOption opt:[[self iterator] next]];
}

- (BOOL)isEmpty {
    return [[self iterator] hasNext];
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
    CNRange* o = ((CNRange*)other);
    return self.start == o.start && self.end == o.end && self.step == o.step;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.start;
    hash = hash * 31 + self.end;
    hash = hash * 31 + self.step;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"start=%li", self.start];
    [description appendFormat:@", end=%li", self.end];
    [description appendFormat:@", step=%li", self.step];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNRangeIterator{
    NSInteger _start;
    NSInteger _end;
    NSInteger _step;
    NSInteger _i;
}
@synthesize start = _start;
@synthesize end = _end;
@synthesize step = _step;

+ (id)rangeIteratorWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    return [[CNRangeIterator alloc] initWithStart:start end:end step:step];
}

- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    self = [super init];
    if(self) {
        _start = start;
        _end = end;
        _step = step;
        _i = _start;
    }
    
    return self;
}

- (BOOL)hasNext {
    return (_step > 0 && _i <= _end) || (_step < 0 && _i >= _end);
}

- (id)next {
    NSInteger ret = _i;
    _i += _step;
    return numi(ret);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNRangeIterator* o = ((CNRangeIterator*)other);
    return self.start == o.start && self.end == o.end && self.step == o.step;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.start;
    hash = hash * 31 + self.end;
    hash = hash * 31 + self.step;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"start=%li", self.start];
    [description appendFormat:@", end=%li", self.end];
    [description appendFormat:@", step=%li", self.step];
    [description appendString:@">"];
    return description;
}

@end


