#import "GEVec.h"

#import "GEMat4.h"
NSString* GEVec2Description(GEVec2 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec2: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendString:@">"];
    return description;
}
GEVec2 geVec2ApplyVec2i(GEVec2i vec2i) {
    return GEVec2Make(((float)(vec2i.x)), ((float)(vec2i.y)));
}
GEVec2 geVec2Min() {
    return GEVec2Make(odFloat4Min(), odFloat4Min());
}
GEVec2 geVec2Max() {
    return GEVec2Make(odFloat4Max(), odFloat4Max());
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
float geVec2LengthSquare(GEVec2 self) {
    return geVec2DotVec2(self, self);
}
float geVec2Length(GEVec2 self) {
    return ((float)(sqrt(((CGFloat)(geVec2LengthSquare(self))))));
}
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2MulF(geVec2AddVec2(self, vec2), 0.5);
}
float geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2Length(geVec2SubVec2(self, vec2));
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
    return GERectMake(self, geVec2SubVec2(vec2, self));
}
GERect geVec2RectInCenterWithSize(GEVec2 self, GEVec2 size) {
    return GERectMake(geVec2MulF(geVec2SubVec2(size, self), 0.5), self);
}
GEVec2 geVec2Rnd() {
    return GEVec2Make(odFloat4Rnd() - 0.5, odFloat4Rnd() - 0.5);
}
BOOL geVec2IsEmpty(GEVec2 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0);
}
GEVec2i geVec2Round(GEVec2 self) {
    return GEVec2iMake(float4Round(self.x), float4Round(self.y));
}
GEVec2 geVec2MinVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(float4MinB(self.x, vec2.x), float4MinB(self.y, vec2.y));
}
GEVec2 geVec2MaxVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(float4MaxB(self.x, vec2.x), float4MaxB(self.y, vec2.y));
}
GEVec2 geVec2Abs(GEVec2 self) {
    return GEVec2Make(float4Abs(self.x), float4Abs(self.y));
}
ODPType* geVec2Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEVec2Wrap class] name:@"GEVec2" size:sizeof(GEVec2) wrap:^id(void* data, NSUInteger i) {
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
    return GEVec2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec2Wrap* o = ((GEVec2Wrap*)(other));
    return GEVec2Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GEVec2Hash(_value);
}

- (NSInteger)compareTo:(GEVec2Wrap*)to {
    return geVec2CompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEVec2iDescription(GEVec2i self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec2i: "];
    [description appendFormat:@"x=%ld", (long)self.x];
    [description appendFormat:@", y=%ld", (long)self.y];
    [description appendString:@">"];
    return description;
}
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
    return GERectIMake(self, geVec2iSubVec2i(vec2i, self));
}
ODPType* geVec2iType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEVec2iWrap class] name:@"GEVec2i" size:sizeof(GEVec2i) wrap:^id(void* data, NSUInteger i) {
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
    return GEVec2iDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec2iWrap* o = ((GEVec2iWrap*)(other));
    return GEVec2iEq(_value, o.value);
}

- (NSUInteger)hash {
    return GEVec2iHash(_value);
}

- (NSInteger)compareTo:(GEVec2iWrap*)to {
    return geVec2iCompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEVec3Description(GEVec3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec3: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}
GEVec3 geVec3ApplyVec2(GEVec2 vec2) {
    return GEVec3Make(vec2.x, vec2.y, 0.0);
}
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z) {
    return GEVec3Make(vec2.x, vec2.y, z);
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
    return GEVec3Make(odFloat4Rnd() - 0.5, odFloat4Rnd() - 0.5, odFloat4Rnd() - 0.5);
}
BOOL geVec3IsEmpty(GEVec3 self) {
    return eqf4(self.x, 0) && eqf4(self.y, 0) && eqf4(self.z, 0);
}
ODPType* geVec3Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEVec3Wrap class] name:@"GEVec3" size:sizeof(GEVec3) wrap:^id(void* data, NSUInteger i) {
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
    return GEVec3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec3Wrap* o = ((GEVec3Wrap*)(other));
    return GEVec3Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GEVec3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEVec4Description(GEVec4 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec4: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendFormat:@", w=%f", self.w];
    [description appendString:@">"];
    return description;
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
ODPType* geVec4Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEVec4Wrap class] name:@"GEVec4" size:sizeof(GEVec4) wrap:^id(void* data, NSUInteger i) {
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
    return GEVec4Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEVec4Wrap* o = ((GEVec4Wrap*)(other));
    return GEVec4Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GEVec4Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEQuadDescription(GEQuad self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEQuad: "];
    [description appendFormat:@"p0=%@", GEVec2Description(self.p0)];
    [description appendFormat:@", p1=%@", GEVec2Description(self.p1)];
    [description appendFormat:@", p2=%@", GEVec2Description(self.p2)];
    [description appendFormat:@", p3=%@", GEVec2Description(self.p3)];
    [description appendString:@">"];
    return description;
}
GEQuad geQuadApplySize(float size) {
    return GEQuadMake(GEVec2Make(-size, -size), GEVec2Make(size, -size), GEVec2Make(size, size), GEVec2Make(-size, size));
}
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2) {
    return GEQuadMake(geVec2AddVec2(self.p0, vec2), geVec2AddVec2(self.p1, vec2), geVec2AddVec2(self.p2, vec2), geVec2AddVec2(self.p3, vec2));
}
GEQuad geQuadAddXY(GEQuad self, float x, float y) {
    return geQuadAddVec2(self, GEVec2Make(x, y));
}
GEQuad geQuadMulValue(GEQuad self, float value) {
    return GEQuadMake(geVec2MulF4(self.p0, value), geVec2MulF4(self.p1, value), geVec2MulF4(self.p2, value), geVec2MulF4(self.p3, value));
}
GEQuad geQuadMulMat3(GEQuad self, GEMat3* mat3) {
    return GEQuadMake([mat3 mulVec2:self.p0], [mat3 mulVec2:self.p1], [mat3 mulVec2:self.p2], [mat3 mulVec2:self.p3]);
}
GEQuadrant geQuadQuadrant(GEQuad self) {
    float x = (self.p1.x - self.p0.x) / 2;
    float y = (self.p3.y - self.p0.y) / 2;
    GEQuad q = geQuadAddVec2(geQuadMulValue(self, 0.5), self.p0);
    return GEQuadrantMake((GEQuad[]){q, geQuadAddXY(q, x, 0.0), geQuadAddXY(q, x, y), geQuadAddXY(q, 0.0, y)});
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
    CGFloat minX = odFloatMax();
    CGFloat maxX = odFloatMin();
    CGFloat minY = odFloatMax();
    CGFloat maxY = odFloatMin();
    NSInteger i = 0;
    while(i < 4) {
        GEVec2 pp = geQuadApplyIndex(self, ((NSUInteger)(i)));
        if(pp.x < minX) minX = ((CGFloat)(pp.x));
        if(pp.x > maxX) maxX = ((CGFloat)(pp.x));
        if(pp.y < minY) minY = ((CGFloat)(pp.y));
        if(pp.y > maxY) maxY = ((CGFloat)(pp.y));
        i++;
    }
    return geVec2RectToVec2(GEVec2Make(((float)(minX)), ((float)(minY))), GEVec2Make(((float)(maxX)), ((float)(maxY))));
}
id<CNSeq> geQuadLines(GEQuad self) {
    return (@[wrap(GELine2, geLine2ApplyP0P1(self.p0, self.p1)), wrap(GELine2, geLine2ApplyP0P1(self.p1, self.p2)), wrap(GELine2, geLine2ApplyP0P1(self.p2, self.p3)), wrap(GELine2, geLine2ApplyP0P1(self.p3, self.p0))]);
}
id<CNSeq> geQuadPs(GEQuad self) {
    return (@[wrap(GEVec2, self.p0), wrap(GEVec2, self.p1), wrap(GEVec2, self.p2), wrap(GEVec2, self.p3)]);
}
GEVec2 geQuadClosestPointForVec2(GEQuad self, GEVec2 vec2) {
    id<CNSeq> projs = [[[geQuadLines(self) chain] flatMap:^id(id _) {
        return geLine2ProjectionOnSegmentVec2(uwrap(GELine2, _), vec2);
    }] toArray];
    if([projs count] == 4) {
        return vec2;
    } else {
        if([projs isEmpty]) projs = geQuadPs(self);
        GEVec2 p = uwrap(GEVec2, [[[[[projs chain] sortBy] ascBy:^id(id _) {
            return numf4(geVec2LengthSquare(geVec2SubVec2(uwrap(GEVec2, _), vec2)));
        }] endSort] head]);
        return p;
    }
}
GEQuad geQuadIdentity() {
    static GEQuad _ret = (GEQuad){{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}};
    return _ret;
}
ODPType* geQuadType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEQuadWrap class] name:@"GEQuad" size:sizeof(GEQuad) wrap:^id(void* data, NSUInteger i) {
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
    return GEQuadDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuadWrap* o = ((GEQuadWrap*)(other));
    return GEQuadEq(_value, o.value);
}

- (NSUInteger)hash {
    return GEQuadHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEQuadrantDescription(GEQuadrant self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEQuadrant: "];
    [description appendFormat:@"quads=[%@, %@, %@, %@]", GEQuadDescription(self.quads[0]), GEQuadDescription(self.quads[1]), GEQuadDescription(self.quads[2]), GEQuadDescription(self.quads[3])];
    [description appendString:@">"];
    return description;
}
GEQuad geQuadrantRndQuad(GEQuadrant self) {
    return self.quads[oduIntRndMax(3)];
}
ODPType* geQuadrantType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEQuadrantWrap class] name:@"GEQuadrant" size:sizeof(GEQuadrant) wrap:^id(void* data, NSUInteger i) {
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
    return GEQuadrantDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuadrantWrap* o = ((GEQuadrantWrap*)(other));
    return GEQuadrantEq(_value, o.value);
}

- (NSUInteger)hash {
    return GEQuadrantHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GERectDescription(GERect self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERect: "];
    [description appendFormat:@"p=%@", GEVec2Description(self.p)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}
GERect geRectApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectMake(GEVec2Make(x, y), GEVec2Make(width, height));
}
GERect geRectApplyXYSize(float x, float y, GEVec2 size) {
    return GERectMake(GEVec2Make(x, y), size);
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
    return GERectMake(geVec2AddVec2(self.p, vec2), self.size);
}
GERect geRectSubVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2SubVec2(self.p, vec2), self.size);
}
GERect geRectMulF(GERect self, CGFloat f) {
    return GERectMake(geVec2MulF(self.p, f), geVec2MulF(self.size, f));
}
GERect geRectMulVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2MulVec2(self.p, vec2), geVec2MulVec2(self.size, vec2));
}
BOOL geRectIntersectsRect(GERect self, GERect rect) {
    return self.p.x <= geRectX2(rect) && geRectX2(self) >= rect.p.x && self.p.y <= geRectY2(rect) && geRectY2(self) >= rect.p.y;
}
GERect geRectThickenHalfSize(GERect self, GEVec2 halfSize) {
    return GERectMake(geVec2SubVec2(self.p, halfSize), geVec2AddVec2(self.size, geVec2MulI(halfSize, 2)));
}
GERect geRectDivVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2DivVec2(self.p, vec2), geVec2DivVec2(self.size, vec2));
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
    return GERectMake(geVec2MulF(geVec2SubVec2(size, self.size), 0.5), self.size);
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
    return GERectMake(GEVec2Make(self.p.x - self.size.x / 2, self.p.y), self.size);
}
GERect geRectCenterY(GERect self) {
    return GERectMake(GEVec2Make(self.p.x, self.p.y - self.size.y / 2), self.size);
}
GEVec2 geRectCenter(GERect self) {
    return geVec2AddVec2(self.p, geVec2DivI(self.size, 2));
}
GEVec2 geRectClosestPointForVec2(GERect self, GEVec2 vec2) {
    return geVec2MaxVec2(geVec2MinVec2(vec2, geRectPhw(self)), self.p);
}
GEVec2 geRectPXY(GERect self, float x, float y) {
    return GEVec2Make(self.p.x + self.size.x * x, self.p.y + self.size.y * y);
}
ODPType* geRectType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GERectWrap class] name:@"GERect" size:sizeof(GERect) wrap:^id(void* data, NSUInteger i) {
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
    return GERectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectWrap* o = ((GERectWrap*)(other));
    return GERectEq(_value, o.value);
}

- (NSUInteger)hash {
    return GERectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GERectIDescription(GERectI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERectI: "];
    [description appendFormat:@"p=%@", GEVec2iDescription(self.p)];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}
GERectI geRectIApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectIMake(geVec2iApplyVec2(GEVec2Make(x, y)), geVec2iApplyVec2(GEVec2Make(width, height)));
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
    return GERectIMake(geVec2iApplyVec2(geVec2MulF(geVec2SubVec2(size, geVec2ApplyVec2i(self.size)), 0.5)), self.size);
}
ODPType* geRectIType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GERectIWrap class] name:@"GERectI" size:sizeof(GERectI) wrap:^id(void* data, NSUInteger i) {
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
    return GERectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectIWrap* o = ((GERectIWrap*)(other));
    return GERectIEq(_value, o.value);
}

- (NSUInteger)hash {
    return GERectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GELine2Description(GELine2 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GELine2: "];
    [description appendFormat:@"p0=%@", GEVec2Description(self.p0)];
    [description appendFormat:@", u=%@", GEVec2Description(self.u)];
    [description appendString:@">"];
    return description;
}
GELine2 geLine2ApplyP0P1(GEVec2 p0, GEVec2 p1) {
    return GELine2Make(p0, geVec2SubVec2(p1, p0));
}
GEVec2 geLine2RT(GELine2 self, float t) {
    return geVec2AddVec2(self.p0, geVec2MulF4(self.u, t));
}
GEVec2 geLine2RLine2(GELine2 self, GELine2 line2) {
    return geVec2AddVec2(self.p0, geVec2MulF4(self.u, geVec2DotVec2(geLine2N(line2), geVec2SubVec2(line2.p0, self.p0)) / geVec2DotVec2(geLine2N(line2), self.u)));
}
float geLine2Angle(GELine2 self) {
    return geVec2Angle(self.u);
}
float geLine2DegreeAngle(GELine2 self) {
    return geVec2DegreeAngle(self.u);
}
GELine2 geLine2SetLength(GELine2 self, float length) {
    return GELine2Make(self.p0, geVec2SetLength(self.u, length));
}
GELine2 geLine2Normalize(GELine2 self) {
    return GELine2Make(self.p0, geVec2Normalize(self.u));
}
GEVec2 geLine2Mid(GELine2 self) {
    return geVec2AddVec2(self.p0, geVec2DivI(self.u, 2));
}
GEVec2 geLine2P1(GELine2 self) {
    return geVec2AddVec2(self.p0, self.u);
}
GELine2 geLine2AddVec2(GELine2 self, GEVec2 vec2) {
    return GELine2Make(geVec2AddVec2(self.p0, vec2), self.u);
}
GELine2 geLine2SubVec2(GELine2 self, GEVec2 vec2) {
    return GELine2Make(geVec2SubVec2(self.p0, vec2), self.u);
}
GEVec2 geLine2N(GELine2 self) {
    return geVec2Normalize(GEVec2Make(-self.u.y, self.u.x));
}
GEVec2 geLine2ProjectionVec2(GELine2 self, GEVec2 vec2) {
    return geLine2RLine2(self, GELine2Make(vec2, geLine2N(self)));
}
id geLine2ProjectionOnSegmentVec2(GELine2 self, GEVec2 vec2) {
    GEVec2 p = geLine2RLine2(self, GELine2Make(vec2, geLine2N(self)));
    if(geRectContainsVec2(geLine2BoundingRect(self), p)) return [CNOption applyValue:wrap(GEVec2, p)];
    else return [CNOption none];
}
GERect geLine2BoundingRect(GELine2 self) {
    return geRectApplyXYSize(((self.u.x > 0) ? self.p0.x : self.p0.x + self.u.x), ((self.u.y > 0) ? self.p0.y : self.p0.y + self.u.y), geVec2Abs(self.u));
}
GELine2 geLine2Positive(GELine2 self) {
    if(self.u.x < 0 || (eqf4(self.u.x, 0) && self.u.y < 0)) return GELine2Make(geLine2P1(self), geVec2Negate(self.u));
    else return self;
}
ODPType* geLine2Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GELine2Wrap class] name:@"GELine2" size:sizeof(GELine2) wrap:^id(void* data, NSUInteger i) {
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
    return GELine2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GELine2Wrap* o = ((GELine2Wrap*)(other));
    return GELine2Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GELine2Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GELine3Description(GELine3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GELine3: "];
    [description appendFormat:@"r0=%@", GEVec3Description(self.r0)];
    [description appendFormat:@", u=%@", GEVec3Description(self.u)];
    [description appendString:@">"];
    return description;
}
GEVec3 geLine3RT(GELine3 self, float t) {
    return geVec3AddVec3(self.r0, geVec3MulK(self.u, t));
}
GEVec3 geLine3RPlane(GELine3 self, GEPlane plane) {
    return geVec3AddVec3(self.r0, geVec3MulK(self.u, geVec3DotVec3(plane.n, geVec3SubVec3(plane.p0, self.r0)) / geVec3DotVec3(plane.n, self.u)));
}
ODPType* geLine3Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GELine3Wrap class] name:@"GELine3" size:sizeof(GELine3) wrap:^id(void* data, NSUInteger i) {
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
    return GELine3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GELine3Wrap* o = ((GELine3Wrap*)(other));
    return GELine3Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GELine3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEPlaneDescription(GEPlane self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEPlane: "];
    [description appendFormat:@"p0=%@", GEVec3Description(self.p0)];
    [description appendFormat:@", n=%@", GEVec3Description(self.n)];
    [description appendString:@">"];
    return description;
}
BOOL gePlaneContainsVec3(GEPlane self, GEVec3 vec3) {
    return eqf4(geVec3DotVec3(self.n, geVec3SubVec3(vec3, self.p0)), 0);
}
GEPlane gePlaneAddVec3(GEPlane self, GEVec3 vec3) {
    return GEPlaneMake(geVec3AddVec3(self.p0, vec3), self.n);
}
GEPlane gePlaneMulMat4(GEPlane self, GEMat4* mat4) {
    return GEPlaneMake([mat4 mulVec3:self.p0], geVec4Xyz([mat4 mulVec3:self.n w:0.0]));
}
ODPType* gePlaneType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEPlaneWrap class] name:@"GEPlane" size:sizeof(GEPlane) wrap:^id(void* data, NSUInteger i) {
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
    return GEPlaneDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPlaneWrap* o = ((GEPlaneWrap*)(other));
    return GEPlaneEq(_value, o.value);
}

- (NSUInteger)hash {
    return GEPlaneHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEPlaneCoordDescription(GEPlaneCoord self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEPlaneCoord: "];
    [description appendFormat:@"plane=%@", GEPlaneDescription(self.plane)];
    [description appendFormat:@", x=%@", GEVec3Description(self.x)];
    [description appendFormat:@", y=%@", GEVec3Description(self.y)];
    [description appendString:@">"];
    return description;
}
GEPlaneCoord gePlaneCoordApplyPlaneX(GEPlane plane, GEVec3 x) {
    return GEPlaneCoordMake(plane, x, geVec3CrossVec3(x, plane.n));
}
GEVec3 gePlaneCoordPVec2(GEPlaneCoord self, GEVec2 vec2) {
    return geVec3AddVec3(geVec3AddVec3(self.plane.p0, geVec3MulK(self.x, vec2.x)), geVec3MulK(self.y, vec2.y));
}
GEPlaneCoord gePlaneCoordAddVec3(GEPlaneCoord self, GEVec3 vec3) {
    return GEPlaneCoordMake(gePlaneAddVec3(self.plane, vec3), self.x, self.y);
}
GEPlaneCoord gePlaneCoordSetX(GEPlaneCoord self, GEVec3 x) {
    return GEPlaneCoordMake(self.plane, x, self.y);
}
GEPlaneCoord gePlaneCoordSetY(GEPlaneCoord self, GEVec3 y) {
    return GEPlaneCoordMake(self.plane, self.x, y);
}
GEPlaneCoord gePlaneCoordMulMat4(GEPlaneCoord self, GEMat4* mat4) {
    return GEPlaneCoordMake(gePlaneMulMat4(self.plane, mat4), [mat4 mulVec3:self.x], [mat4 mulVec3:self.y]);
}
ODPType* gePlaneCoordType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEPlaneCoordWrap class] name:@"GEPlaneCoord" size:sizeof(GEPlaneCoord) wrap:^id(void* data, NSUInteger i) {
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
    return GEPlaneCoordDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEPlaneCoordWrap* o = ((GEPlaneCoordWrap*)(other));
    return GEPlaneCoordEq(_value, o.value);
}

- (NSUInteger)hash {
    return GEPlaneCoordHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* GEQuad3Description(GEQuad3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEQuad3: "];
    [description appendFormat:@"planeCoord=%@", GEPlaneCoordDescription(self.planeCoord)];
    [description appendFormat:@", quad=%@", GEQuadDescription(self.quad)];
    [description appendString:@">"];
    return description;
}
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
id<CNSeq> geQuad3Ps(GEQuad3 self) {
    return (@[wrap(GEVec3, geQuad3P0(self)), wrap(GEVec3, geQuad3P1(self)), wrap(GEVec3, geQuad3P2(self)), wrap(GEVec3, geQuad3P3(self))]);
}
GEQuad3 geQuad3MulMat4(GEQuad3 self, GEMat4* mat4) {
    return GEQuad3Make(gePlaneCoordMulMat4(self.planeCoord, mat4), self.quad);
}
ODPType* geQuad3Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GEQuad3Wrap class] name:@"GEQuad3" size:sizeof(GEQuad3) wrap:^id(void* data, NSUInteger i) {
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
    return GEQuad3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEQuad3Wrap* o = ((GEQuad3Wrap*)(other));
    return GEQuad3Eq(_value, o.value);
}

- (NSUInteger)hash {
    return GEQuad3Hash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



