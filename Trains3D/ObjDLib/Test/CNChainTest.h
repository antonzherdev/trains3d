#import "objdcore.h"
#import "TSTestCase.h"
@class CNChain;
@class CNRange;
@class CNPromise;
@class CNDispatchQueue;
@class CNFuture;
@class CNTry;
@class CNAtomicInt;
@class ODClassType;

@class CNChainTest;

@interface CNChainTest : TSTestCase
+ (instancetype)chainTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testAnd;
- (void)testOr;
- (void)testFuture;
- (void)testVoidFuture;
- (void)testFlat;
+ (ODClassType*)type;
@end


