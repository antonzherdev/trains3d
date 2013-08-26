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

+ (EGMatrix *)identity;

- (float const *)array;

+ (EGMatrix *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far;

- (EGMatrix *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;

- (EGMatrix *)scaleX:(float)x y:(float)y z:(float)z;

- (EGMatrix *)translateX:(float)x y:(float)y z:(float)z;
@end


