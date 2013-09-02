#import "CNSet.h"
#import "NSMutableSet+CNChain.h"

@implementation CNHashSetBuilder{
    NSMutableSet* _set;
}
static ODClassType* _CNHashSetBuilder_type;
@synthesize set = _set;

+ (id)hashSetBuilder {
    return [[CNHashSetBuilder alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _set = [NSMutableSet mutableSet];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _CNHashSetBuilder_type = [ODClassType classTypeWithCls:[CNHashSetBuilder class]];
}

- (void)addObject:(id)object {
    [_set addObject:object];
    self;
}

- (NSSet*)build {
    return _set;
}

- (void)addAllObject:(id<CNTraversable>)object {
    [object forEach:^void(id _) {
        [self addObject:_];
    }];
}

- (ODClassType*)type {
    return [CNHashSetBuilder type];
}

+ (ODClassType*)type {
    return _CNHashSetBuilder_type;
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


