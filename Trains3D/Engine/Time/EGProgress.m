#import "EGProgress.h"

@implementation EGProgress
static ODClassType* _EGProgress_type;

+ (void)initialize {
    [super initialize];
    _EGProgress_type = [ODClassType classTypeWithCls:[EGProgress class]];
}

+ (EGVec2)randomVec2 {
    return EGVec2Make(((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)));
}

+ (EGVec3)randomVec3 {
    return EGVec3Make(((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)), ((float)(2 * randomFloat() - 1)));
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

+ (EGVec2(^)(float))progressVec2:(EGVec2)vec2 vec22:(EGVec2)vec22 {
    float(^x)(float) = [EGProgress progressF4:vec2.x f42:vec22.x];
    float(^y)(float) = [EGProgress progressF4:vec2.y f42:vec22.y];
    return ^EGVec2(float t) {
        return EGVec2Make(x(t), y(t));
    };
}

+ (EGVec3(^)(float))progressVec3:(EGVec3)vec3 vec32:(EGVec3)vec32 {
    float(^x)(float) = [EGProgress progressF4:vec3.x f42:vec32.x];
    float(^y)(float) = [EGProgress progressF4:vec3.y f42:vec32.y];
    float(^z)(float) = [EGProgress progressF4:vec3.z f42:vec32.z];
    return ^EGVec3(float t) {
        return EGVec3Make(x(t), y(t), z(t));
    };
}

+ (EGVec4(^)(float))progressVec4:(EGVec4)vec4 vec42:(EGVec4)vec42 {
    float(^x)(float) = [EGProgress progressF4:vec4.x f42:vec42.x];
    float(^y)(float) = [EGProgress progressF4:vec4.y f42:vec42.y];
    float(^z)(float) = [EGProgress progressF4:vec4.z f42:vec42.z];
    float(^w)(float) = [EGProgress progressF4:vec4.w f42:vec42.w];
    return ^EGVec4(float t) {
        return EGVec4Make(x(t), y(t), z(t), w(t));
    };
}

+ (EGColor(^)(float))progressColor:(EGColor)color color2:(EGColor)color2 {
    float(^r)(float) = [EGProgress progressF4:color.r f42:color2.r];
    float(^g)(float) = [EGProgress progressF4:color.g f42:color2.g];
    float(^b)(float) = [EGProgress progressF4:color.b f42:color2.b];
    float(^a)(float) = [EGProgress progressF4:color.a f42:color2.a];
    return ^EGColor(float t) {
        return EGColorMake(r(t), g(t), b(t), a(t));
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


