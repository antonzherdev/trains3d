#import "objd.h"
#import "GEVec.h"
#import "EGTypes.h"

@class EGProgress;

@interface EGProgress : NSObject
- (ODClassType*)type;
+ (GEVec2)randomVec2;
+ (GEVec3)randomVec3;
+ (float(^)(float))progressF4:(float)f4 f42:(float)f42;
+ (GEVec2(^)(float))progressVec2:(GEVec2)vec2 vec22:(GEVec2)vec22;
+ (GEVec3(^)(float))progressVec3:(GEVec3)vec3 vec32:(GEVec3)vec32;
+ (GEVec4(^)(float))progressVec4:(GEVec4)vec4 vec42:(GEVec4)vec42;
+ (EGColor(^)(float))progressColor:(EGColor)color color2:(EGColor)color2;
+ (id(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (ODClassType*)type;
@end


