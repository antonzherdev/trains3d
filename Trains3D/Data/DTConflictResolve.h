#import "objd.h"

@class DTConflict;

@interface DTConflict : NSObject
- (ODClassType*)type;
+ (id(^)(id, id))resolveMax;
+ (id(^)(id, id))resolveMin;
+ (ODClassType*)type;
@end


