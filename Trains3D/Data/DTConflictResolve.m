#import "DTConflictResolve.h"

@implementation DTConflict
static id(^_DTConflict_resolveMax)(id, id);
static id(^_DTConflict_resolveMin)(id, id);
static ODClassType* _DTConflict_type;

+ (void)initialize {
    [super initialize];
    _DTConflict_type = [ODClassType classTypeWithCls:[DTConflict class]];
    _DTConflict_resolveMax = ^id(id a, id b) {
        if([((id<ODComparable>)(a)) compareTo:((id<ODComparable>)(b))] > 0) return a;
        else return b;
    };
    _DTConflict_resolveMin = ^id(id a, id b) {
        if([((id<ODComparable>)(a)) compareTo:((id<ODComparable>)(b))] < 0) return a;
        else return b;
    };
}

- (ODClassType*)type {
    return [DTConflict type];
}

+ (id(^)(id, id))resolveMax {
    return _DTConflict_resolveMax;
}

+ (id(^)(id, id))resolveMin {
    return _DTConflict_resolveMin;
}

+ (ODClassType*)type {
    return _DTConflict_type;
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

