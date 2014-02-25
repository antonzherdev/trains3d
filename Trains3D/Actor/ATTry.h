#import "objd.h"

@class ATTry;
@class ATSuccess;
@class ATFailure;

@interface ATTry : NSObject
+ (id)try;
- (id)init;
- (ODClassType*)type;
- (id)get;
- (BOOL)isSuccess;
- (BOOL)isFailure;
+ (ODClassType*)type;
@end


@interface ATSuccess : ATTry
@property (nonatomic, readonly) id get;

+ (id)successWithGet:(id)get;
- (id)initWithGet:(id)get;
- (ODClassType*)type;
- (BOOL)isSuccess;
- (BOOL)isFailure;
+ (ODClassType*)type;
@end


@interface ATFailure : ATTry
@property (nonatomic, readonly) id reason;

+ (id)failureWithReason:(id)reason;
- (id)initWithReason:(id)reason;
- (ODClassType*)type;
- (id)get;
- (BOOL)isSuccess;
- (BOOL)isFailure;
+ (ODClassType*)type;
@end


