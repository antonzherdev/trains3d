#import "objdcore.h"
#import "CNChain.h"
@class CNPromise;
@class CNAtomicInt;
@class CNFuture;
@class CNYield;
@class CNTry;
@class ODClassType;

@class CNFutureLink;

@interface CNFutureLink : NSObject<CNChainLink>
+ (instancetype)futureLink;
- (instancetype)init;
- (ODClassType*)type;
- (CNFuture*)future;
- (CNYield*)buildYield:(CNYield*)yield;
+ (ODClassType*)type;
@end


