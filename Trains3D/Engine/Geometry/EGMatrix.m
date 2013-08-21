#import "EGMatrix.h"

@implementation EGMatrix{
    double* _m;
}
@synthesize m = _m;

- (id)initWithM:(double *)m {
    self = [super init];
    if (self) {
        _m = m;
    }

    return self;
}

+ (id)matrixWithM:(double *)m {
    return [[self alloc] initWithM:m];
}


- (EGMatrix*)multiply:(EGMatrix*)matrix {
    double *mm = malloc(sizeof(double) * 16);
    double *m2 = matrix.m;
    mm[0] = _m[0] * m2[0] + _m[4] * m2[1] + _m[8] * m2[2] + _m[12] * m2[3];
    mm[1] = _m[1] * m2[0] + _m[5] * m2[1] + _m[9] * m2[2] + _m[13] * m2[3];
    mm[2] = _m[2] * m2[0] + _m[6] * m2[1] + _m[10] * m2[2] + _m[14] * m2[3];
    mm[3] = _m[3] * m2[0] + _m[7] * m2[1] + _m[11] * m2[2] + _m[15] * m2[3];
    mm[4] = _m[0] * m2[4] + _m[4] * m2[5] + _m[8] * m2[6] + _m[12] * m2[7];
    mm[5] = _m[1] * m2[4] + _m[5] * m2[5] + _m[9] * m2[6] + _m[13] * m2[7];
    mm[6] = _m[2] * m2[4] + _m[6] * m2[5] + _m[10] * m2[6] + _m[14] * m2[7];
    mm[7] = _m[3] * m2[4] + _m[7] * m2[5] + _m[11] * m2[6] + _m[15] * m2[7];
    mm[8] = _m[0] * m2[8] + _m[4] * m2[9] + _m[8] * m2[10] + _m[12] * m2[11];
    mm[9] = _m[1] * m2[8] + _m[5] * m2[9] + _m[9] * m2[10] + _m[13] * m2[11];
    mm[10] = _m[2] * m2[8] + _m[6] * m2[9] + _m[10] * m2[10] + _m[14] * m2[11];
    mm[11] = _m[3] * m2[8] + _m[7] * m2[9] + _m[11] * m2[10] + _m[15] * m2[11];
    mm[12] = _m[0] * m2[12] + _m[4] * m2[13] + _m[8] * m2[14] + _m[12] * m2[15];
    mm[13] = _m[1] * m2[12] + _m[5] * m2[13] + _m[9] * m2[14] + _m[13] * m2[15];
    mm[14] = _m[2] * m2[12] + _m[6] * m2[13] + _m[10] * m2[14] + _m[14] * m2[15];
    mm[15] = _m[3] * m2[12] + _m[7] * m2[13] + _m[11] * m2[14] + _m[15] * m2[15];
    return [EGMatrix matrixWithM:mm];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (void)dealloc {
    free(_m);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMatrix* o = ((EGMatrix*)(other));
    return memcmp(_m, o.m, sizeof(double[16])) == 0;
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"[%f, %f, %f, %f,\n"
             " %f, %f, %f, %f,\n"
             " %f, %f, %f, %f,\n"
             " %f, %f, %f, %f]", 
             _m[0], _m[4], _m[8],  _m[12],
             _m[1], _m[5], _m[9],  _m[13],
             _m[2], _m[6], _m[10], _m[14],
             _m[3], _m[7], _m[11], _m[15]];
}

@end


