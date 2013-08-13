#import "CNRange.h"

#import "CNChain.h"
@implementation CNRange{
    NSInteger _start;
    NSInteger _end;
    NSInteger _step;
}
@synthesize start = _start;
@synthesize end = _end;
@synthesize step = _step;

+ (id)rangeWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    return [[CNRange alloc] initWithStart:start end:end step:step];
}

- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step {
    self = [super init];
    if(self) {
        _start = start;
        _end = end;
        _step = step;
    }
    
    return self;
}

- (NSUInteger)count {
    return (_end - _start) / _step;
}

- (id<CNIterator>)iterator {
    return [CNRangeIterator rangeIteratorWithStart:_start end:_end step:_step];
}

- (id)head {
    return [[self iterator] next];
}

- (BOOL)isEmpty {
    return [[[self iterator] next] isEmpty];
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while(YES) {
        id object = [i next];
        if([object isEmpty]) break;
        each(object);
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = [self iterator];
    while(YES) {
        id object = [i next];
        if([object isEmpty]) return YES;
        if(!(on(object))) return NO;
    }
    return NO;
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

- (id)next {
    if((_step > 0 && _i > _end) || (_step < 0 && _i < _end)) {
        return [CNOption none];
    } else {
        NSInteger ret = _i;
        _i += _step;
        return [CNOption opt:numi(ret)];
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
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


