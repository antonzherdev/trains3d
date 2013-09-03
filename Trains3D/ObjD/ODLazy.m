#import "ODLazy.h"

@implementation ODLazy{
    id(^_f)();
    id __value;
    BOOL __calculated;
}
static ODClassType* _ODLazy_type;
@synthesize f = _f;

+ (id)lazyWithF:(id(^)())f {
    return [[ODLazy alloc] initWithF:f];
}

- (id)initWithF:(id(^)())f {
    self = [super init];
    if(self) {
        _f = f;
        __calculated = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _ODLazy_type = [ODClassType classTypeWithCls:[ODLazy class]];
}

- (id)get {
    if(__calculated) {
        return __value;
    } else {
        __value = ((id(^)())(_f))();
        __calculated = YES;
        return __value;
    }
}

- (ODClassType*)type {
    return [ODLazy type];
}

+ (ODClassType*)type {
    return _ODLazy_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ODLazy* o = ((ODLazy*)(other));
    return [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


