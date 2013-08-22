#import "objd.h"

@class EGMatrix;

struct EGMatrixImpl;
typedef struct EGMatrixImpl EGMatrixImpl;
@interface EGMatrix : NSObject
- (EGMatrixImpl*)impl;

- (id)initWithImpl:(EGMatrixImpl *)m;

+ (id)matrixWithImpl:(EGMatrixImpl *)m;
+ (id)matrixWithArray:(float[16])m;

- (EGMatrix*)multiply:(EGMatrix*)matrix;

- (GLfloat const *)array;
@end


