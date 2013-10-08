#import "objd.h"
#import "GEVec.h"

@class GEMat4;

struct GEMat4Impl;
typedef struct GEMat4Impl GEMat4Impl;
@interface GEMat4 : NSObject
- (GEMat4Impl *)impl;

- (id)initWithImpl:(GEMat4Impl *)m;

+ (id)matrixWithImpl:(GEMat4Impl *)m;
+ (id)matrixWithArray:(float[16])m;

- (GEMat4 *)mulMatrix:(GEMat4 *)matrix;
- (GEVec4)mulVec4:(GEVec4)vec4;
- (GEVec4)mulVec3:(GEVec3)vec3 w:(float)w;

+ (GEMat4 *)identity;

- (float const *)array;

+ (GEMat4 *)orthoLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top zNear:(float)near zFar:(float)far;

- (GEMat4 *)rotateAngle:(float)angle x:(float)x y:(float)y z:(float)z;

+ (GEMat4 *)lookAtEye:(GEVec3)vec3 center:(GEVec3)center up:(GEVec3)up;

- (GEMat4 *)scaleX:(float)x y:(float)y z:(float)z;

+ (GEMat4 *)null;

- (GEMat4 *)translateX:(float)x y:(float)y z:(float)z;

- (GEVec4)divBySelfVec4:(GEVec4)vec4;

- (GEMat4 *)inverse;

- (GERect)mulRect:(GERect)rect;

- (GERect)mulRect:(GERect)rect z:(float)z;
@end


