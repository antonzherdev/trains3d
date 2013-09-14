#import "objd.h"
#import "EGVec.h"

@class EGMatrix;

struct EGMatrixImpl;
typedef struct EGMatrixImpl EGMatrixImpl;
@interface EGMatrix : NSObject
- (EGMatrixImpl*)impl;

- (id)initWithImpl:(EGMatrixImpl *)m;

+ (id)matrixWithImpl:(EGMatrixImpl *)m;
+ (id)matrixWithArray:(float[16])m;

- (EGMatrix*)mulMatrix:(EGMatrix*)matrix;
- (EGVec4)mulVec4:(EGVec4)vec4;
- (EGVec4)mulVec3:(EGVec3)vec3 w:(float)w;

+ (EGMatrix *)identity;

- (float const *)array;

+ (EGMatrix *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far;

- (EGMatrix *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;

- (EGMatrix *)scaleX:(float)x y:(float)y z:(float)z;

- (EGMatrix *)translateX:(float)x y:(float)y z:(float)z;
@end


