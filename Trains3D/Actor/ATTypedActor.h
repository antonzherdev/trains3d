#import "objd.h"
#import "ATMailbox.h"
@class ATActors;
@protocol ATActor;

@class ATTypedActor;
@class ATTypedActorFuture;

@interface ATTypedActor : NSObject
@property (nonatomic, readonly) id actor;

+ (instancetype)typedActor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)futureF:(id(^)())f;
- (CNFuture*)promptF:(id(^)())f;
+ (ODClassType*)type;
@end


@interface ATTypedActorFuture : CNDefaultPromise<ATActorMessage>
@property (nonatomic, readonly) ATTypedActor* receiver;
@property (nonatomic, readonly) id(^f)();
@property (nonatomic, readonly) BOOL prompt;

+ (instancetype)typedActorFutureWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt;
- (instancetype)initWithReceiver:(ATTypedActor*)receiver f:(id(^)())f prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)process;
- (id<ATActor>)sender;
+ (ODClassType*)type;
@end


