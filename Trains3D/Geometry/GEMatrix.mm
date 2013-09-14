#import "GEMatrix.h"

//#if defined(__LP64__) && __LP64__
//#define GLM_PRECISION_HIGHP_FLOAT
//#endif

#include "glm.hpp"
#include "matrix_transform.hpp"
#import "type_ptr.hpp"


struct GEMatrixImpl {
    glm::mat4 m;
};


@implementation GEMatrix {
@private
    struct GEMatrixImpl *_impl;
}

static GEMatrix * _identity;

- (struct GEMatrixImpl *)impl {
    return _impl;
}


- (id)initWithImpl:(GEMatrixImpl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)matrixWithImpl:(GEMatrixImpl *)m {
    return [[self alloc] initWithImpl:m];
}

+ (id)matrixWithArray:(float [16])m {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::make_mat4(m);
    return [GEMatrix matrixWithImpl:impl];
}


- (GEMatrix *)mulMatrix:(GEMatrix *)matrix {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = _impl->m * matrix.impl->m;
    return [GEMatrix matrixWithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::mat4(1.0);
    _identity = [GEMatrix matrixWithImpl:impl];
}


- (GEVec4)mulVec4:(GEVec4)vec4 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w);
    return {v4.x, v4.y, v4.z, v4.w};
}

- (GEVec4)mulVec3:(GEVec3)vec3 w:(float)w {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, w);
    return {v4.x, v4.y, v4.z, v4.w};
}


+ (GEMatrix *)identity {
    return _identity;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (GEMatrix *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::ortho(left, right, bottom, top, near, far);
    return [GEMatrix matrixWithImpl:impl];
}

- (void)dealloc {
    delete _impl;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GEMatrix * o = ((GEMatrix *)(other));
    return memcmp(_impl, o.impl, sizeof(float[16])) == 0;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (GEMatrix *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::rotate(_impl->m, angle, glm::vec3(x, y, z));
    return [GEMatrix matrixWithImpl:impl];
}

- (GEMatrix *)scaleX:(float)x y:(float)y z:(float)z {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::scale(_impl->m, glm::vec3(x, y, z));
    return [GEMatrix matrixWithImpl:impl];
}

- (GEMatrix *)translateX:(float)x y:(float)y z:(float)z {
    GEMatrixImpl * impl = new GEMatrixImpl;
    impl->m = glm::translate(_impl->m, glm::vec3(x, y, z));
    return [GEMatrix matrixWithImpl:impl];
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

@end


