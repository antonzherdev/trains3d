#import "CNList.h"
#import "NSMutableArray+CNChain.h"

@implementation NSArrayBuilder{
    NSMutableArray* _array;
}
@synthesize array = _array;

+ (id)arrayBuilder {
    return [[NSArrayBuilder alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _array = [NSMutableArray mutableArray];
    
    return self;
}

- (void)addObject:(id)object {
    [_array addObject:object];
}

- (NSArray*)build {
    return _array;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    NSArrayBuilder* o = ((NSArrayBuilder*)other);
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


