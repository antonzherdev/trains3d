#import "eg.h"

@implementation Eg
static ODClassType* _Eg_type;

+ (void)initialize {
    [super initialize];
    _Eg_type = [ODClassType classTypeWithCls:[Eg class]];
}

- (ODClassType*)type {
    return [Eg type];
}

+ (ODClassType*)type {
    return _Eg_type;
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


