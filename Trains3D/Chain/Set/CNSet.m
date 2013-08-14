#import "CNSet.h"
#import "NSMutableSet+CNChain.h"

@implementation NSSetBuilder{
    NSMutableSet* _set;
}
@synthesize set = _set;

+ (id)setBuilder {
    return [[NSSetBuilder alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _set = [NSMutableSet mutableSet];
    
    return self;
}

- (void)addObject:(id)object {
    [_set addObject:object];
}

- (NSSet*)build {
    return _set;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    NSSetBuilder* o = ((NSSetBuilder*)other);
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


