#import "eg.h"

@implementation eg
static ODClassType* _eg_type;

+ (void)initialize {
    [super initialize];
    _eg_type = [ODClassType classTypeWithCls:[eg class]];
}

- (ODClassType*)type {
    return [eg type];
}

+ (ODClassType*)type {
    return _eg_type;
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


