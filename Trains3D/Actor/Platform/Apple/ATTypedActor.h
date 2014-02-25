#import "objd.h"
#import "ATActor.h"
@class ATMailbox;
@class ATMessage;

@class ATTypedActor;

@interface ATTypedActor : NSProxy<ATActor>
@property (nonatomic, readonly) id actor;
@property (nonatomic, readonly) ATMailbox* mailbox;

+ (id)typedActorWithActor:(id)actor mailbox:(ATMailbox*)mailbox;
- (id)initWithActor:(id)actor mailbox:(ATMailbox*)mailbox;
- (ODClassType*)type;
- (void)processMessage:(ATMessage*)message;
+ (ODClassType*)type;
@end


