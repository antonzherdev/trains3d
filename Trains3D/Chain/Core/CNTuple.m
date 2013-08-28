#import "CNTuple.h"

#import "CNOption.h"
@implementation CNTuple{
    id _a;
    id _b;
}
@synthesize a = _a;
@synthesize b = _b;

+ (id)tupleWithA:(id)a b:(id)b {
    return [[CNTuple alloc] initWithA:a b:b];
}

- (id)initWithA:(id)a b:(id)b {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
    }
    
    return self;
}

- (NSInteger)compareTo:(CNTuple*)to {
    NSInteger r = [to.a compareTo:_a];
    if(r == 0) return -[to.b compareTo:_b];
    else return -r;
}

- (NSString*)description {
    return [[[[@"(" stringByAppendingFormat:@"%@", _a] stringByAppendingString:@", "] stringByAppendingFormat:@"%@", _b] stringByAppendingString:@")"];
}

+ (id)unapplyTuple:(CNTuple*)tuple {
    return [CNOption opt:tuple];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTuple* o = ((CNTuple*)(other));
    return [self.a isEqual:o.a] && [self.b isEqual:o.b];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    return hash;
}

@end


@implementation CNTuple3{
    id _a;
    id _b;
    id _c;
}
@synthesize a = _a;
@synthesize b = _b;
@synthesize c = _c;

+ (id)tuple3WithA:(id)a b:(id)b c:(id)c {
    return [[CNTuple3 alloc] initWithA:a b:b c:c];
}

- (id)initWithA:(id)a b:(id)b c:(id)c {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
        _c = c;
    }
    
    return self;
}

- (NSInteger)compareTo:(CNTuple3*)to {
    NSInteger r = [to.a compareTo:_a];
    if(r == 0) {
        r = [to.b compareTo:_b];
        if(r == 0) return -[to.c compareTo:_c];
        else return -r;
    } else {
        return -r;
    }
}

- (NSString*)description {
    return [[[[[[@"(" stringByAppendingFormat:@"%@", _a] stringByAppendingString:@", "] stringByAppendingFormat:@"%@", _b] stringByAppendingString:@", "] stringByAppendingFormat:@"%@", _c] stringByAppendingString:@")"];
}

+ (id)unapplyTuple:(CNTuple3*)tuple {
    return [CNOption opt:tuple];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTuple3* o = ((CNTuple3*)(other));
    return [self.a isEqual:o.a] && [self.b isEqual:o.b] && [self.c isEqual:o.c];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    hash = hash * 31 + [self.c hash];
    return hash;
}

@end


@implementation CNTuple4{
    id _a;
    id _b;
    id _c;
    id _d;
}
@synthesize a = _a;
@synthesize b = _b;
@synthesize c = _c;
@synthesize d = _d;

+ (id)tuple4WithA:(id)a b:(id)b c:(id)c d:(id)d {
    return [[CNTuple4 alloc] initWithA:a b:b c:c d:d];
}

- (id)initWithA:(id)a b:(id)b c:(id)c d:(id)d {
    self = [super init];
    if(self) {
        _a = a;
        _b = b;
        _c = c;
        _d = d;
    }
    
    return self;
}

- (NSInteger)compareTo:(CNTuple4*)to {
    NSInteger r = [to.a compareTo:_a];
    if(r == 0) {
        r = [to.b compareTo:_b];
        if(r == 0) {
            r = [to.c compareTo:_c];
            if(r == 0) return -[to.d compareTo:_d];
            else return -r;
        } else {
            return -r;
        }
    } else {
        return -r;
    }
}

- (NSString*)description {
    return [[[[[[@"(" stringByAppendingFormat:@"%@", _a] stringByAppendingString:@", "] stringByAppendingFormat:@"%@", _b] stringByAppendingString:@", "] stringByAppendingFormat:@"%@", _c] stringByAppendingString:@")"];
}

+ (id)unapplyTuple:(CNTuple4*)tuple {
    return [CNOption opt:tuple];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTuple4* o = ((CNTuple4*)(other));
    return [self.a isEqual:o.a] && [self.b isEqual:o.b] && [self.c isEqual:o.c] && [self.d isEqual:o.d];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    hash = hash * 31 + [self.c hash];
    hash = hash * 31 + [self.d hash];
    return hash;
}

@end


