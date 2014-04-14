#import "objd.h"
@class ATMailbox;
@class ATActorFuture;

@class ATActor;

@interface ATActor : NSObject {
@protected
    ATMailbox* _mailbox;
}
@property (nonatomic, readonly) ATMailbox* mailbox;

+ (instancetype)actor;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)futureF:(id(^)())f;
- (CNFuture*)promptF:(id(^)())f;
- (CNFuture*)futureJoinF:(CNFuture*(^)())f;
- (CNFuture*)promptJoinF:(CNFuture*(^)())f;
- (CNFuture*)onSuccessFuture:(CNFuture*)future f:(id(^)(id))f;
- (CNFuture*)lockAndOnSuccessFuture:(CNFuture*)future f:(id(^)(id))f;
- (CNFuture*)dummy;
+ (ODClassType*)type;
@end


