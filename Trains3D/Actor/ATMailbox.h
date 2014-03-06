#import "objd.h"
@class ATConcurrentQueue;
@protocol ATActor;
@class ATTypedActor;

@class ATMailbox;
@class ATTypedActorFuture;
@protocol ATActorMessage;

@interface ATMailbox : NSObject
+ (instancetype)mailbox;
- (instancetype)init;
- (ODClassType*)type;
- (void)sendMessage:(id<ATActorMessage>)message;
+ (ODClassType*)type;
@end


@protocol ATActorMessage<NSObject>
- (id<ATActor>)sender;
- (id<ATActor>)receiver;
- (BOOL)prompt;
- (void)process;
@end


@interface ATTypedActorFuture : CNDefaultPromise<ATActorMessage>
@property (nonatomic, readonly) ATTypedActor* receiver;
@property (nonatomic, readonly) id(^f)();
@property (nonatomic, readonly) BOOL prompt;

+ (instancetype)typedActorFutureWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt;
- (instancetype)initWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)process;
- (id<ATActor>)sender;
+ (ODClassType*)type;
@end


