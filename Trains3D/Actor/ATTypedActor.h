#import "objd.h"
#import "ATMailbox.h"
@class ATFuture;
@class ATTypedActorFuture;
@class ATActors;
@protocol ATActor;

@class ATTypedActorMessage;
@class ATTypedActorMessageVoid;
@class ATTypedActorMessageResult;
@protocol ATTypedActor;

@protocol ATTypedActor<NSObject>
- (ATFuture*)futureF:(id(^)())f;
- (ATFuture*)promptF:(id(^)())f;
- (id)actor;
@end


@interface ATTypedActorMessage : NSObject<ATActorMessage>
+ (id)typedActorMessage;
- (id)init;
- (ODClassType*)type;
- (id<ATActor>)sender;
- (BOOL)prompt;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


@interface ATTypedActorMessageVoid : ATTypedActorMessage
@property (nonatomic, readonly) NSInvocation* invocation;
@property (nonatomic, readonly) BOOL prompt;

+ (id)typedActorMessageVoidWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt;
- (id)initWithInvocation:(NSInvocation*)invocation prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


@interface ATTypedActorMessageResult : ATTypedActorMessage
@property (nonatomic, readonly) ATTypedActorFuture* future;

+ (id)typedActorMessageResultWithFuture:(ATTypedActorFuture*)future;
- (id)initWithFuture:(ATTypedActorFuture*)future;
- (ODClassType*)type;
- (BOOL)prompt;
- (void)processActor:(id)actor;
+ (ODClassType*)type;
@end


