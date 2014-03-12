#import "objd.h"
@class ATConcurrentQueue;
@class ATActor;

@class ATMailbox;
@class ATActorFuture;
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
- (ATActor*)sender;
- (ATActor*)receiver;
- (BOOL)prompt;
- (BOOL)process;
- (void)onUnlockF:(void(^)())f;
@end


@interface ATActorFuture : CNDefaultPromise<ATActorMessage> {
@private
    ATActor* _receiver;
    BOOL _prompt;
    id(^_f)();
    BOOL __completed;
    BOOL __locked;
    CNAtomicObject* __unlocks;
}
@property (nonatomic, readonly) ATActor* receiver;
@property (nonatomic, readonly) BOOL prompt;
@property (nonatomic, readonly) id(^f)();

+ (instancetype)actorFutureWithReceiver:(ATActor*)receiver prompt:(BOOL)prompt f:(id(^)())f;
- (instancetype)initWithReceiver:(ATActor*)receiver prompt:(BOOL)prompt f:(id(^)())f;
- (ODClassType*)type;
- (BOOL)process;
- (ATActor*)sender;
- (void)lock;
- (void)unlock;
- (void)onUnlockF:(void(^)())f;
- (BOOL)isLocked;
- (BOOL)completeValue:(CNTry*)value;
+ (ODClassType*)type;
@end


