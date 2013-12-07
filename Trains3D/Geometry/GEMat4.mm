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

+ (id)mat4WithImpl:(GEMat4Impl *)m {
    return [[self alloc] initWithImpl:m];
}

+ (id)mat4WithArray:(float [16])m {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::make_mat4(m);
    return [GEMat4 mat4WithImpl:impl];
}


- (GEMat4 *)mulMatrix:(GEMat4 *)matrix {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = _impl->m * matrix.impl->m;
    return [GEMat4 mat4WithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::mat4(1.0);
    _identity = [GEMat4 mat4WithImpl:impl];
    impl = new GEMat4Impl;
    impl->m = glm::mat4(0.0);
    _null = [GEMat4 mat4WithImpl:impl];
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
    return [GEMat4 mat4WithImpl:impl];
}

- (void)dealloc {
    delete _impl;
}

+ (GEMat4 *)lookAtEye:(GEVec3)eye center:(GEVec3)center up:(GEVec3)up {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::lookAt(glm::vec3(eye.x, eye.y, eye.z), glm::vec3(center.x, center.y, center.z), glm::vec3(up.x, up.y, up.z));
    return [GEMat4 mat4WithImpl:impl];
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
    return [GEMat4 mat4WithImpl:impl];
}

- (GEMat4 *)scaleX:(float)x y:(float)y z:(float)z {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::scale(_impl->m, glm::vec3(x, y, z));
    return [GEMat4 mat4WithImpl:impl];
}

- (GEMat4 *)translateX:(float)x y:(float)y z:(float)z {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::translate(_impl->m, glm::vec3(x, y, z));
    return [GEMat4 mat4WithImpl:impl];
}

- (GEMat4 *)translateVec3:(GEVec3)vec3 {
    GEMat4Impl * impl = new GEMat4Impl;
    impl->m = glm::translate(_impl->m, glm::vec3(vec3.x, vec3.y, vec3.z));
    return [GEMat4 mat4WithImpl:impl];
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
    return [GEMat4 mat4WithImpl:impl];
}

- (GERect)mulRect:(GERect)rect {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p.x, rect.p.y, 0, 1);
    GEVec2 p3 = {rect.p.x + rect.size.x, rect.p.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, 0, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}

- (GERect)mulRect:(GERect)rect z:(float)z {
    glm::vec4 v0 = _impl->m* glm::vec4(rect.p.x, rect.p.y, z, 1);
    GEVec2 p3 = {rect.p.x + rect.size.x, rect.p.y + rect.size.y};
    glm::vec4 v3 = _impl->m* glm::vec4(p3.x, p3.y, z, 1);
    return {v0.x, v0.y, v3.x - v0.x, v3.y - v0.y};
}

- (GEVec3)mulVec3:(GEVec3)vec3 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, 1);
    return {v4.x, v4.y, v4.z};
}
@end


struct GEMat3Impl {
    glm::mat3 m;
};


@implementation GEMat3 {
@private
    struct GEMat3Impl *_impl;
}

static GEMat3 * _mat3_identity;
static GEMat3 * _mat3_null;

- (struct GEMat3Impl *)impl {
    return _impl;
}


- (id)initWithImplMat3:(GEMat3Impl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)mat3WithImpl:(GEMat3Impl *)m {
    return [[self alloc] initWithImplMat3:m];
}

+ (id)mat3WithArray:(float [9])m {
    GEMat3Impl * impl = new GEMat3Impl;
    impl->m = glm::make_mat3(m);
    return [GEMat3 mat3WithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    GEMat3Impl * impl = new GEMat3Impl;
    impl->m = glm::mat3(1.0);
    _mat3_identity = [GEMat3 mat3WithImpl:impl];
    impl = new GEMat3Impl;
    impl->m = glm::mat3(0.0);
    _mat3_null = [GEMat3 mat3WithImpl:impl];
}


- (GEVec3)mulVec3:(GEVec3)vec3 {
    glm::vec3 v3 = _impl->m* glm::vec3(vec3.x, vec3.y, vec3.z);
    return {v3.x, v3.y, v3.z};
}

+ (GEMat3 *)identity {
    return _mat3_identity;
}

+ (GEMat3 *)null {
    return _mat3_null;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    float const *m = [self array];
    return [NSString stringWithFormat:
            @"[%f, %f, %f,\n"
                    " %f, %f, %f,\n"
                    " %f, %f, %f]",
            m[0], m[3], m[6],
            m[1], m[4], m[7],
            m[2], m[5], m[8]];
}

- (GEVec2)mulVec2:(GEVec2)vec2 {
    glm::vec3 v3 = _impl->m* glm::vec3(vec2.x, vec2.y, 1.0);
    return {v3.x, v3.y};
}
@end