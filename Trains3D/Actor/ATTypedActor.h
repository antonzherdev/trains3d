#import "objd.h"
#import "ATMailbox.h"
@class ATActors;

@class ATTypedActor;
@class ATTypedActorFuture;

@interface ATTypedActor : NSObject
@property (nonatomic, readonly) id actor;

+ (instancetype)typedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)futureF:(id(^)())f;
- (CNFuture*)promptF:(id(^)())f;
+ (ODClassType*)type;
@end


@interface ATTypedActorFuture : CNDefaultPromise<ATActorMessage>
@property (nonatomic, readonly) ATTypedActor* actor;
@property (nonatomic, readonly) id(^f)();
@property (nonatomic, readonly) BOOL prompt;

+ (instancetype)typedActorFutureWithActor:(ATTypedActor*)actor f:(id(^)())f prompt:(BOOL)prompt;
- (instancetype)initWithActor:(ATTypedActor*)actor f:(id(^)())f prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)process;
+ (ODClassType*)type;
@end


