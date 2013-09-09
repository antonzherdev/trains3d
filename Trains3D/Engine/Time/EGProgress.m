#import "EGProgress.h"

@implementation EGProgress
static ODClassType* _EGProgress_type;

+ (void)initialize {
    [super initialize];
    _EGProgress_type = [ODClassType classTypeWithCls:[EGProgress class]];
}

+ (float(^)(float))progressY1:(float)y1 y2:(float)y2 {
    float k = y2 - y1;
    return ^float(float t) {
        return k * t + y1;
    };
}

+ (id(^)(float))gapT1:(float)t1 t2:(float)t2 {
    float l = t2 - t1;
    return ^id(float t) {
        if(float4Between(t, t1, t2)) return [CNOption some:numf4((t - t1) / l)];
        else return [CNOption none];
    };
}

+ (void(^)(float))compileFunctions:(id<CNSeq>)functions {
    return ^void(float t) {
        [functions forEach:^void(void(^_)(float)) {
            _(t);
        }];
    };
}

- (ODClassType*)type {
    return [EGProgress type];
}

+ (ODClassType*)type {
    return _EGProgress_type;
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


