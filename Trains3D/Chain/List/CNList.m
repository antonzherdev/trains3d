#import "CNList.h"
#import "cnTypes.h"
#import "NSMutableArray+CNChain.h"

#import "CNChain.h"
@implementation CNArrayBuilder{
    NSMutableArray* _array;
}
@synthesize array = _array;

+ (id)arrayBuilder {
    return [[CNArrayBuilder alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _array = [NSMutableArray mutableArray];
    
    return self;
}

- (void)addObject:(id)object {
    [_array addObject:object];
    self;
}

- (NSArray*)build {
    return _array;
}

- (void)addAllObject:(id<CNTraversable>)object {
    [object forEach:^void(id _) {
        [self addObject:_];
    }];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
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


