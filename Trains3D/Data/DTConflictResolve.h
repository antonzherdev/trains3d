#import "objd.h"

@class DTConflict;

@interface DTConflict : NSObject
- (CNClassType*)type;
+ (id(^)(id, id))resolveMax;
+ (id(^)(id, id))resolveMin;
+ (CNClassType*)type;
@end


