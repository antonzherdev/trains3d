#import "objd.h"
@class ATTry;
@class ATSuccess;
@class ATFailure;

@class ATFuture;
@class ATPromise;
@class ATTypedActorFuture;

@interface ATFuture : NSObject
+ (id)future;
- (id)init;
- (ODClassType*)type;
- (id)result;
- (id)waitResultPeriod:(CGFloat)period;
- (ATTry*)waitResult;
- (void)onCompleteF:(void(^)(ATTry*))f;
- (void)onSuccessF:(void(^)(id))f;
- (void)onFailureF:(void(^)(id))f;
+ (ODClassType*)type;
@end


@interface ATPromise : ATFuture
+ (id)promise;
- (id)init;
- (ODClassType*)type;
- (id)result;
- (void)successValue:(id)value;
- (void)failureReason:(id)reason;
- (void)onCompleteF:(void(^)(ATTry*))f;
- (id)waitResultPeriod:(CGFloat)period;
- (ATTry*)waitResult;
+ (ODClassType*)type;
@end


@interface ATTypedActorFuture : ATPromise
@property (nonatomic, readonly) id(^f)();
@property (nonatomic, readonly) BOOL prompt;

+ (id)typedActorFutureWithF:(id(^)())f prompt:(BOOL)prompt;
- (id)initWithF:(id(^)())f prompt:(BOOL)prompt;
- (ODClassType*)type;
- (void)execute;
+ (ODClassType*)type;
@end


