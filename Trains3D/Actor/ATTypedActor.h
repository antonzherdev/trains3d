#import "objd.h"
@class ATTypedActorFuture;
@class ATActors;

@class ATTypedActor;

@interface ATTypedActor : NSObject {
@private
    __weak id __actor;
    BOOL __setup;
}
+ (instancetype)typedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)futureF:(id(^)())f;
- (CNFuture*)promptF:(id(^)())f;
- (id)actor;
- (CNFuture*)lockAndOnSuccessFuture:(CNFuture*)future f:(id(^)(id))f;
+ (ODClassType*)type;
@end


