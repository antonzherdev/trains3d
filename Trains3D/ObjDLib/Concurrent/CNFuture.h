#import "objdcore.h"
#import "ODObject.h"
@class CNSuccess;
@class CNTry;
@protocol CNTraversable;
@class ODClassType;
@class CNFailure;

@class CNFuture;
@class CNPromise;
@class CNDefaultPromise;
@class CNKeptPromise;

@interface CNFuture : NSObject
+ (instancetype)future;
- (instancetype)init;
- (ODClassType*)type;
+ (CNFuture*)successfulResult:(id)result;
- (id)result;
- (BOOL)isCompleted;
- (BOOL)isSucceeded;
- (BOOL)isFailed;
- (void)onCompleteF:(void(^)(CNTry*))f;
- (void)onSuccessF:(void(^)(id))f;
- (void)onFailureF:(void(^)(id))f;
- (CNFuture*)mapF:(id(^)(id))f;
- (CNFuture*)flatMapF:(CNFuture*(^)(id))f;
- (id)waitResultPeriod:(CGFloat)period;
- (CNTry*)waitResult;
- (void)forSuccessAwait:(CGFloat)await f:(void(^)(id))f;
- (void)flatForSuccessAwait:(CGFloat)await f:(void(^)(id))f;
+ (ODClassType*)type;
@end


@interface CNPromise : CNFuture
+ (instancetype)promise;
- (instancetype)init;
- (ODClassType*)type;
+ (CNPromise*)apply;
- (void)completeValue:(CNTry*)value;
- (void)successValue:(id)value;
- (void)failureReason:(id)reason;
+ (ODClassType*)type;
@end


@interface CNDefaultPromise : CNPromise
+ (instancetype)defaultPromise;
- (instancetype)init;
- (ODClassType*)type;
- (id)result;
- (void)completeValue:(CNTry*)value;
- (void)successValue:(id)value;
- (void)failureReason:(id)reason;
- (void)onCompleteF:(void(^)(CNTry*))f;
+ (ODClassType*)type;
@end


@interface CNKeptPromise : CNPromise
@property (nonatomic, readonly) CNTry* value;

+ (instancetype)keptPromiseWithValue:(CNTry*)value;
- (instancetype)initWithValue:(CNTry*)value;
- (ODClassType*)type;
- (id)result;
- (void)onCompleteF:(void(^)(CNTry*))f;
- (id)waitResultPeriod:(CGFloat)period;
- (CNTry*)waitResult;
+ (ODClassType*)type;
@end


