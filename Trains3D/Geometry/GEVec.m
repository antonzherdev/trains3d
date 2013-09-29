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
CGFloat geVec2Length(GEVec2 self) {
    return sqrt(((CGFloat)(geVec2LengthSquare(self))));
}
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2) {
    return geVec2MulF(geVec2AddVec2(self, vec2), 0.5);
}
CGFloat geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2) {
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
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendString:@">"];
    return description;
}
GEVec2i geVec2iApplyVec2(GEVec2 vec2) {
    return GEVec2iMake(float4Round(vec2.x), float4Round(vec2.y));
}
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x + vec2i.x, self.y + vec2i.y);
}
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i) {
    return GEVec2iMake(self.x - vec2i.x, self.y - vec2i.y);
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
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z) {
    return GEVec3Make(vec2.x, vec2.y, z);
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
    [description appendFormat:@"p=[%@, %@, %@, %@]", GEVec2Description(self.p[0]), GEVec2Description(self.p[1]), GEVec2Description(self.p[2]), GEVec2Description(self.p[3])];
    [description appendString:@">"];
    return description;
}
GEQuad geQuadApplyP0P1P2P3(GEVec2 p0, GEVec2 p1, GEVec2 p2, GEVec2 p3) {
    return GEQuadMake((GEVec2[]){p0, p1, p2, p3});
}
GEQuad geQuadApplySize(float size) {
    return GEQuadMake((GEVec2[]){GEVec2Make(-size, -size), GEVec2Make(size, -size), GEVec2Make(size, size), GEVec2Make(-size, size)});
}
GEQuad geQuadMulValue(GEQuad self, float value) {
    return GEQuadMake((GEVec2[]){geVec2MulF4(self.p[0], value), geVec2MulF4(self.p[1], value), geVec2MulF4(self.p[2], value), geVec2MulF4(self.p[3], value)});
}
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2) {
    return GEQuadMake((GEVec2[]){geVec2AddVec2(self.p[0], vec2), geVec2AddVec2(self.p[1], vec2), geVec2AddVec2(self.p[2], vec2), geVec2AddVec2(self.p[3], vec2)});
}
GEQuad geQuadAddXY(GEQuad self, float x, float y) {
    return geQuadAddVec2(self, GEVec2Make(x, y));
}
GEQuadrant geQuadQuadrant(GEQuad self) {
    float x = (self.p[1].x - self.p[0].x) / 2;
    float y = (self.p[3].y - self.p[0].y) / 2;
    GEQuad q = geQuadAddVec2(geQuadMulValue(self, 0.5), self.p[0]);
    return GEQuadrantMake((GEQuad[]){q, geQuadAddXY(q, x, 0.0), geQuadAddXY(q, x, y), geQuadAddXY(q, 0.0, y)});
}
GEVec2 geQuadApplyIndex(GEQuad self, NSUInteger index) {
    return self.p[index];
}
GERect geQuadBoundingRect(GEQuad self) {
    CGFloat minX = odFloatMax();
    CGFloat maxX = odFloatMin();
    CGFloat minY = odFloatMax();
    CGFloat maxY = odFloatMin();
    NSInteger i = 0;
    while(i < 4) {
        GEVec2 pp = self.p[i];
        if(pp.x < minX) minX = ((CGFloat)(pp.x));
        if(pp.x > maxX) maxX = ((CGFloat)(pp.x));
        if(pp.y < minY) minY = ((CGFloat)(pp.y));
        if(pp.y > maxY) maxY = ((CGFloat)(pp.y));
        i++;
    }
    return geVec2RectToVec2(GEVec2Make(((float)(minX)), ((float)(minY))), GEVec2Make(((float)(maxX)), ((float)(maxY))));
}
GEQuad geQuadIdentity() {
    static GEQuad _ret = (GEQuad){{{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 1.0}}};
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
    [description appendFormat:@"p0=%@", GEVec2Description(self.p0)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}
GERect geRectApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectMake(GEVec2Make(x, y), GEVec2Make(width, height));
}
float geRectX(GERect self) {
    return self.p0.x;
}
float geRectY(GERect self) {
    return self.p0.y;
}
float geRectX2(GERect self) {
    return self.p0.x + self.size.x;
}
float geRectY2(GERect self) {
    return self.p0.y + self.size.y;
}
float geRectWidth(GERect self) {
    return self.size.x;
}
float geRectHeight(GERect self) {
    return self.size.y;
}
BOOL geRectContainsVec2(GERect self, GEVec2 vec2) {
    return self.p0.x <= vec2.x && vec2.x <= self.p0.x + self.size.x && self.p0.y <= vec2.y && vec2.y <= self.p0.y + self.size.y;
}
GERect geRectAddVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2AddVec2(self.p0, vec2), self.size);
}
GERect geRectSubVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2SubVec2(self.p0, vec2), self.size);
}
GERect geRectMulF(GERect self, CGFloat f) {
    return GERectMake(geVec2MulF(self.p0, f), geVec2MulF(self.size, f));
}
GERect geRectMulVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2MulVec2(self.p0, vec2), geVec2MulVec2(self.size, vec2));
}
BOOL geRectIntersectsRect(GERect self, GERect rect) {
    return self.p0.x <= geRectX2(rect) && geRectX2(self) >= rect.p0.x && self.p0.y <= geRectY2(rect) && geRectY2(self) >= rect.p0.y;
}
GERect geRectThickenHalfSize(GERect self, GEVec2 halfSize) {
    return GERectMake(geVec2SubVec2(self.p0, halfSize), geVec2AddVec2(self.size, geVec2MulI(halfSize, 2)));
}
GERect geRectDivVec2(GERect self, GEVec2 vec2) {
    return GERectMake(geVec2DivVec2(self.p0, vec2), geVec2DivVec2(self.size, vec2));
}
GEVec2 geRectP1(GERect self) {
    return GEVec2Make(self.p0.x, self.p0.y + self.size.y);
}
GEVec2 geRectP2(GERect self) {
    return GEVec2Make(self.p0.x + self.size.x, self.p0.y);
}
GEVec2 geRectP3(GERect self) {
    return GEVec2Make(self.p0.x + self.size.x, self.p0.y + self.size.y);
}
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size) {
    return GERectMake(geVec2MulF(geVec2SubVec2(size, self.size), 0.5), self.size);
}
GEQuad geRectQuad(GERect self) {
    return geQuadApplyP0P1P2P3(self.p0, geRectP1(self), geRectP2(self), geRectP3(self));
}
GEQuad geRectUpsideDownQuad(GERect self) {
    return geQuadApplyP0P1P2P3(geRectP1(self), self.p0, geRectP3(self), geRectP2(self));
}
GERect geRectCenterX(GERect self) {
    return GERectMake(GEVec2Make(self.p0.x + self.size.x / 2, self.p0.y), self.size);
}
GERect geRectCenterY(GERect self) {
    return GERectMake(GEVec2Make(self.p0.x, self.p0.y + self.size.y / 2), self.size);
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
    [description appendFormat:@"origin=%@", GEVec2iDescription(self.origin)];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}
GERectI geRectIApplyXYWidthHeight(float x, float y, float width, float height) {
    return GERectIMake(geVec2iApplyVec2(GEVec2Make(x, y)), geVec2iApplyVec2(GEVec2Make(width, height)));
}
GERectI geRectIApplyRect(GERect rect) {
    return GERectIMake(geVec2iApplyVec2(rect.p0), geVec2iApplyVec2(rect.size));
}
NSInteger geRectIX(GERectI self) {
    return self.origin.x;
}
NSInteger geRectIY(GERectI self) {
    return self.origin.y;
}
NSInteger geRectIX2(GERectI self) {
    return self.origin.x + self.size.x;
}
NSInteger geRectIY2(GERectI self) {
    return self.origin.y + self.size.y;
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



