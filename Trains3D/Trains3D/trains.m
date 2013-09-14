#import "trains.h"

@implementation trains
static ODClassType* _trains_type;

+ (void)initialize {
    [super initialize];
    _trains_type = [ODClassType classTypeWithCls:[trains class]];
}

- (ODClassType*)type {
    return [trains type];
}

+ (ODClassType*)type {
    return _trains_type;
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


