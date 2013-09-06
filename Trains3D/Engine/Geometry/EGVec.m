#import "EGVec.h"

#import "EGMath.h"
EGVec2 egVec2Apply(EGVec2I point) {
    return EGVec2Make(((float)(point.x)), ((float)(point.y)));
}
EGVec2 egVec2Add(EGVec2 self, EGVec2 point) {
    return EGVec2Make(self.x + point.x, self.y + point.y);
}
EGVec2 egVec2Sub(EGVec2 self, EGVec2 point) {
    return EGVec2Make(self.x - point.x, self.y - point.y);
}
EGVec2 egVec2Negate(EGVec2 self) {
    return EGVec2Make(-self.x, -self.y);
}
float egVec2Angle(EGVec2 self) {
    return ((float)(atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float egVec2Dot(EGVec2 self, EGVec2 point) {
    return self.x * point.x + self.y * point.y;
}
float egVec2LengthSquare(EGVec2 self) {
    return egVec2Dot(self, self);
}
CGFloat egVec2Length(EGVec2 self) {
    return sqrt(((CGFloat)(egVec2LengthSquare(self))));
}
EGVec2 egVec2Mul(EGVec2 self, float value) {
    return EGVec2Make(self.x * value, self.y * value);
}
EGVec2 egVec2Div(EGVec2 self, float value) {
    return EGVec2Make(self.x / value, self.y / value);
}
EGVec2 egVec2Mid(EGVec2 self, EGVec2 point) {
    return egVec2Mul(egVec2Add(self, point), ((float)(0.5)));
}
CGFloat egVec2DistanceTo(EGVec2 self, EGVec2 point) {
    return egVec2Length(egVec2Sub(self, point));
}
EGVec2 egVec2Set(EGVec2 self, float length) {
    return egVec2Mul(self, length / egVec2Length(self));
}
EGVec2 egVec2Normalize(EGVec2 self) {
    return egVec2Set(self, ((float)(1.0)));
}
NSInteger egVec2Compare(EGVec2 self, EGVec2 to) {
    NSInteger dX = float4Compare(self.x, to.x);
    if(dX != 0) return dX;
    else return float4Compare(self.y, to.y);
}
ODPType* egVec2Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec2Wrap class] name:@"EGVec2" size:sizeof(EGVec2) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec2, ((EGVec2*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec2Wrap{
    EGVec2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec2)value {
    return [[EGVec2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec2Wrap* o = ((EGVec2Wrap*)(other));
    return EGVec2Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec2Hash(_value);
}

- (NSInteger)compareTo:(EGVec2Wrap*)to {
    return egVec2Compare(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec2I egVec2IApply(EGVec2 point) {
    return EGVec2IMake(lround(((CGFloat)(point.x))), lround(((CGFloat)(point.y))));
}
EGVec2I egVec2IAdd(EGVec2I self, EGVec2I point) {
    return EGVec2IMake(self.x + point.x, self.y + point.y);
}
EGVec2I egVec2ISub(EGVec2I self, EGVec2I point) {
    return EGVec2IMake(self.x - point.x, self.y - point.y);
}
EGVec2I egVec2INegate(EGVec2I self) {
    return EGVec2IMake(-self.x, -self.y);
}
NSInteger egVec2ICompare(EGVec2I self, EGVec2I to) {
    NSInteger dX = intCompare(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompare(self.y, to.y);
}
ODPType* egVec2IType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec2IWrap class] name:@"EGVec2I" size:sizeof(EGVec2I) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec2I, ((EGVec2I*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec2IWrap{
    EGVec2I _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec2I)value {
    return [[EGVec2IWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec2I)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec2IDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec2IWrap* o = ((EGVec2IWrap*)(other));
    return EGVec2IEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec2IHash(_value);
}

- (NSInteger)compareTo:(EGVec2IWrap*)to {
    return egVec2ICompare(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec3 egVec3Apply(EGVec2 vec2, float z) {
    return EGVec3Make(vec2.x, vec2.y, z);
}
EGVec3 egVec3Add(EGVec3 self, EGVec3 v) {
    return EGVec3Make(self.x + v.x, self.y + v.y, self.z + v.z);
}
EGVec3 egVec3Sqr(EGVec3 self) {
    return egVec3Mul(self, ((float)(egVec3Length(self))));
}
EGVec3 egVec3Mul(EGVec3 self, float k) {
    return EGVec3Make(k * self.x, k * self.y, k * self.z);
}
CGFloat egVec3Dot(EGVec3 self, EGVec3 vec3) {
    return ((CGFloat)(self.x * vec3.x + self.y * vec3.y + self.z * vec3.z));
}
CGFloat egVec3LengthSquare(EGVec3 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z));
}
CGFloat egVec3Length(EGVec3 self) {
    return sqrt(egVec3LengthSquare(self));
}
EGVec3 egVec3Set(EGVec3 self, CGFloat length) {
    return egVec3Mul(self, ((float)(length / egVec3Length(self))));
}
EGVec3 egVec3Normalize(EGVec3 self) {
    return egVec3Set(self, 1.0);
}
ODPType* egVec3Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec3Wrap class] name:@"EGVec3" size:sizeof(EGVec3) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec3, ((EGVec3*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec3Wrap{
    EGVec3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec3)value {
    return [[EGVec3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec3Wrap* o = ((EGVec3Wrap*)(other));
    return EGVec3Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec4 egVec4Apply(EGVec3 vec3, float w) {
    return EGVec4Make(vec3.x, vec3.y, vec3.z, w);
}
EGVec3 egVec4Xyz(EGVec4 self) {
    return EGVec3Make(self.x, self.y, self.z);
}
EGVec4 egVec4Mul(EGVec4 self, float k) {
    return EGVec4Make(k * self.x, k * self.y, k * self.z, k * self.w);
}
CGFloat egVec4LengthSquare(EGVec4 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w));
}
CGFloat egVec4Length(EGVec4 self) {
    return sqrt(egVec4LengthSquare(self));
}
EGVec4 egVec4Set(EGVec4 self, CGFloat length) {
    return egVec4Mul(self, ((float)(length / egVec4Length(self))));
}
EGVec4 egVec4Normalize(EGVec4 self) {
    return egVec4Set(self, 1.0);
}
ODPType* egVec4Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec4Wrap class] name:@"EGVec4" size:sizeof(EGVec4) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec4, ((EGVec4*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec4Wrap{
    EGVec4 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec4)value {
    return [[EGVec4Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec4)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec4Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec4Wrap* o = ((EGVec4Wrap*)(other));
    return EGVec4Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec4Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



