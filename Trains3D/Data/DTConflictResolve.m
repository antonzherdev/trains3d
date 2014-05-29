#import "DTConflictResolve.h"

@implementation DTConflict
static id(^_DTConflict_resolveMax)(id, id);
static id(^_DTConflict_resolveMin)(id, id);
static CNClassType* _DTConflict_type;

+ (void)initialize {
    [super initialize];
    if(self == [DTConflict class]) {
        _DTConflict_type = [CNClassType classTypeWithCls:[DTConflict class]];
        _DTConflict_resolveMax = ^id(id a, id b) {
            if([((id<CNComparable>)(a)) compareTo:((id<CNComparable>)(b))] > 0) return a;
            else return b;
        };
        _DTConflict_resolveMin = ^id(id a, id b) {
            if([((id<CNComparable>)(a)) compareTo:((id<CNComparable>)(b))] < 0) return a;
            else return b;
        };
    }
}

- (CNClassType*)type {
    return [DTConflict type];
}

+ (id(^)(id, id))resolveMax {
    return _DTConflict_resolveMax;
}

+ (id(^)(id, id))resolveMin {
    return _DTConflict_resolveMin;
}

+ (CNClassType*)type {
    return _DTConflict_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

