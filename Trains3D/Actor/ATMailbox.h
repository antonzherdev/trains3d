#import "objd.h"
@class ATConcurrentQueue;
@protocol ATActor;
@class ATTypedActor;

@class ATMailbox;
@class ATTypedActorFuture;
@protocol ATActorMessage;

@interface ATMailbox : NSObject {
@private
    BOOL __stopped;
    CNAtomicBool* __scheduled;
    ATConcurrentQueue* __queue;
}
+ (instancetype)mailbox;
- (instancetype)init;
- (ODClassType*)type;
- (void)sendMessage:(id<ATActorMessage>)message;
- (void)stop;
+ (ODClassType*)type;
@end


@protocol ATActorMessage<NSObject>
- (id<ATActor>)sender;
- (id<ATActor>)receiver;
- (BOOL)prompt;
- (BOOL)process;
- (void)onUnlockF:(void(^)())f;
@end


@interface ATTypedActorFuture : CNDefaultPromise<ATActorMessage> {
@private
    ATTypedActor* _receiver;
    BOOL _prompt;
    id(^_f)();
    BOOL __completed;
    BOOL __locked;
    CNAtomicObject* __unlocks;
}
@property (nonatomic, readonly) ATTypedActor* receiver;
@property (nonatomic, readonly) BOOL prompt;
@property (nonatomic, readonly) id(^f)();

+ (instancetype)typedActorFutureWithReceiver:(ATTypedActor*)receiver prompt:(BOOL)prompt f:(id(^)())f;
- (instancetype)initWithReceiver:(ATTypedActor*)receiver prompt:(BOOL)prompt f:(id(^)())f;
- (ODClassType*)type;
- (BOOL)process;
- (id<ATActor>)sender;
- (void)lock;
- (void)unlock;
- (void)onUnlockF:(void(^)())f;
- (BOOL)isLocked;
- (BOOL)completeValue:(CNTry*)value;
+ (ODClassType*)type;
@end


