#import "geometry.h"

@implementation geometry
static NSString* _geometry_prefix = @"GE";
static ODClassType* _geometry_type;

+ (void)initialize {
    [super initialize];
    _geometry_type = [ODClassType classTypeWithCls:[geometry class]];
}

- (ODClassType*)type {
    return [geometry type];
}

+ (NSString*)prefix {
    return _geometry_prefix;
}

+ (ODClassType*)type {
    return _geometry_type;
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


