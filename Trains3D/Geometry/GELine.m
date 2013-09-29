#import "GELine.h"

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
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p[0]);
}
GEVec3 geQuad3P1(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p[1]);
}
GEVec3 geQuad3P2(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p[2]);
}
GEVec3 geQuad3P3(GEQuad3 self) {
    return gePlaneCoordPVec2(self.planeCoord, self.quad.p[3]);
}
id<CNSeq> geQuad3P(GEQuad3 self) {
    return (@[wrap(GEVec3, geQuad3P0(self)), wrap(GEVec3, geQuad3P1(self)), wrap(GEVec3, geQuad3P2(self)), wrap(GEVec3, geQuad3P3(self))]);
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



