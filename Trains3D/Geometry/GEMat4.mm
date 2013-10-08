#import "GEMat4.h"

//#if defined(__LP64__) && __LP64__
//#define GLM_PRECISION_HIGHP_FLOAT
//#endif

#include "glm.hpp"
#include "matrix_transform.hpp"
#import "type_ptr.hpp"


struct GEMat4Impl {
    glm::mat4 m;
};


@implementation GEMat4 {
@private
    struct GEMat4Impl *_impl;
}

static GEMat4 * _identity;
static GEMat4 * _null;

- (struct GEMat4Impl *)impl {
    return _impl;
}


- (id)initWithImpl:(GEMat4Impl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)matrixWithImpl:(GEMat4Impl *)m {
    return [[self alloc] initWithImpl:m];
}

+ (id)matrixWithArray:(float [16])m {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::make_mat4(m);
    return [GEMat4 matrixWithImpl:impl];
}


- (GEMat4 *)mulMatrix:(GEMat4 *)matrix {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = _impl->m * matrix.impl->m;
    return [GEMat4 matrixWithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::mat4(1.0);
    _identity = [GEMat4 matrixWithImpl:impl];
    impl = new GEMat4Impl;
    impl->m = glm::mat4(0.0);
    _null = [GEMat4 matrixWithImpl:impl];
}


- (GEVec4)mulVec4:(GEVec4)vec4 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w);
    return {v4.x, v4.y, v4.z, v4.w};
}

- (GEVec4)mulVec3:(GEVec3)vec3 w:(float)w {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, w);
    return {v4.x, v4.y, v4.z, v4.w};
}


+ (GEMat4 *)identity {
    return _identity;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (GEMat4 *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::ortho(left, right, bottom, top, near, far);
    return [GEMat4 matrixWithImpl:impl];
}

- (void)dealloc {
    delete _impl;
}

+ (GEMat4 *)lookAtEye:(GEVec3)eye center:(GEVec3)center up:(GEVec3)up {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::lookAt(glm::vec3(eye.x, eye.y, eye.z), glm::vec3(center.x, center.y, center.z), glm::vec3(up.x, up.y, up.z));
    return [GEMat4 matrixWithImpl:impl];
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEMat4 * o = ((GEMat4 *)(other));
    return memcmp(_impl, o.impl, sizeof(float[16])) == 0;
}

+ (GEMat4 *)null {
    return _null;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (GEMat4 *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::rotate(_impl->m, angle, glm::vec3(x, y, z));
    return [GEMat4 matrixWithImpl:impl];
}

- (GEMat4 *)scaleX:(float)x y:(float)y z:(float)z {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::scale(_impl->m, glm::vec3(x, y, z));
    return [GEMat4 matrixWithImpl:impl];
}

- (GEMat4 *)translateX:(float)x y:(float)y z:(float)z {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::translate(_impl->m, glm::vec3(x, y, z));
    return [GEMat4 matrixWithImpl:impl];
}

- (NSString*)description {
    float const *m = [self array];
    return [NSString stringWithFormat:
            @"[%f, %f, %f, %f,\n"
                    " %f, %f, %f, %f,\n"
                    " %f, %f, %f, %f,\n"
                    " %f, %f, %f, %f]",
            m[0], m[4], m[8],  m[12],
            m[1], m[5], m[9],  m[13],
            m[2], m[6], m[10], m[14],
            m[3], m[7], m[11], m[15]];
}

- (GEVec4)divBySelfVec4:(GEVec4)vec4 {
    glm::vec4 v4 = glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w) / _impl->m;
    return {v4.x, v4.y, v4.z, v4.w};
}

- (GEMat4 *)inverse {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::inverse(_impl->m);
    return [GEMat4 matrixWithImpl:impl];
}

- (GERect)mulRect:(GERect)rect {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p0.x, rect.p0.y, 0, 1);
    GEVec2 p3 = {rect.p0.x + rect.size.x, rect.p0.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, 0, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}

- (GERect)mulRect:(GERect)rect z:(float)z {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p0.x, rect.p0.y, z, 1);
    GEVec2 p3 = {rect.p0.x + rect.size.x, rect.p0.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, z, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}
@end


