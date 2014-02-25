#import "objd.h"
@class ATTry;
@class ATSuccess;
@class ATFailure;

@class ATPromise;
@protocol ATFuture;

@protocol ATFuture<NSObject>
- (id)value;
- (ATTry*)waitPeriod:(CGFloat)period;
@end


@interface ATPromise : NSObject<ATFuture>
+ (id)promise;
- (id)init;
- (ODClassType*)type;
- (id)value;
- (void)successValue:(id)value;
- (void)failureReason:(id)reason;
+ (ODClassType*)type;
@end


