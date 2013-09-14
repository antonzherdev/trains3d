#import "EGMatrix.h"

//#if defined(__LP64__) && __LP64__
//#define GLM_PRECISION_HIGHP_FLOAT
//#endif

#include "glm.hpp"
#include "matrix_transform.hpp"
#import "type_ptr.hpp"


struct EGMatrixImpl {
    glm::mat4 m;
};


@implementation EGMatrix{
@private
    struct EGMatrixImpl*_impl;
}

static EGMatrix* _identity;

- (struct EGMatrixImpl *)impl {
    return _impl;
}


- (id)initWithImpl:(EGMatrixImpl *)m {
    self = [super init];
    if (self) {
        _impl = m;
    }

    return self;
}

+ (id)matrixWithImpl:(EGMatrixImpl *)m {
    return [[self alloc] initWithImpl:m];
}

+ (id)matrixWithArray:(float [16])m {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::make_mat4(m);
    return [EGMatrix matrixWithImpl:impl];
}


- (EGMatrix*)mulMatrix:(EGMatrix*)matrix {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = _impl->m * matrix.impl->m;
    return [EGMatrix matrixWithImpl:impl];
}

+ (void)initialize {
    [super initialize];
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::mat4(1.0);
    _identity = [EGMatrix matrixWithImpl:impl];
}


- (EGVec4)mulVec4:(EGVec4)vec4 {
    glm::vec4 v4 = _impl->m* glm::vec4(vec4.x, vec4.y, vec4.z, vec4.w);
    return {v4.x, v4.y, v4.z, v4.w};
}

- (EGVec4)mulVec3:(EGVec3)vec3 w:(float)w {
    glm::vec4 v4 = _impl->m* glm::vec4(vec3.x, vec3.y, vec3.z, w);
    return {v4.x, v4.y, v4.z, v4.w};
}


+ (EGMatrix *)identity {
    return _identity;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

+ (EGMatrix *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::ortho(left, right, bottom, top, near, far);
    return [EGMatrix matrixWithImpl:impl];
}

- (void)dealloc {
    delete _impl;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMatrix* o = ((EGMatrix*)(other));
    return memcmp(_impl, o.impl, sizeof(float[16])) == 0;
}

- (float const *)array {
    return glm::value_ptr(_impl->m);
}

- (EGMatrix *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::rotate(_impl->m, angle, glm::vec3(x, y, z));
    return [EGMatrix matrixWithImpl:impl];
}

- (EGMatrix *)scaleX:(float)x y:(float)y z:(float)z {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::scale(_impl->m, glm::vec3(x, y, z));
    return [EGMatrix matrixWithImpl:impl];
}

- (EGMatrix *)translateX:(float)x y:(float)y z:(float)z {
    EGMatrixImpl* impl = new EGMatrixImpl;
    impl->m = glm::translate(_impl->m, glm::vec3(x, y, z));
    return [EGMatrix matrixWithImpl:impl];
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


