#import "objd.h"
#import "GEVec.h"

@class GEMatrix;

struct GEMatrixImpl;
typedef struct GEMatrixImpl GEMatrixImpl;
@interface GEMatrix : NSObject
- (GEMatrixImpl *)impl;

- (id)initWithImpl:(GEMatrixImpl *)m;

+ (id)matrixWithImpl:(GEMatrixImpl *)m;
+ (id)matrixWithArray:(float[16])m;

- (GEMatrix *)mulMatrix:(GEMatrix *)matrix;
- (GEVec4)mulVec4:(GEVec4)vec4;
- (GEVec4)mulVec3:(GEVec3)vec3 w:(float)w;

+ (GEMatrix *)identity;

- (float const *)array;

+ (GEMatrix *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far;

- (GEMatrix *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;

- (GEMatrix *)scaleX:(float)x y:(float)y z:(float)z;

- (GEMatrix *)translateX:(float)x y:(float)y z:(float)z;
@end


