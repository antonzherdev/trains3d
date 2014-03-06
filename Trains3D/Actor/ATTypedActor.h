#import "objd.h"
@class ATTypedActorFuture;
@class ATActors;

@class ATTypedActor;

@interface ATTypedActor : NSObject
+ (instancetype)typedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)futureF:(id(^)())f;
- (CNFuture*)promptF:(id(^)())f;
- (id)actor;
+ (ODClassType*)type;
@end


