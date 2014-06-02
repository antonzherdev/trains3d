#import "GEVec.h"

#import "math.h"
#import "GEMat4.h"
#import "CNChain.h"
#import "CNSortBuilder.h"
GEVec2 geVec2ApplyVec2i(GEVec2i vec2i) {
    return GEVec2Make(((float)(vec2i.x)), ((float)(vec2i.y)));
}
GEVec2 geVec2ApplyF(CGFloat f) {
    return GEVec2Make(((float)(f)), ((float)(f)));
}
GEVec2 geVec2ApplyF4(float f4) {
    return GEVec2Make(f4, f4);
}
GEVec2 geVec2Min() {
    return GEVec2Make(cnFloat4Min(), cnFloat4Min());
}
GEVec2 geVec2Max() {
    return GEVec2Make(cnFloat4Max(), cnFloat4Max());
}
GEVec2 geVec2AddVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x + vec2.x, self.y + vec2.y);
}
GEVec2 geVec2AddF4(GEVec2 self, float f4) {
    return GEVec2Make(self.x + f4, self.y + f4);
}
GEVec2 geVec2AddF(GEVec2 self, CGFloat f) {
    return GEVec2Make(self.x + f, self.y + f);
}
GEVec2 geVec2AddI(GEVec2 self, NSInteger i) {
    return GEVec2Make(self.x + i, self.y + i);
}
GEVec2 geVec2SubVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x - vec2.x, self.y - vec2.y);
}
GEVec2 geVec2SubF4(GEVec2 self, float f4) {
    return GEVec2Make(self.x - f4, self.y - f4);
}
GEVec2 geVec2SubF(GEVec2 self, CGFloat f) {
    return GEVec2Make(self.x - f, self.y - f);
}
GEVec2 geVec2SubI(GEVec2 self, NSInteger i) {
    return GEVec2Make(self.x - i, self.y - i);
}
GEVec2 geVec2MulVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x * vec2.x, self.y * vec2.y);
}
GEVec2 geVec2MulF4(GEVec2 self, float f4) {
    return GEVec2Make(self.x * f4, self.y * f4);
}
GEVec2 geVec2MulF(GEVec2 self, CGFloat f) {
    return GEVec2Make(self.x * f, self.y * f);
}
GEVec2 geVec2MulI(GEVec2 self, NSInteger i) {
    return GEVec2Make(self.x * i, self.y * i);
}
GEVec2 geVec2DivVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x / vec2.x, self.y / vec2.y);
}
GEVec2 geVec2DivF4(GEVec2 self, float f4) {
    return GEVec2Make(self.x / f4, self.y / f4);
}
GEVec2 geVec2DivF(GEVec2 self, CGFloat f) {
    return GEVec2Make(self.x / f, self.y / f);
}
GEVec2 geVec2DivI(GEVec2 self, NSInteger i) {
    return GEVec2Make(self.x / i, self.y / i);
}
GEVec2 geVec2Negate(GEVec2 self) {
    return GEVec2Make(-self.x, -self.y);
}
float geVec2DegreeAngle(GEVec2 self) {
    return ((float)(180.0 / M_PI * atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float geVec2Angle(GEVec2 self) {
    return ((float)(atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float geVec2DotVec2(GEVec2 self, GEVec2 vec2) {
    return self.x * vec2.x + self.y * vec2.y;
}
float geVec2CrossVec2(GEVec2 self, GEVec2 vec2) {
    return self.x * vec2.y - vec2.x * self.y;
}
float geVec2LengthSquare(GEVec2 self) {
    return geVec2DotVec2(self, self);
}
float geVec2Length(GEVec2 self) {
    return ((float)(sqrt(((CGFloat)(geVec2LengthSquare(self))))));
}
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2MulF((geVec2AddVec2(self, vec2)), 0.5);
}
float geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2Length((geVec2SubVec2(self, vec2)));
}
GEVec2 geVec2SetLength(GEVec2 self, float length) {
    return geVec2MulF4(self, length / geVec2Length(self));
}
GEVec2 geVec2Normalize(GEVec2 self) {
    return geVec2SetLength(self, 1.0);
}
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to) {
    NSInteger dX = float4CompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return float4CompareTo(self.y, to.y);
}
GERect geVec2RectToVec2(GEVec2 self, GEVec2 vec2) {
    return GERectMake(self, (geVec2SubVec2(vec2, self)));
}
GERect geVec2RectInCenterWithSize(GEVec2 self, GEVec2 size) {
    return GERectMake((geVec2MulF((geVec2SubVec2(size, self)), 0.5)), self);
}
GEVec2 geVec2Rnd() {
    return GEVec2Make(cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5);
}
BOOL geVec2IsEmpty(GEVec2 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0);
}
GEVec2i geVec2Round(GEVec2 self) {
    return GEVec2iMake(float4Round(self.x), float4Round(self.y));
}
GEVec2 geVec2MinVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make((float4MinB(self.x, vec2.x)), (float4MinB(self.y, vec2.y)));
}
GEVec2 geVec2MaxVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make((float4MaxB(self.x, vec2.x)), (float4MaxB(self.y, vec2.y)));
}
GEVec2 geVec2Abs(GEVec2 self) {
    return GEVec2Make(float4Abs(self.x), float4Abs(self.y));
}
float geVec2Ratio(GEVec2 self) {
    return self.x / self.y;
}
NSString* geVec2Description(GEVec2 self) {
    return [NSString stringWithFormat:@"vec2(%f, %f)", self.x, self.y];
}
BOOL geVec2IsEqualTo(GEVec2 self, GEVec2 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y);
}
NSUInteger geVec2Hash(GEVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    return hash;
}
CNPType* geVec2Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEVec2Wrap class] name:@"GEVec2" size:sizeof(GEVec2) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEVec2, ((GEVec2*)(data))[i]);
    }];
    return _ret;
}
@implementation GEVec2Wrap{
    GEVec2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEVec2)value {
    return [[GEVec2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEVec2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geVec2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec2Wrap* o = ((GEVec2Wrap*)(other));
    return geVec2IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geVec2Hash(_value);
}

- (NSInteger)compareTo:(GEVec2Wrap*)to {
    return geVec2CompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEVec2i geVec2iApplyVec2(GEVec2 vec2) {
    return GEVec2iMake(float4Round(vec2.x), float4Round(vec2.y));
}
GEVec2 geVec2iAddVec2(GEVec2i self, GEVec2 vec2) {
    return GEVec2Make(self.x + vec2.x, self.y + vec2.y);
}
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x + vec2i.x, self.y + vec2i.y);
}
GEVec2 geVec2iSubVec2(GEVec2i self, GEVec2 vec2) {
    return GEVec2Make(self.x - vec2.x, self.y - vec2.y);
}
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x - vec2i.x, self.y - vec2i.y);
}
GEVec2i geVec2iMulI(GEVec2i self, NSInteger i) {
    return GEVec2iMake(self.x * i, self.y * i);
}
GEVec2 geVec2iMulF(GEVec2i self, CGFloat f) {
    return GEVec2Make(((float)(self.x)) * f, ((float)(self.y)) * f);
}
GEVec2 geVec2iMulF4(GEVec2i self, float f4) {
    return GEVec2Make(((float)(self.x)) * f4, ((float)(self.y)) * f4);
}
GEVec2 geVec2iDivF4(GEVec2i self, float f4) {
    return GEVec2Make(((float)(self.x)) / f4, ((float)(self.y)) / f4);
}
GEVec2 geVec2iDivF(GEVec2i self, CGFloat f) {
    return GEVec2Make(((float)(self.x)) / f, ((float)(self.y)) / f);
}
GEVec2i geVec2iDivI(GEVec2i self, NSInteger i) {
    return GEVec2iMake(self.x / i, self.y / i);
}
GEVec2i geVec2iNegate(GEVec2i self) {
    return GEVec2iMake(-self.x, -self.y);
}
NSInteger geVec2iCompareTo(GEVec2i self, GEVec2i to) {
    NSInteger dX = intCompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompareTo(self.y, to.y);
}
GERectI geVec2iRectToVec2i(GEVec2i self, GEVec2i vec2i) {
    return GERectIMake(self, (geVec2iSubVec2i(vec2i, self)));
}
NSInteger geVec2iDotVec2i(GEVec2i self, GEVec2i vec2i) {
    return self.x * vec2i.x + self.y * vec2i.y;
}
NSInteger geVec2iLengthSquare(GEVec2i self) {
    return geVec2iDotVec2i(self, self);
}
float geVec2iLength(GEVec2i self) {
    return ((float)(sqrt(((CGFloat)(geVec2iLengthSquare(self))))));
}
float geVec2iRatio(GEVec2i self) {
    return ((float)(self.x)) / ((float)(self.y));
}
NSString* geVec2iDescription(GEVec2i self) {
    return [NSString stringWithFormat:@"vec2i(%ld, %ld)", (long)self.x, (long)self.y];
}
BOOL geVec2iIsEqualTo(GEVec2i self, GEVec2i to) {
    return self.x == to.x && self.y == to.y;
}
NSUInteger geVec2iHash(GEVec2i self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
CNPType* geVec2iType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEVec2iWrap class] name:@"GEVec2i" size:sizeof(GEVec2i) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEVec2i, ((GEVec2i*)(data))[i]);
    }];
    return _ret;
}
@implementation GEVec2iWrap{
    GEVec2i _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEVec2i)value {
    return [[GEVec2iWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEVec2i)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geVec2iDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec2iWrap* o = ((GEVec2iWrap*)(other));
    return geVec2iIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geVec2iHash(_value);
}

- (NSInteger)compareTo:(GEVec2iWrap*)to {
    return geVec2iCompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEVec3 geVec3ApplyVec2(GEVec2 vec2) {
    return GEVec3Make(vec2.x, vec2.y, 0.0);
}
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z) {
    return GEVec3Make(vec2.x, vec2.y, z);
}
GEVec3 geVec3ApplyVec2iZ(GEVec2i vec2i, float z) {
    return GEVec3Make(((float)(vec2i.x)), ((float)(vec2i.y)), z);
}
GEVec3 geVec3ApplyF4(float f4) {
    return GEVec3Make(f4, f4, f4);
}
GEVec3 geVec3ApplyF(CGFloat f) {
    return GEVec3Make(((float)(f)), ((float)(f)), ((float)(f)));
}
GEVec3 geVec3AddVec3(GEVec3 self, GEVec3 vec3) {
    return GEVec3Make(self.x + vec3.x, self.y + vec3.y, self.z + vec3.z);
}
GEVec3 geVec3SubVec3(GEVec3 self, GEVec3 vec3) {
    return GEVec3Make(self.x - vec3.x, self.y - vec3.y, self.z - vec3.z);
}
GEVec3 geVec3Sqr(GEVec3 self) {
    return geVec3MulK(self, ((float)(geVec3Length(self))));
}
GEVec3 geVec3Negate(GEVec3 self) {
    return GEVec3Make(-self.x, -self.y, -self.z);
}
GEVec3 geVec3MulK(GEVec3 self, float k) {
    return GEVec3Make(k * self.x, k * self.y, k * self.z);
}
float geVec3DotVec3(GEVec3 self, GEVec3 vec3) {
    return self.x * vec3.x + self.y * vec3.y + self.z * vec3.z;
}
GEVec3 geVec3CrossVec3(GEVec3 self, GEVec3 vec3) {
    return GEVec3Make(self.y * vec3.z - self.z * vec3.y, self.x * vec3.z - vec3.x * self.z, self.x * vec3.y - vec3.x * self.y);
}
float geVec3LengthSquare(GEVec3 self) {
    return self.x * self.x + self.y * self.y + self.z * self.z;
}
CGFloat geVec3Length(GEVec3 self) {
    return sqrt(((CGFloat)(geVec3LengthSquare(self))));
}
GEVec3 geVec3SetLength(GEVec3 self, float length) {
    return geVec3MulK(self, length / geVec3Length(self));
}
GEVec3 geVec3Normalize(GEVec3 self) {
    return geVec3SetLength(self, 1.0);
}
GEVec2 geVec3Xy(GEVec3 self) {
    return GEVec2Make(self.x, self.y);
}
GEVec3 geVec3Rnd() {
    return GEVec3Make(cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5, cnFloat4Rnd() - 0.5);
}
BOOL geVec3IsEmpty(GEVec3 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0) && eqf4(self.z, 0);
}
NSString* geVec3Description(GEVec3 self) {
    return [NSString stringWithFormat:@"vec3(%f, %f, %f)", self.x, self.y, self.z];
}
BOOL geVec3IsEqualTo(GEVec3 self, GEVec3 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && eqf4(self.z, to.z);
}
NSUInteger geVec3Hash(GEVec3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}
CNPType* geVec3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEVec3Wrap class] name:@"GEVec3" size:sizeof(GEVec3) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEVec3, ((GEVec3*)(data))[i]);
    }];
    return _ret;
}
@implementation GEVec3Wrap{
    GEVec3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEVec3)value {
    return [[GEVec3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEVec3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geVec3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec3Wrap* o = ((GEVec3Wrap*)(other));
    return geVec3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geVec3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEVec4 geVec4ApplyF(CGFloat f) {
    return GEVec4Make(((float)(f)), ((float)(f)), ((float)(f)), ((float)(f)));
}
GEVec4 geVec4ApplyF4(float f4) {
    return GEVec4Make(f4, f4, f4, f4);
}
GEVec4 geVec4ApplyVec3W(GEVec3 vec3, float w) {
    return GEVec4Make(vec3.x, vec3.y, vec3.z, w);
}
GEVec4 geVec4ApplyVec2ZW(GEVec2 vec2, float z, float w) {
    return GEVec4Make(vec2.x, vec2.y, z, w);
}
GEVec4 geVec4AddVec2(GEVec4 self, GEVec2 vec2) {
    return GEVec4Make(self.x + vec2.x, self.y + vec2.y, self.z, self.w);
}
GEVec4 geVec4AddVec3(GEVec4 self, GEVec3 vec3) {
    return GEVec4Make(self.x + vec3.x, self.y + vec3.y, self.z + vec3.z, self.w);
}
GEVec4 geVec4AddVec4(GEVec4 self, GEVec4 vec4) {
    return GEVec4Make(self.x + vec4.x, self.y + vec4.y, self.z + vec4.z, self.w + vec4.w);
}
GEVec3 geVec4Xyz(GEVec4 self) {
    return GEVec3Make(self.x, self.y, self.z);
}
GEVec2 geVec4Xy(GEVec4 self) {
    return GEVec2Make(self.x, self.y);
}
GEVec4 geVec4MulK(GEVec4 self, float k) {
    return GEVec4Make(k * self.x, k * self.y, k * self.z, k * self.w);
}
GEVec4 geVec4DivMat4(GEVec4 self, GEMat4* mat4) {
    return [mat4 divBySelfVec4:self];
}
GEVec4 geVec4DivF4(GEVec4 self, float f4) {
    return GEVec4Make(self.x / f4, self.y / f4, self.z / f4, self.w / f4);
}
GEVec4 geVec4DivF(GEVec4 self, CGFloat f) {
    return GEVec4Make(self.x / f, self.y / f, self.z / f, self.w / f);
}
GEVec4 geVec4DivI(GEVec4 self, NSInteger i) {
    return GEVec4Make(self.x / i, self.y / i, self.z / i, self.w / i);
}
float geVec4LengthSquare(GEVec4 self) {
    return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
}
CGFloat geVec4Length(GEVec4 self) {
    return sqrt(((CGFloat)(geVec4LengthSquare(self))));
}
GEVec4 geVec4SetLength(GEVec4 self, float length) {
    return geVec4MulK(self, length / geVec4Length(self));
}
GEVec4 geVec4Normalize(GEVec4 self) {
    return geVec4SetLength(self, 1.0);
}
NSString* geVec4Description(GEVec4 self) {
    return [NSString stringWithFormat:@"vec4(%f, %f, %f, %f)", self.x, self.y, self.z, self.w];
}
BOOL geVec4IsEqualTo(GEVec4 self, GEVec4 to) {
    return eqf4(self.x, to.x) && eqf4(self.y, to.y) && eqf4(self.z, to.z) && eqf4(self.w, to.w);
}
NSUInteger geVec4Hash(GEVec4 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.w);
    return hash;
}
CNPType* geVec4Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEVec4Wrap class] name:@"GEVec4" size:sizeof(GEVec4) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEVec4, ((GEVec4*)(data))[i]);
    }];
    return _ret;
}
@implementation GEVec4Wrap{
    GEVec4 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEVec4)value {
    return [[GEVec4Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEVec4)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geVec4Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec4Wrap* o = ((GEVec4Wrap*)(other));
    return geVec4IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geVec4Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


BOOL geTriangleContainsVec2(GETriangle self, GEVec2 vec2) {
    GEVec2 r0 = geVec2SubVec2(self.p0, vec2);
    GEVec2 r1 = geVec2SubVec2(self.p1, vec2);
    GEVec2 r2 = geVec2SubVec2(self.p2, vec2);
    float c0 = geVec2CrossVec2(r0, r1);
    float c1 = geVec2CrossVec2(r1, r2);
    float c2 = geVec2CrossVec2(r2, r0);
    return (c0 > 0 && c1 > 0 && c2 > 0) || (c0 < 0 && c1 < 0 && c2 < 0);
}
NSString* geTriangleDescription(GETriangle self) {
    return [NSString stringWithFormat:@"Triangle(%@, %@, %@)", geVec2Description(self.p0), geVec2Description(self.p1), geVec2Description(self.p2)];
}
BOOL geTriangleIsEqualTo(GETriangle self, GETriangle to) {
    return geVec2IsEqualTo(self.p0, to.p0) && geVec2IsEqualTo(self.p1, to.p1) && geVec2IsEqualTo(self.p2, to.p2);
}
NSUInteger geTriangleHash(GETriangle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.p0);
    hash = hash * 31 + geVec2Hash(self.p1);
    hash = hash * 31 + geVec2Hash(self.p2);
    return hash;
}
CNPType* geTriangleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GETriangleWrap class] name:@"GETriangle" size:sizeof(GETriangle) wrap:^id(void* data, NSUInteger i) {
        return wrap(GETriangle, ((GETriangle*)(data))[i]);
    }];
    return _ret;
}
@implementation GETriangleWrap{
    GETriangle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GETriangle)value {
    return [[GETriangleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GETriangle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geTriangleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GETriangleWrap* o = ((GETriangleWrap*)(other));
    return geTriangleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geTriangleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEQuad geQuadApplySize(float size) {
    return GEQuadMake((GEVec2Make(-size, -size)), (GEVec2Make(size, -size)), (GEVec2Make(size, size)), (GEVec2Make(-size, size)));
}
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2) {
    return GEQuadMake((geVec2AddVec2(self.p0, vec2)), (geVec2AddVec2(self.p1, vec2)), (geVec2AddVec2(self.p2, vec2)), (geVec2AddVec2(self.p3, vec2)));
}
GEQuad geQuadAddXY(GEQuad self, float x, float y) {
    return geQuadAddVec2(self, (GEVec2Make(x, y)));
}
GEQuad geQuadMulValue(GEQuad self, float value) {
    return GEQuadMake((geVec2MulF4(self.p0, value)), (geVec2MulF4(self.p1, value)), (geVec2MulF4(self.p2, value)), (geVec2MulF4(self.p3, value)));
}
GEQuad geQuadMulMat3(GEQuad self, GEMat3* mat3) {
    return GEQuadMake([mat3 mulVec2:self.p0], [mat3 mulVec2:self.p1], [mat3 mulVec2:self.p2], [mat3 mulVec2:self.p3]);
}
GEQuadrant geQuadQuadrant(GEQuad self) {
    float x = (self.p1.x - self.p0.x) / 2;
    float y = (self.p3.y - self.p0.y) / 2;
    GEQuad q = geQuadAddVec2((geQuadMulValue(self, 0.5)), self.p0);
    return GEQuadrantMake(((GEQuad[]){q, geQuadAddXY(q, x, 0.0), geQuadAddXY(q, x, y), geQuadAddXY(q, 0.0, y)}));
}
GEVec2 geQuadApplyIndex(GEQuad self, NSUInteger index) {
    if(index == 0) {
        return self.p0;
    } else {
        if(index == 1) {
            return self.p1;
        } else {
            if(index == 2) {
                return self.p2;
            } else {
                if(index == 3) return self.p3;
                else @throw @"Incorrect quad index";
            }
        }
    }
}
GERect geQuadBoundingRect(GEQuad self) {
    CGFloat minX = cnFloatMax();
    CGFloat maxX = cnFloatMin();
    CGFloat minY = cnFloatMax();
    CGFloat maxY = cnFloatMin();
    NSInteger i = 0;
    while(i < 4) {
        GEVec2 pp = geQuadApplyIndex(self, ((NSUInteger)(i)));
        if(pp.x < minX) minX = ((CGFloat)(pp.x));
        if(pp.x > maxX) maxX = ((CGFloat)(pp.x));
        if(pp.y < minY) minY = ((CGFloat)(pp.y));
        if(pp.y > maxY) maxY = ((CGFloat)(pp.y));
        i++;
    }
    return geVec2RectToVec2((GEVec2Make(((float)(minX)), ((float)(minY)))), (GEVec2Make(((float)(maxX)), ((float)(maxY)))));
}
NSArray* geQuadLines(GEQuad self) {
    return (@[wrap(GELine2, (geLine2ApplyP0P1(self.p0, self.p1))), wrap(GELine2, (geLine2ApplyP0P1(self.p1, self.p2))), wrap(GELine2, (geLine2ApplyP0P1(self.p2, self.p3))), wrap(GELine2, (geLine2ApplyP0P1(self.p3, self.p0)))]);
}
NSArray* geQuadPs(GEQuad self) {
    return (@[wrap(GEVec2, self.p0), wrap(GEVec2, self.p1), wrap(GEVec2, self.p2), wrap(GEVec2, self.p3)]);
}
GEVec2 geQuadClosestPointForVec2(GEQuad self, GEVec2 vec2) {
    if(geQuadContainsVec2(self, vec2)) {
        return vec2;
    } else {
        NSArray* projs = [[[geQuadLines(self) chain] mapOptF:^id(id _) {
            return geLine2ProjectionOnSegmentVec2((uwrap(GELine2, _)), vec2);
        }] toArray];
        if([projs isEmpty]) projs = geQuadPs(self);
        {
            id __tmp_0f_2 = [[[[[projs chain] sortBy] ascBy:^id(id _) {
                return numf4((geVec2LengthSquare((geVec2SubVec2((uwrap(GEVec2, _)), vec2)))));
            }] endSort] head];
            if(__tmp_0f_2 != nil) return uwrap(GEVec2, __tmp_0f_2);
            else return self.p0;
        }
    }
}
BOOL geQuadContainsVec2(GEQuad self, GEVec2 vec2) {
    return geRectContainsVec2(geQuadBoundingRect(self), vec2) && (geTriangleContainsVec2((GETriangleMake(self.p0, self.p1, self.p2)), vec2) || geTriangleContainsVec2((GETriangleMake(self.p2, self.p3, self.p0)), vec2));
}
GEQuad geQuadMapF(GEQuad self, GEVec2(^f)(GEVec2)) {
    return GEQuadMake(f(self.p0), f(self.p1), f(self.p2), f(self.p3));
}
GEVec2 geQuadCenter(GEQuad self) {
    id __tmp;
    {
        id __tmp_e1 = geLine2CrossPointLine2((geLine2ApplyP0P1(self.p0, self.p2)), (geLine2ApplyP0P1(self.p1, self.p3)));
        if(__tmp_e1 != nil) __tmp = __tmp_e1;
        else __tmp = geLine2CrossPointLine2((geLine2ApplyP0P1(self.p0, self.p1)), (geLine2ApplyP0P1(self.p2, self.p3)));
    }
    if(__tmp != nil) return uwrap(GEVec2, __tmp);
    else return self.p0;
}
NSString* geQuadDescription(GEQuad self) {
    return [NSString stringWithFormat:@"Quad(%@, %@, %@, %@)", geVec2Description(self.p0), geVec2Description(self.p1), geVec2Description(self.p2), geVec2Description(self.p3)];
}
BOOL geQuadIsEqualTo(GEQuad self, GEQuad to) {
    return geVec2IsEqualTo(self.p0, to.p0) && geVec2IsEqualTo(self.p1, to.p1) && geVec2IsEqualTo(self.p2, to.p2) && geVec2IsEqualTo(self.p3, to.p3);
}
NSUInteger geQuadHash(GEQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.p0);
    hash = hash * 31 + geVec2Hash(self.p1);
    hash = hash * 31 + geVec2Hash(self.p2);
    hash = hash * 31 + geVec2Hash(self.p3);
    return hash;
}
GEQuad geQuadIdentity() {
    static GEQuad _ret = (GEQuad){{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}};
    return _ret;
}
CNPType* geQuadType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEQuadWrap class] name:@"GEQuad" size:sizeof(GEQuad) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEQuad, ((GEQuad*)(data))[i]);
    }];
    return _ret;
}
@implementation GEQuadWrap{
    GEQuad _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEQuad)value {
    return [[GEQuadWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEQuad)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geQuadDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuadWrap* o = ((GEQuadWrap*)(other));
    return geQuadIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geQuadHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEQuad geQuadrantRndQuad(GEQuadrant self) {
    return self.quads[cnuIntRndMax(3)];
}
NSString* geQuadrantDescription(GEQuadrant self) {
    return [NSString stringWithFormat:@"Quadrant([%@, %@, %@, %@])", geQuadDescription(self.quads[0]), geQuadDescription(self.quads[1]), geQuadDescription(self.quads[2]), geQuadDescription(self.quads[3])];
}
BOOL geQuadrantIsEqualTo(GEQuadrant self, GEQuadrant to) {
    return self.quads == to.quads;
}
NSUInteger geQuadrantHash(GEQuadrant self) {
    NSUInteger hash = 0;
    hash = hash * 31 + 13 * (13 * (13 * geQuadHash(self.quads[0]) + geQuadHash(self.quads[1])) + geQuadHash(self.quads[2])) + geQuadHash(self.quads[3]);
    return hash;
}
CNPType* geQuadrantType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEQuadrantWrap class] name:@"GEQuadrant" size:sizeof(GEQuadrant) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEQuadrant, ((GEQuadrant*)(data))[i]);
    }];
    return _ret;
}
@implementation GEQuadrantWrap{
    GEQuadrant _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEQuadrant)value {
    return [[GEQuadrantWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEQuadrant)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geQuadrantDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuadrantWrap* o = ((GEQuadrantWrap*)(other));
    return geQuadrantIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geQuadrantHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GERect geRectApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectMake((GEVec2Make(x, y)), (GEVec2Make(width, height)));
}
GERect geRectApplyXYSize(float x, float y, GEVec2 size) {
    return GERectMake((GEVec2Make(x, y)), size);
}
GERect geRectApplyRectI(GERectI rectI) {
    return GERectMake(geVec2ApplyVec2i(rectI.p), geVec2ApplyVec2i(rectI.size));
}
float geRectX(GERect self) {
    return self.p.x;
}
float geRectY(GERect self) {
    return self.p.y;
}
float geRectX2(GERect self) {
    return self.p.x + self.size.x;
}
float geRectY2(GERect self) {
    return self.p.y + self.size.y;
}
float geRectWidth(GERect self) {
    return self.size.x;
}
float geRectHeight(GERect self) {
    return self.size.y;
}
BOOL geRectContainsVec2(GERect self, GEVec2 vec2) {
    return self.p.x <= vec2.x && vec2.x <= self.p.x + self.size.x && self.p.y <= vec2.y && vec2.y <= self.p.y + self.size.y;
}
GERect geRectAddVec2(GERect self, GEVec2 vec2) {
    return GERectMake((geVec2AddVec2(self.p, vec2)), self.size);
}
GERect geRectSubVec2(GERect self, GEVec2 vec2) {
    return GERectMake((geVec2SubVec2(self.p, vec2)), self.size);
}
GERect geRectMulF(GERect self, CGFloat f) {
    return GERectMake((geVec2MulF(self.p, f)), (geVec2MulF(self.size, f)));
}
GERect geRectMulVec2(GERect self, GEVec2 vec2) {
    return GERectMake((geVec2MulVec2(self.p, vec2)), (geVec2MulVec2(self.size, vec2)));
}
BOOL geRectIntersectsRect(GERect self, GERect rect) {
    return self.p.x <= geRectX2(rect) && geRectX2(self) >= rect.p.x && self.p.y <= geRectY2(rect) && geRectY2(self) >= rect.p.y;
}
GERect geRectThickenHalfSize(GERect self, GEVec2 halfSize) {
    return GERectMake((geVec2SubVec2(self.p, halfSize)), (geVec2AddVec2(self.size, (geVec2MulI(halfSize, 2)))));
}
GERect geRectDivVec2(GERect self, GEVec2 vec2) {
    return GERectMake((geVec2DivVec2(self.p, vec2)), (geVec2DivVec2(self.size, vec2)));
}
GERect geRectDivF(GERect self, CGFloat f) {
    return GERectMake((geVec2DivF(self.p, f)), (geVec2DivF(self.size, f)));
}
GERect geRectDivF4(GERect self, float f4) {
    return GERectMake((geVec2DivF4(self.p, f4)), (geVec2DivF4(self.size, f4)));
}
GEVec2 geRectPh(GERect self) {
    return GEVec2Make(self.p.x, self.p.y + self.size.y);
}
GEVec2 geRectPw(GERect self) {
    return GEVec2Make(self.p.x + self.size.x, self.p.y);
}
GEVec2 geRectPhw(GERect self) {
    return GEVec2Make(self.p.x + self.size.x, self.p.y + self.size.y);
}
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size) {
    return GERectMake((geVec2MulF((geVec2SubVec2(size, self.size)), 0.5)), self.size);
}
GEQuad geRectQuad(GERect self) {
    return GEQuadMake(self.p, geRectPh(self), geRectPhw(self), geRectPw(self));
}
GEQuad geRectStripQuad(GERect self) {
    return GEQuadMake(self.p, geRectPh(self), geRectPw(self), geRectPhw(self));
}
GEQuad geRectUpsideDownStripQuad(GERect self) {
    return GEQuadMake(geRectPh(self), self.p, geRectPhw(self), geRectPw(self));
}
GERect geRectCenterX(GERect self) {
    return GERectMake((GEVec2Make(self.p.x - self.size.x / 2, self.p.y)), self.size);
}
GERect geRectCenterY(GERect self) {
    return GERectMake((GEVec2Make(self.p.x, self.p.y - self.size.y / 2)), self.size);
}
GEVec2 geRectCenter(GERect self) {
    return geVec2AddVec2(self.p, (geVec2DivI(self.size, 2)));
}
GEVec2 geRectClosestPointForVec2(GERect self, GEVec2 vec2) {
    return geVec2MaxVec2((geVec2MinVec2(vec2, geRectPhw(self))), self.p);
}
GEVec2 geRectPXY(GERect self, float x, float y) {
    return GEVec2Make(self.p.x + self.size.x * x, self.p.y + self.size.y * y);
}
NSString* geRectDescription(GERect self) {
    return [NSString stringWithFormat:@"Rect(%@, %@)", geVec2Description(self.p), geVec2Description(self.size)];
}
BOOL geRectIsEqualTo(GERect self, GERect to) {
    return geVec2IsEqualTo(self.p, to.p) && geVec2IsEqualTo(self.size, to.size);
}
NSUInteger geRectHash(GERect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.p);
    hash = hash * 31 + geVec2Hash(self.size);
    return hash;
}
CNPType* geRectType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GERectWrap class] name:@"GERect" size:sizeof(GERect) wrap:^id(void* data, NSUInteger i) {
        return wrap(GERect, ((GERect*)(data))[i]);
    }];
    return _ret;
}
@implementation GERectWrap{
    GERect _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GERect)value {
    return [[GERectWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GERect)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geRectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectWrap* o = ((GERectWrap*)(other));
    return geRectIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geRectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GERectI geRectIApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectIMake((geVec2iApplyVec2((GEVec2Make(x, y)))), (geVec2iApplyVec2((GEVec2Make(width, height)))));
}
GERectI geRectIApplyRect(GERect rect) {
    return GERectIMake(geVec2iApplyVec2(rect.p), geVec2iApplyVec2(rect.size));
}
NSInteger geRectIX(GERectI self) {
    return self.p.x;
}
NSInteger geRectIY(GERectI self) {
    return self.p.y;
}
NSInteger geRectIX2(GERectI self) {
    return self.p.x + self.size.x;
}
NSInteger geRectIY2(GERectI self) {
    return self.p.y + self.size.y;
}
NSInteger geRectIWidth(GERectI self) {
    return self.size.x;
}
NSInteger geRectIHeight(GERectI self) {
    return self.size.y;
}
GERectI geRectIMoveToCenterForSize(GERectI self, GEVec2 size) {
    return GERectIMake((geVec2iApplyVec2((geVec2MulF((geVec2SubVec2(size, geVec2ApplyVec2i(self.size))), 0.5)))), self.size);
}
NSString* geRectIDescription(GERectI self) {
    return [NSString stringWithFormat:@"RectI(%@, %@)", geVec2iDescription(self.p), geVec2iDescription(self.size)];
}
BOOL geRectIIsEqualTo(GERectI self, GERectI to) {
    return geVec2iIsEqualTo(self.p, to.p) && geVec2iIsEqualTo(self.size, to.size);
}
NSUInteger geRectIHash(GERectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2iHash(self.p);
    hash = hash * 31 + geVec2iHash(self.size);
    return hash;
}
CNPType* geRectIType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GERectIWrap class] name:@"GERectI" size:sizeof(GERectI) wrap:^id(void* data, NSUInteger i) {
        return wrap(GERectI, ((GERectI*)(data))[i]);
    }];
    return _ret;
}
@implementation GERectIWrap{
    GERectI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GERectI)value {
    return [[GERectIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GERectI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geRectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectIWrap* o = ((GERectIWrap*)(other));
    return geRectIIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geRectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GELine2 geLine2ApplyP0P1(GEVec2 p0, GEVec2 p1) {
    return GELine2Make(p0, (geVec2SubVec2(p1, p0)));
}
GEVec2 geLine2RT(GELine2 self, float t) {
    return geVec2AddVec2(self.p0, (geVec2MulF4(self.u, t)));
}
id geLine2CrossPointLine2(GELine2 self, GELine2 line2) {
    float dot = geVec2DotVec2(geLine2N(line2), self.u);
    if(eqf4(dot, 0)) return nil;
    else return wrap(GEVec2, (geVec2AddVec2(self.p0, (geVec2MulF4(self.u, (geVec2DotVec2(geLine2N(line2), (geVec2SubVec2(line2.p0, self.p0))) / dot))))));
}
float geLine2Angle(GELine2 self) {
    return geVec2Angle(self.u);
}
float geLine2DegreeAngle(GELine2 self) {
    return geVec2DegreeAngle(self.u);
}
GELine2 geLine2SetLength(GELine2 self, float length) {
    return GELine2Make(self.p0, (geVec2SetLength(self.u, length)));
}
GELine2 geLine2Normalize(GELine2 self) {
    return GELine2Make(self.p0, geVec2Normalize(self.u));
}
GEVec2 geLine2Mid(GELine2 self) {
    return geVec2AddVec2(self.p0, (geVec2DivI(self.u, 2)));
}
GEVec2 geLine2P1(GELine2 self) {
    return geVec2AddVec2(self.p0, self.u);
}
GELine2 geLine2AddVec2(GELine2 self, GEVec2 vec2) {
    return GELine2Make((geVec2AddVec2(self.p0, vec2)), self.u);
}
GELine2 geLine2SubVec2(GELine2 self, GEVec2 vec2) {
    return GELine2Make((geVec2SubVec2(self.p0, vec2)), self.u);
}
GEVec2 geLine2N(GELine2 self) {
    return geVec2Normalize((GEVec2Make(-self.u.y, self.u.x)));
}
GEVec2 geLine2ProjectionVec2(GELine2 self, GEVec2 vec2) {
    return uwrap(GEVec2, (nonnil((geLine2CrossPointLine2(self, (GELine2Make(vec2, geLine2N(self))))))));
}
id geLine2ProjectionOnSegmentVec2(GELine2 self, GEVec2 vec2) {
    id p = geLine2CrossPointLine2(self, (GELine2Make(vec2, geLine2N(self))));
    if(p != nil) {
        if(geRectContainsVec2(geLine2BoundingRect(self), (uwrap(GEVec2, p)))) return ((id)(p));
        else return nil;
    } else {
        return nil;
    }
}
GERect geLine2BoundingRect(GELine2 self) {
    return geRectApplyXYSize(((self.u.x > 0) ? self.p0.x : self.p0.x + self.u.x), ((self.u.y > 0) ? self.p0.y : self.p0.y + self.u.y), geVec2Abs(self.u));
}
GELine2 geLine2Positive(GELine2 self) {
    if(self.u.x < 0 || (eqf4(self.u.x, 0) && self.u.y < 0)) return GELine2Make(geLine2P1(self), geVec2Negate(self.u));
    else return self;
}
NSString* geLine2Description(GELine2 self) {
    return [NSString stringWithFormat:@"Line2(%@, %@)", geVec2Description(self.p0), geVec2Description(self.u)];
}
BOOL geLine2IsEqualTo(GELine2 self, GELine2 to) {
    return geVec2IsEqualTo(self.p0, to.p0) && geVec2IsEqualTo(self.u, to.u);
}
NSUInteger geLine2Hash(GELine2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.p0);
    hash = hash * 31 + geVec2Hash(self.u);
    return hash;
}
CNPType* geLine2Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GELine2Wrap class] name:@"GELine2" size:sizeof(GELine2) wrap:^id(void* data, NSUInteger i) {
        return wrap(GELine2, ((GELine2*)(data))[i]);
    }];
    return _ret;
}
@implementation GELine2Wrap{
    GELine2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GELine2)value {
    return [[GELine2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GELine2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geLine2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GELine2Wrap* o = ((GELine2Wrap*)(other));
    return geLine2IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geLine2Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEVec3 geLine3RT(GELine3 self, float t) {
    return geVec3AddVec3(self.r0, (geVec3MulK(self.u, t)));
}
GEVec3 geLine3RPlane(GELine3 self, GEPlane plane) {
    return geVec3AddVec3(self.r0, (geVec3MulK(self.u, (geVec3DotVec3(plane.n, (geVec3SubVec3(plane.p0, self.r0))) / geVec3DotVec3(plane.n, self.u)))));
}
NSString* geLine3Description(GELine3 self) {
    return [NSString stringWithFormat:@"Line3(%@, %@)", geVec3Description(self.r0), geVec3Description(self.u)];
}
BOOL geLine3IsEqualTo(GELine3 self, GELine3 to) {
    return geVec3IsEqualTo(self.r0, to.r0) && geVec3IsEqualTo(self.u, to.u);
}
NSUInteger geLine3Hash(GELine3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.r0);
    hash = hash * 31 + geVec3Hash(self.u);
    return hash;
}
CNPType* geLine3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GELine3Wrap class] name:@"GELine3" size:sizeof(GELine3) wrap:^id(void* data, NSUInteger i) {
        return wrap(GELine3, ((GELine3*)(data))[i]);
    }];
    return _ret;
}
@implementation GELine3Wrap{
    GELine3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GELine3)value {
    return [[GELine3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GELine3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geLine3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GELine3Wrap* o = ((GELine3Wrap*)(other));
    return geLine3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geLine3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


BOOL gePlaneContainsVec3(GEPlane self, GEVec3 vec3) {
    return eqf4((geVec3DotVec3(self.n, (geVec3SubVec3(vec3, self.p0)))), 0);
}
GEPlane gePlaneAddVec3(GEPlane self, GEVec3 vec3) {
    return GEPlaneMake((geVec3AddVec3(self.p0, vec3)), self.n);
}
GEPlane gePlaneMulMat4(GEPlane self, GEMat4* mat4) {
    return GEPlaneMake([mat4 mulVec3:self.p0], geVec4Xyz([mat4 mulVec3:self.n w:0.0]));
}
NSString* gePlaneDescription(GEPlane self) {
    return [NSString stringWithFormat:@"Plane(%@, %@)", geVec3Description(self.p0), geVec3Description(self.n)];
}
BOOL gePlaneIsEqualTo(GEPlane self, GEPlane to) {
    return geVec3IsEqualTo(self.p0, to.p0) && geVec3IsEqualTo(self.n, to.n);
}
NSUInteger gePlaneHash(GEPlane self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec3Hash(self.p0);
    hash = hash * 31 + geVec3Hash(self.n);
    return hash;
}
CNPType* gePlaneType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEPlaneWrap class] name:@"GEPlane" size:sizeof(GEPlane) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEPlane, ((GEPlane*)(data))[i]);
    }];
    return _ret;
}
@implementation GEPlaneWrap{
    GEPlane _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEPlane)value {
    return [[GEPlaneWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEPlane)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return gePlaneDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPlaneWrap* o = ((GEPlaneWrap*)(other));
    return gePlaneIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return gePlaneHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEPlaneCoord gePlaneCoordApplyPlaneX(GEPlane plane, GEVec3 x) {
    return GEPlaneCoordMake(plane, x, (geVec3CrossVec3(x, plane.n)));
}
GEVec3 gePlaneCoordPVec2(GEPlaneCoord self, GEVec2 vec2) {
    return geVec3AddVec3((geVec3AddVec3(self.plane.p0, (geVec3MulK(self.x, vec2.x)))), (geVec3MulK(self.y, vec2.y)));
}
GEPlaneCoord gePlaneCoordAddVec3(GEPlaneCoord self, GEVec3 vec3) {
    return GEPlaneCoordMake((gePlaneAddVec3(self.plane, vec3)), self.x, self.y);
}
GEPlaneCoord gePlaneCoordSetX(GEPlaneCoord self, GEVec3 x) {
    return GEPlaneCoordMake(self.plane, x, self.y);
}
GEPlaneCoord gePlaneCoordSetY(GEPlaneCoord self, GEVec3 y) {
    return GEPlaneCoordMake(self.plane, self.x, y);
}
GEPlaneCoord gePlaneCoordMulMat4(GEPlaneCoord self, GEMat4* mat4) {
    return GEPlaneCoordMake((gePlaneMulMat4(self.plane, mat4)), [mat4 mulVec3:self.x], [mat4 mulVec3:self.y]);
}
NSString* gePlaneCoordDescription(GEPlaneCoord self) {
    return [NSString stringWithFormat:@"PlaneCoord(%@, %@, %@)", gePlaneDescription(self.plane), geVec3Description(self.x), geVec3Description(self.y)];
}
BOOL gePlaneCoordIsEqualTo(GEPlaneCoord self, GEPlaneCoord to) {
    return gePlaneIsEqualTo(self.plane, to.plane) && geVec3IsEqualTo(self.x, to.x) && geVec3IsEqualTo(self.y, to.y);
}
NSUInteger gePlaneCoordHash(GEPlaneCoord self) {
    NSUInteger hash = 0;
    hash = hash * 31 + gePlaneHash(self.plane);
    hash = hash * 31 + geVec3Hash(self.x);
    hash = hash * 31 + geVec3Hash(self.y);
    return hash;
}
CNPType* gePlaneCoordType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEPlaneCoordWrap class] name:@"GEPlaneCoord" size:sizeof(GEPlaneCoord) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEPlaneCoord, ((GEPlaneCoord*)(data))[i]);
    }];
    return _ret;
}
@implementation GEPlaneCoordWrap{
    GEPlaneCoord _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEPlaneCoord)value {
    return [[GEPlaneCoordWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEPlaneCoord)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return gePlaneCoordDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPlaneCoordWrap* o = ((GEPlaneCoordWrap*)(other));
    return gePlaneCoordIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return gePlaneCoordHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


GEVec3 geQuad3P0(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p0);
}
GEVec3 geQuad3P1(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p1);
}
GEVec3 geQuad3P2(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p2);
}
GEVec3 geQuad3P3(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p3);
}
NSArray* geQuad3Ps(GEQuad3 self) {
    return (@[wrap(GEVec3, geQuad3P0(self)), wrap(GEVec3, geQuad3P1(self)), wrap(GEVec3, geQuad3P2(self)), wrap(GEVec3, geQuad3P3(self))]);
}
GEQuad3 geQuad3MulMat4(GEQuad3 self, GEMat4* mat4) {
    return GEQuad3Make((gePlaneCoordMulMat4(self.planeCoord, mat4)), self.quad);
}
NSString* geQuad3Description(GEQuad3 self) {
    return [NSString stringWithFormat:@"Quad3(%@, %@)", gePlaneCoordDescription(self.planeCoord), geQuadDescription(self.quad)];
}
BOOL geQuad3IsEqualTo(GEQuad3 self, GEQuad3 to) {
    return gePlaneCoordIsEqualTo(self.planeCoord, to.planeCoord) && geQuadIsEqualTo(self.quad, to.quad);
}
NSUInteger geQuad3Hash(GEQuad3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + gePlaneCoordHash(self.planeCoord);
    hash = hash * 31 + geQuadHash(self.quad);
    return hash;
}
CNPType* geQuad3Type() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[GEQuad3Wrap class] name:@"GEQuad3" size:sizeof(GEQuad3) wrap:^id(void* data, NSUInteger i) {
        return wrap(GEQuad3, ((GEQuad3*)(data))[i]);
    }];
    return _ret;
}
@implementation GEQuad3Wrap{
    GEQuad3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GEQuad3)value {
    return [[GEQuad3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(GEQuad3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return geQuad3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuad3Wrap* o = ((GEQuad3Wrap*)(other));
    return geQuad3IsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return geQuad3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


