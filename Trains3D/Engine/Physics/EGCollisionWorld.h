#import "objd.h"
@class EGCollisionBody;

@class EGCollisionWorld;

@interface EGCollisionWorld : NSObject
+ (id)collisionWorld;
- (id)init;
- (ODClassType*)type;
- (void)addBody:(EGCollisionBody*)body;
- (void)removeBody:(EGCollisionBody*)body;
- (id<CNIterable>)detect;
+ (ODClassType*)type;
@end


