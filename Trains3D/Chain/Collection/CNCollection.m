#import "CNCollection.h"

#import "CNChain.h"
@implementation CNIterable

+ (id)iterable {
    return [[CNIterable alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (id<CNIterator>)iterator {
    @throw @"Method iterator is abstract";
}

- (id)head {
    return [[self iterator] next];
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
    CNIterable* o = ((CNIterable*)other);
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


