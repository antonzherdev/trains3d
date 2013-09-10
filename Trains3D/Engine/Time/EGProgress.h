#import "objd.h"
#import "EGVec.h"

@class EGProgress;

@interface EGProgress : NSObject
- (ODClassType*)type;
+ (float(^)(float))progressF4:(float)f4 f42:(float)f42;
+ (EGVec2(^)(float))progressVec2:(EGVec2)vec2 vec22:(EGVec2)vec22;
+ (id(^)(float))gapT1:(float)t1 t2:(float)t2;
+ (ODClassType*)type;
@end


