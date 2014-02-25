#import "objd.h"
@class ATAtomicBool;
@protocol ATActor;
@class ATConcurrentQueue;

@class ATMailbox;
@protocol ATActorMessage;

@interface ATMailbox : NSObject
+ (id)mailbox;
- (id)init;
- (ODClassType*)type;
- (void)sendMessage:(id<ATActorMessage>)message receiver:(id<ATActor>)receiver;
+ (ODClassType*)type;
@end


@protocol ATActorMessage<NSObject>
- (id<ATActor>)sender;
- (BOOL)prompt;
@end


