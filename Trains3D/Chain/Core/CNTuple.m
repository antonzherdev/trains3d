#import "CNTuple.h"


@implementation CNTuple {
    id _a;
    id _b;
}
@synthesize a = _a;
@synthesize b = _b;

- (id)initWithA:(id)anA b:(id)aB {
    self = [super init];
    if (self) {
        _a = anA;
        _b = aB;
    }

    return self;
}

+ (id)tupleWithA:(id)anA b:(id)aB {
    return [[self alloc] initWithA:anA b:aB];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToTuple:other];
}

- (BOOL)isEqualToTuple:(CNTuple *)tuple {
    if (self == tuple)
        return YES;
    if (tuple == nil)
        return NO;
    if (_a != tuple->_a && ![_a isEqual:tuple->_a])
        return NO;
    if (_b != tuple->_b && ![_b isEqual:tuple->_b])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [_a hash];
    hash = hash * 31u + [_b hash];
    return hash;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@, %@)", _a, _b];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end