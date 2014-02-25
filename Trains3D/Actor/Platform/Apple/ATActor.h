#import "objd.h"
@class ATMailbox;
@class ATTypedActor;
@class ATMessage;

@class ATActors;
@protocol ATActor;

@interface ATActors : NSObject
- (ODClassType*)type;
+ (id)typedActor:(id)actor;
+ (ODClassType*)type;
@end


@protocol ATActor<NSObject>
- (void)processMessage:(ATMessage*)message;
@end


