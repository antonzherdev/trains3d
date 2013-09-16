#import "geometry.h"

@implementation Geometry
static NSString* _Geometry_prefix = @"GE";
static ODClassType* _Geometry_type;

+ (void)initialize {
    [super initialize];
    _Geometry_type = [ODClassType classTypeWithCls:[Geometry class]];
}

- (ODClassType*)type {
    return [Geometry type];
}

+ (NSString*)prefix {
    return _Geometry_prefix;
}

+ (ODClassType*)type {
    return _Geometry_type;
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


