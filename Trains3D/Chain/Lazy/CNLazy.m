#import "objd.h"
#import "CNLazy.h"

#import "ODType.h"
@implementation CNLazy{
    id(^_f)();
    id __value;
    BOOL __calculated;
}
static ODClassType* _CNLazy_type;
@synthesize f = _f;

+ (id)lazyWithF:(id(^)())f {
    return [[CNLazy alloc] initWithF:f];
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
    _CNLazy_type = [ODClassType classTypeWithCls:[CNLazy class]];
}

- (BOOL)isCalculated {
    return __calculated;
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
    return [CNLazy type];
}

+ (ODClassType*)type {
    return _CNLazy_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNLazy* o = ((CNLazy*)(other));
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


