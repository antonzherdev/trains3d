#import "objd.h"
#import "EGVec.h"
#import "EGTypes.h"

@class EGProgress;

@interface EGProgress : NSObject
- (ODClassType*)type;
+ (EGVec2)randomVec2;
+ (EGVec3)randomVec3;
+ (float(^)(float))progressF4:(float)f4 f42:(float)f42;
+ (EGVec2(^)(float))progressVec2:(EGVec2)vec2 vec22:(EGVec2)vec22;
+ (EGVec3(^)(float))progressVec3:(EGVec3)vec3 vec32:(EGVec3)vec32;
+ (EGVec4(^)(float))progressVec4:(EGVec4)vec4 vec42:(EGVec4)vec42;
+ (EGColor(^)(float))progressColor:(EGColor)color color2:(EGColor)color2;
+ (id(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (ODClassType*)type;
@end


