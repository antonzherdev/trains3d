#import "CNTuple.h"

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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNTuple* o = ((CNTuple*)other);
    return [self.a isEqual:o.a] && [self.b isEqual:o.b];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    return hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@, %@)", _a, _b];
}

@end


