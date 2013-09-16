#import "GEVec.h"

GEVec2 geVec2ApplyVec2i(GEVec2i vec2i) {
    return GEVec2Make(((float)(vec2i.x)), ((float)(vec2i.y)));
}
GEVec2 geVec2AddVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x + vec2.x, self.y + vec2.y);
}
GEVec2 geVec2SubVec2(GEVec2 self, GEVec2 vec2) {
    return GEVec2Make(self.x - vec2.x, self.y - vec2.y);
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
CGFloat geVec2Length(GEVec2 self) {
    return sqrt(((CGFloat)(geVec2LengthSquare(self))));
}
GEVec2 geVec2MulValue(GEVec2 self, float value) {
    return GEVec2Make(self.x * value, self.y * value);
}
GEVec2 geVec2DivValue(GEVec2 self, float value) {
    return GEVec2Make(self.x / value, self.y / value);
}
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2MulValue(geVec2AddVec2(self, vec2), 0.5);
}
CGFloat geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2Length(geVec2SubVec2(self, vec2));
}
GEVec2 geVec2SetLength(GEVec2 self, float length) {
    return geVec2MulValue(self, length / geVec2Length(self));
}
GEVec2 geVec2Normalize(GEVec2 self) {
    return geVec2SetLength(self, 1.0);
}
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to) {
    NSInteger dX = float4CompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return float4CompareTo(self.y, to.y);
}
ODType* geVec2Type() {
    static ODType* _ret = nil;
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



GEVec2i geVec2iApplyVec2(GEVec2 vec2) {
    return GEVec2iMake(lround(((CGFloat)(vec2.x))), lround(((CGFloat)(vec2.y))));
}
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x + vec2i.x, self.y + vec2i.y);
}
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x - vec2i.x, self.y - vec2i.y);
}
GEVec2i geVec2iNegate(GEVec2i self) {
    return GEVec2iMake(-self.x, -self.y);
}
NSInteger geVec2iCompareTo(GEVec2i self, GEVec2i to) {
    NSInteger dX = intCompareTo(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompareTo(self.y, to.y);
}
ODType* geVec2iType() {
    static ODType* _ret = nil;
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



GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z) {
    return GEVec3Make(vec2.x, vec2.y, z);
}
GEVec3 geVec3AddV(GEVec3 self, GEVec3 v) {
    return GEVec3Make(self.x + v.x, self.y + v.y, self.z + v.z);
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
CGFloat geVec3DotVec3(GEVec3 self, GEVec3 vec3) {
    return ((CGFloat)(self.x * vec3.x + self.y * vec3.y + self.z * vec3.z));
}
CGFloat geVec3LengthSquare(GEVec3 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z));
}
CGFloat geVec3Length(GEVec3 self) {
    return sqrt(geVec3LengthSquare(self));
}
GEVec3 geVec3SetLength(GEVec3 self, CGFloat length) {
    return geVec3MulK(self, ((float)(length / geVec3Length(self))));
}
GEVec3 geVec3Normalize(GEVec3 self) {
    return geVec3SetLength(self, 1.0);
}
ODType* geVec3Type() {
    static ODType* _ret = nil;
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



GEVec4 geVec4ApplyVec3W(GEVec3 vec3, float w) {
    return GEVec4Make(vec3.x, vec3.y, vec3.z, w);
}
GEVec3 geVec4Xyz(GEVec4 self) {
    return GEVec3Make(self.x, self.y, self.z);
}
GEVec4 geVec4MulK(GEVec4 self, float k) {
    return GEVec4Make(k * self.x, k * self.y, k * self.z, k * self.w);
}
CGFloat geVec4LengthSquare(GEVec4 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w));
}
CGFloat geVec4Length(GEVec4 self) {
    return sqrt(geVec4LengthSquare(self));
}
GEVec4 geVec4SetLength(GEVec4 self, CGFloat length) {
    return geVec4MulK(self, ((float)(length / geVec4Length(self))));
}
GEVec4 geVec4Normalize(GEVec4 self) {
    return geVec4SetLength(self, 1.0);
}
ODType* geVec4Type() {
    static ODType* _ret = nil;
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



GEQuad geQuadApplySize(float size) {
    return GEQuadMake(GEVec2Make(-size, -size), GEVec2Make(size, -size), GEVec2Make(size, size), GEVec2Make(-size, size));
}
GEQuad geQuadMulValue(GEQuad self, float value) {
    return GEQuadMake(geVec2MulValue(self.p1, value), geVec2MulValue(self.p2, value), geVec2MulValue(self.p3, value), geVec2MulValue(self.p4, value));
}
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2) {
    return GEQuadMake(geVec2AddVec2(self.p1, vec2), geVec2AddVec2(self.p2, vec2), geVec2AddVec2(self.p3, vec2), geVec2AddVec2(self.p4, vec2));
}
GEQuad geQuadAddXY(GEQuad self, float x, float y) {
    return geQuadAddVec2(self, GEVec2Make(x, y));
}
GEQuadrant geQuadQuadrant(GEQuad self) {
    float x = (self.p2.x - self.p1.x) / 2;
    float y = (self.p4.y - self.p1.y) / 2;
    GEQuad q = geQuadAddVec2(geQuadMulValue(self, 0.5), self.p1);
    return GEQuadrantMake((GEQuad[]){q, geQuadAddXY(q, x, 0.0), geQuadAddXY(q, x, y), geQuadAddXY(q, 0.0, y)});
}
GEQuad geQuadIdentity() {
    static GEQuad _ret = {{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}};
    return _ret;
}
ODType* geQuadType() {
    static ODType* _ret = nil;
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



GEQuad geQuadrantRandomQuad(GEQuadrant self) {
    return self.quads[randomMax(3)];
}
ODType* geQuadrantType() {
    static ODType* _ret = nil;
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



