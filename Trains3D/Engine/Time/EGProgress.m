#import "EGProgress.h"

@implementation EGProgress
static ODClassType* _EGProgress_type;

+ (void)initialize {
    [super initialize];
    _EGProgress_type = [ODClassType classTypeWithCls:[EGProgress class]];
}

+ (GEVec2)randomVec2 {
    return GEVec2Make(((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)));
}

+ (GEVec3)randomVec3 {
    return GEVec3Make(((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)));
}

+ (float(^)(float))progressF4:(float)f4 f42:(float)f42 {
    float k = f42 - f4;
    if(eqf4(k, 0)) return ^float(float t) {
        return f4;
    };
    else return ^float(float t) {
        return k * t + f4;
    };
}

+ (GEVec2(^)(float))progressVec2:(GEVec2)vec2 vec22:(GEVec2)vec22 {
    float(^x)(float) = [EGProgress progressF4:vec2.x f42:vec22.x];
    float(^y)(float) = [EGProgress progressF4:vec2.y f42:vec22.y];
    return ^GEVec2(float t) {
        return GEVec2Make(x(t), y(t));
    };
}

+ (GEVec3(^)(float))progressVec3:(GEVec3)vec3 vec32:(GEVec3)vec32 {
    float(^x)(float) = [EGProgress progressF4:vec3.x f42:vec32.x];
    float(^y)(float) = [EGProgress progressF4:vec3.y f42:vec32.y];
    float(^z)(float) = [EGProgress progressF4:vec3.z f42:vec32.z];
    return ^GEVec3(float t) {
        return GEVec3Make(x(t), y(t), z(t));
    };
}

+ (GEVec4(^)(float))progressVec4:(GEVec4)vec4 vec42:(GEVec4)vec42 {
    float(^x)(float) = [EGProgress progressF4:vec4.x f42:vec42.x];
    float(^y)(float) = [EGProgress progressF4:vec4.y f42:vec42.y];
    float(^z)(float) = [EGProgress progressF4:vec4.z f42:vec42.z];
    float(^w)(float) = [EGProgress progressF4:vec4.w f42:vec42.w];
    return ^GEVec4(float t) {
        return GEVec4Make(x(t), y(t), z(t), w(t));
    };
}

+ (id(^)(float))gapT1:(float)t1 t2:(float)t2 {
    float l = t2 - t1;
    return ^id(float t) {
        if(float4Between(t, t1, t2)) return [CNOption someValue:numf4((t - t1) / l)];
        else return [CNOption none];
    };
}

+ (float(^)(float))divOn:(float)on {
    return ^float(float t) {
        return t / on;
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


