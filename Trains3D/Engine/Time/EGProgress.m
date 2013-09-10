#import "EGProgress.h"

@implementation EGProgress
static ODClassType* _EGProgress_type;

+ (void)initialize {
    [super initialize];
    _EGProgress_type = [ODClassType classTypeWithCls:[EGProgress class]];
}

+ (float(^)(float))progressF4:(float)f4 f42:(float)f42 {
    float k = f42 - f4;
    return ^float(float t) {
        return k * t + f4;
    };
}

+ (EGVec2(^)(float))progressVec2:(EGVec2)vec2 vec22:(EGVec2)vec22 {
    float(^x)(float) = [EGProgress progressF4:vec2.x f42:vec22.x];
    float(^y)(float) = [EGProgress progressF4:vec2.y f42:vec22.y];
    return ^EGVec2(float t) {
        return EGVec2Make(x(t), y(t));
    };
}

+ (id(^)(float))gapT1:(float)t1 t2:(float)t2 {
    float l = t2 - t1;
    return ^id(float t) {
        if(float4Between(t, t1, t2)) return [CNOption some:numf4((t - t1) / l)];
        else return [CNOption none];
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


