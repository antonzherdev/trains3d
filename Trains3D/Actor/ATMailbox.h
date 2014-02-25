#import "objd.h"
@class ATAtomicBool;
@protocol ATActor;
@class ATConcurrentQueue;
@class ATPromise;

@class ATMailbox;
@class ATMessage;

@interface ATMailbox : NSObject
+ (id)mailbox;
- (id)init;
- (ODClassType*)type;
- (void)sendMessage:(ATMessage*)message receiver:(id<ATActor>)receiver;
+ (ODClassType*)type;
@end


@interface ATMessage : NSObject
@property (nonatomic, readonly) id<ATActor> sender;
@property (nonatomic, readonly) id message;
@property (nonatomic, readonly) ATPromise* result;
@property (nonatomic, readonly) BOOL sync;

+ (id)messageWithSender:(id<ATActor>)sender message:(id)message result:(ATPromise*)result sync:(BOOL)sync;
- (id)initWithSender:(id<ATActor>)sender message:(id)message result:(ATPromise*)result sync:(BOOL)sync;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


