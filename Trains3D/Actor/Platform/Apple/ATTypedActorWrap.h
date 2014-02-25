#import "objd.h"
#import "ATActor.h"
#import "ATFuture.h"
@class ATMailbox;

@class ATTypedActorWrap;

@interface ATTypedActorWrap : NSProxy<ATActor>
@property (nonatomic, readonly) id actor;
@property (nonatomic, readonly) ATMailbox* mailbox;

+ (id)typedActorWrapWithActor:(id)actor mailbox:(ATMailbox*)mailbox;
- (id)initWithActor:(id)actor mailbox:(ATMailbox*)mailbox;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


