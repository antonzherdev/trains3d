#import "trains.h"

@implementation Trains
static ODClassType* _Trains_type;

+ (void)initialize {
    [super initialize];
    _Trains_type = [ODClassType classTypeWithCls:[Trains class]];
}

- (ODClassType*)type {
    return [Trains type];
}

+ (ODClassType*)type {
    return _Trains_type;
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


