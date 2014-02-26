#import "objd.h"
#import "ATMailbox.h"
@class ATActors;
@protocol ATActor;

@class ATTypedActor;
@class ATTypedActorMessage;
@class ATTypedActorMessageVoid;
@class ATTypedActorMessageResult;
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


@interface ATTypedActorMessage : NSObject<ATActorMessage>
+ (instancetype)typedActorMessage;
- (instancetype)init;
- (ODClassType*)type;
- (id<ATActor>)sender;
- (BOOL)prompt;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


@interface ATTypedActorMessageVoid : ATTypedActorMessage
@property (nonatomic, readonly) NSInvocation* invocation;
@property (nonatomic, readonly) BOOL prompt;

+ (instancetype)typedActorMessageVoidWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt;
- (instancetype)initWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


@interface ATTypedActorMessageResult : ATTypedActorMessage
@property (nonatomic, readonly) ATTypedActorFuture* future;

+ (instancetype)typedActorMessageResultWithFuture:(ATTypedActorFuture*)future;
- (instancetype)initWithFuture:(ATTypedActorFuture*)future;
- (ODClassType*)type;
- (BOOL)prompt;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


@interface ATTypedActorFuture : CNDefaultPromise
@property (nonatomic, readonly) id(^f)();
@property (nonatomic, readonly) BOOL prompt;

+ (instancetype)typedActorFutureWithF:(id(^)())f prompt:(BOOL)prompt;
- (instancetype)initWithF:(id(^)())f prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)execute;
+ (ODClassType*)type;
@end


