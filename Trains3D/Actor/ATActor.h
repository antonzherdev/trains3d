#import "objd.h"
@class ATMailbox;
@class ATTypedActorWrap;
@protocol ATActorMessage;

@class ATActors;
@protocol ATActor;

@interface ATActors : NSObject
- (ODClassType*)type;
+ (id)typedActor:(id)actor;
+ (ODClassType*)type;
@end


@protocol ATActor<NSObject>
- (void)processMessage:(id<ATActorMessage>)message;
@end


