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
    BOOL __locked;
}
+ (instancetype)mailbox;
- (instancetype)init;
- (ODClassType*)type;
- (void)sendMessage:(id<ATActorMessage>)message;
- (void)unlock;
- (void)stop;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


@protocol ATActorMessage<NSObject>
- (ATActor*)sender;
- (ATActor*)receiver;
- (BOOL)prompt;
- (BOOL)process;
@end


@interface ATActorFuture : CNDefaultPromise<ATActorMessage> {
@private
    ATActor* _receiver;
    BOOL _prompt;
    id(^_f)();
    BOOL __completed;
    BOOL __locked;
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
- (BOOL)isLocked;
- (BOOL)completeValue:(CNTry*)value;
+ (ODClassType*)type;
@end


