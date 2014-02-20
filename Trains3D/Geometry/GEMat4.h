#import "objd.h"
#import "GEVec.h"


struct GEMat4Impl;
typedef struct GEMat4Impl GEMat4Impl;
@interface GEMat4 : NSObject {
@private
    struct GEMat4Impl *_impl;
}

- (id)initWithImpl:(GEMat4Impl *)m;

+ (id)mat4WithImpl:(GEMat4Impl *)m;
+ (id)mat4WithArray:(float[16])m;

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
- (GEMat4 *)translateVec3:(GEVec3)vec3;

- (GEVec4)divBySelfVec4:(GEVec4)vec4;

- (GEMat4 *)inverse;

- (GERect)mulRect:(GERect)rect;

- (GERect)mulRect:(GERect)rect z:(float)z;

- (GEVec3)mulVec3:(GEVec3)vec3;
@end

struct GEMat3Impl;
typedef struct GEMat3Impl GEMat3Impl;
@interface GEMat3 : NSObject {
@private
    struct GEMat3Impl *_impl;
}
- (id)initWithImplMat3:(GEMat3Impl *)m;

+ (id)mat3WithImpl:(GEMat3Impl *)m;
+ (id)mat3WithArray:(float[9])m;

- (GEVec3)mulVec3:(GEVec3)vec3;

+ (GEMat3 *)identity;
+ (GEMat3 *)null;
- (float const *)array;

- (GEVec2)mulVec2:(GEVec2)vec2;
@end

