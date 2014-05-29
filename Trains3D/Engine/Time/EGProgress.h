#import "objd.h"
#import "GEVec.h"

@class EGProgress;

@interface EGProgress : NSObject
- (CNClassType*)type;
+ (float(^)(float))progressF4:(float)f4 f42:(float)f42;
+ (GEVec2(^)(float))progressVec2:(GEVec2)vec2 vec22:(GEVec2)vec22;
+ (GEVec3(^)(float))progressVec3:(GEVec3)vec3 vec32:(GEVec3)vec32;
+ (GEVec4(^)(float))progressVec4:(GEVec4)vec4 vec42:(GEVec4)vec42;
+ (id(^)(float))gapOptT1:(float)t1 t2:(float)t2;
+ (float(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (float(^)(float))trapeziumT1:(float)t1 t2:(float)t2;
+ (float(^)(float))trapeziumT1:(float)t1;
+ (float(^)(float))divOn:(float)on;
+ (CNClassType*)type;
@end


