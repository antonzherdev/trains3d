#import "EGVec.h"

EGVec2 egVec2ApplyVec2i(EGVec2I vec2i) {
    return EGVec2Make(((float)(vec2i.x)), ((float)(vec2i.y)));
}
EGVec2 egVec2AddVec2(EGVec2 self, EGVec2 vec2) {
    return EGVec2Make(self.x + vec2.x, self.y + vec2.y);
}
EGVec2 egVec2SubVec2(EGVec2 self, EGVec2 vec2) {
    return EGVec2Make(self.x - vec2.x, self.y - vec2.y);
}
EGVec2 egVec2Negate(EGVec2 self) {
    return EGVec2Make(-self.x, -self.y);
}
float egVec2Angle(EGVec2 self) {
    return ((float)(atan2(((CGFloat)(self.y)), ((CGFloat)(self.x)))));
}
float egVec2DotVec2(EGVec2 self, EGVec2 vec2) {
    return self.x * vec2.x + self.y * vec2.y;
}
float egVec2LengthSquare(EGVec2 self) {
    return egVec2DotVec2(self, self);
}
CGFloat egVec2Length(EGVec2 self) {
    return sqrt(((CGFloat)(egVec2LengthSquare(self))));
}
EGVec2 egVec2MulValue(EGVec2 self, float value) {
    return EGVec2Make(self.x * value, self.y * value);
}
EGVec2 egVec2DivValue(EGVec2 self, float value) {
    return EGVec2Make(self.x / value, self.y / value);
}
EGVec2 egVec2MidVec2(EGVec2 self, EGVec2 vec2) {
    return egVec2MulValue(egVec2AddVec2(self, vec2), 0.5);
}
CGFloat egVec2DistanceToVec2(EGVec2 self, EGVec2 vec2) {
    return egVec2Length(egVec2SubVec2(self, vec2));
}
EGVec2 egVec2SetLength(EGVec2 self, float length) {
    return egVec2MulValue(self, length / egVec2Length(self));
}
EGVec2 egVec2Normalize(EGVec2 self) {
    return egVec2SetLength(self, 1.0);
}
NSInteger egVec2CompareTo(EGVec2 self, EGVec2 to) {
    NSInteger dX = float4CompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return float4CompareTo(self.y, to.y);
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
    return egVec2CompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec2I egVec2IApplyVec2(EGVec2 vec2) {
    return EGVec2IMake(lround(((CGFloat)(vec2.x))), lround(((CGFloat)(vec2.y))));
}
EGVec2I egVec2IAddVec2i(EGVec2I self, EGVec2I vec2i) {
    return EGVec2IMake(self.x + vec2i.x, self.y + vec2i.y);
}
EGVec2I egVec2ISubVec2i(EGVec2I self, EGVec2I vec2i) {
    return EGVec2IMake(self.x - vec2i.x, self.y - vec2i.y);
}
EGVec2I egVec2INegate(EGVec2I self) {
    return EGVec2IMake(-self.x, -self.y);
}
NSInteger egVec2ICompareTo(EGVec2I self, EGVec2I to) {
    NSInteger dX = intCompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompareTo(self.y, to.y);
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
    return egVec2ICompareTo(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec3 egVec3ApplyVec2Z(EGVec2 vec2, float z) {
    return EGVec3Make(vec2.x, vec2.y, z);
}
EGVec3 egVec3AddV(EGVec3 self, EGVec3 v) {
    return EGVec3Make(self.x + v.x, self.y + v.y, self.z + v.z);
}
EGVec3 egVec3Sqr(EGVec3 self) {
    return egVec3MulK(self, ((float)(egVec3Length(self))));
}
EGVec3 egVec3MulK(EGVec3 self, float k) {
    return EGVec3Make(k * self.x, k * self.y, k * self.z);
}
CGFloat egVec3DotVec3(EGVec3 self, EGVec3 vec3) {
    return ((CGFloat)(self.x * vec3.x + self.y * vec3.y + self.z * vec3.z));
}
CGFloat egVec3LengthSquare(EGVec3 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z));
}
CGFloat egVec3Length(EGVec3 self) {
    return sqrt(egVec3LengthSquare(self));
}
EGVec3 egVec3SetLength(EGVec3 self, CGFloat length) {
    return egVec3MulK(self, ((float)(length / egVec3Length(self))));
}
EGVec3 egVec3Normalize(EGVec3 self) {
    return egVec3SetLength(self, 1.0);
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



EGVec4 egVec4ApplyVec3W(EGVec3 vec3, float w) {
    return EGVec4Make(vec3.x, vec3.y, vec3.z, w);
}
EGVec3 egVec4Xyz(EGVec4 self) {
    return EGVec3Make(self.x, self.y, self.z);
}
EGVec4 egVec4MulK(EGVec4 self, float k) {
    return EGVec4Make(k * self.x, k * self.y, k * self.z, k * self.w);
}
CGFloat egVec4LengthSquare(EGVec4 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w));
}
CGFloat egVec4Length(EGVec4 self) {
    return sqrt(egVec4LengthSquare(self));
}
EGVec4 egVec4SetLength(EGVec4 self, CGFloat length) {
    return egVec4MulK(self, ((float)(length / egVec4Length(self))));
}
EGVec4 egVec4Normalize(EGVec4 self) {
    return egVec4SetLength(self, 1.0);
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



EGQuad egQuadApplySize(float size) {
    return EGQuadMake(EGVec2Make(-size, -size), EGVec2Make(size, -size), EGVec2Make(size, size), EGVec2Make(-size, size));
}
EGQuad egQuadMulValue(EGQuad self, float value) {
    return EGQuadMake(egVec2MulValue(self.p1, value), egVec2MulValue(self.p2, value), egVec2MulValue(self.p3, value), egVec2MulValue(self.p4, value));
}
EGQuad egQuadAddVec2(EGQuad self, EGVec2 vec2) {
    return EGQuadMake(egVec2AddVec2(self.p1, vec2), egVec2AddVec2(self.p2, vec2), egVec2AddVec2(self.p3, vec2), egVec2AddVec2(self.p4, vec2));
}
EGQuad egQuadAddXY(EGQuad self, float x, float y) {
    return egQuadAddVec2(self, EGVec2Make(x, y));
}
EGQuadrant egQuadQuadrant(EGQuad self) {
    float x = (self.p2.x - self.p1.x) / 2;
    float y = (self.p4.y - self.p1.y) / 2;
    EGQuad q = egQuadAddVec2(egQuadMulValue(self, 0.5), self.p1);
    return EGQuadrantMake((EGQuad[]){q, egQuadAddXY(q, x, 0.0), egQuadAddXY(q, x, y), egQuadAddXY(q, 0.0, y)});
}
EGQuad egQuadIdentity() {
    static EGQuad _ret = {{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}};
    return _ret;
}
ODPType* egQuadType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGQuadWrap class] name:@"EGQuad" size:sizeof(EGQuad) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGQuad, ((EGQuad*)(data))[i]);
    }];
    return _ret;
}
@implementation EGQuadWrap{
    EGQuad _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGQuad)value {
    return [[EGQuadWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGQuad)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGQuadDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGQuadWrap* o = ((EGQuadWrap*)(other));
    return EGQuadEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGQuadHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGQuad egQuadrantRandomQuad(EGQuadrant self) {
    return self.quads[randomMax(3)];
}
ODPType* egQuadrantType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGQuadrantWrap class] name:@"EGQuadrant" size:sizeof(EGQuadrant) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGQuadrant, ((EGQuadrant*)(data))[i]);
    }];
    return _ret;
}
@implementation EGQuadrantWrap{
    EGQuadrant _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGQuadrant)value {
    return [[EGQuadrantWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGQuadrant)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGQuadrantDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGQuadrantWrap* o = ((EGQuadrantWrap*)(other));
    return EGQuadrantEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGQuadrantHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



