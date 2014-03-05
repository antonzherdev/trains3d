#import "objdcore.h"
#import "ODObject.h"
@class CNPromise;
@class CNAtomicInt;
@class CNAtomicBool;
@class CNFuture;
@class CNYield;
@class NSMutableArray;
@class CNTry;
@class ODClassType;

@class CNFutureEnd;
@class CNFutureVoidEnd;

@interface CNFutureEnd : NSObject
+ (instancetype)futureEnd;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)future;
- (CNYield*)yield;
+ (ODClassType*)type;
@end


@interface CNFutureVoidEnd : NSObject
+ (instancetype)futureVoidEnd;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)future;
- (CNYield*)yield;
+ (ODClassType*)type;
@end


