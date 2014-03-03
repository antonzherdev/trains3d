#import "objd.h"
@class ATConcurrentQueue;
@protocol ATActor;

@class ATMailbox;
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


