#import "EGMatrix.h"

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


- (EGMatrix*)multiply:(EGMatrix*)matrix {
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


+ (EGMatrix *)identity {
    return _identity;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (void)dealloc {
    delete _impl;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMatrix* o = ((EGMatrix*)(other));
    return memcmp(_impl, o.impl, sizeof(double[16])) == 0;
}

- (GLfloat const *)array {
    return glm::value_ptr(_impl->m);
}
@end


