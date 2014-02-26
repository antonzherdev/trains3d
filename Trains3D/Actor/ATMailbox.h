#import "objd.h"
@protocol ATActor;
@class ATConcurrentQueue;

@class ATMailbox;
@protocol ATActorMessage;

@interface ATMailbox : NSObject
+ (instancetype)mailbox;
- (instancetype)init;
- (ODClassType*)type;
- (void)sendMessage:(id<ATActorMessage>)message receiver:(id<ATActor>)receiver;
+ (ODClassType*)type;
@end


@protocol ATActorMessage<NSObject>
- (id<ATActor>)sender;
- (BOOL)prompt;
@end


