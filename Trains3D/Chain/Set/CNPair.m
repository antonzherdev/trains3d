#import "CNPair.h"

@implementation CNPair{
    id _a;
    id _b;
}
@synthesize a = _a;
@synthesize b = _b;

+ (id)pairWithA:(id)a b:(id)b {
    return [[CNPair alloc] initWithA:a b:b];
}

- (id)initWithA:(id)a b:(id)b {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
    }
    
    return self;
}

+ (CNPair*)newWithA:(id)a b:(id)b {
    if(a < b) return [CNPair pairWithA:a b:b];
    else return [CNPair pairWithA:b b:a];
}

- (BOOL)containsObject:(id)object {
    return [_a isEqual:object] || [_b isEqual:object];
}

- (NSUInteger)count {
    return 2;
}

- (id<CNIterator>)iterator {
    return [CNPairIterator pairIteratorWithPair:self];
}

- (id)head {
    return [CNOption opt:_a];
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNPair* o = ((CNPair*)other);
    return [self.a isEqual:o.a] && [self.b isEqual:o.b];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", self.a];
    [description appendFormat:@", b=%@", self.b];
    [description appendString:@">"];
    return description;
}

@end


@implementation CNPairIterator{
    CNPair* _pair;
    NSInteger _state;
}
@synthesize pair = _pair;

+ (id)pairIteratorWithPair:(CNPair*)pair {
    return [[CNPairIterator alloc] initWithPair:pair];
}

- (id)initWithPair:(CNPair*)pair {
    self = [super init];
    if(self) {
        _pair = pair;
        _state = 0;
    }
    
    return self;
}

- (BOOL)hasNext {
    return _state < 2;
}

- (id)next {
    _state++;
    if(_state == 1) return _pair.a;
    else return _pair.b;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"pair=%@", self.pair];
    [description appendString:@">"];
    return description;
}

@end


