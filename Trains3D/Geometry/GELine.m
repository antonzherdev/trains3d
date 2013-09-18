#import "GELine.h"

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



BOOL gePlaneContainsVec3(GEPlane self, GEVec3 vec3) {
    return eqf4(geVec3DotVec3(self.n, geVec3SubVec3(vec3, self.p0)), 0);
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



