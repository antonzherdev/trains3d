#import "objd.h"
#import "TSTestCase.h"
@class ATSignal;
@class ATObserver;

@class ATObserverTest;

@interface ATObserverTest : TSTestCase
+ (instancetype)observerTest;
- (instancetype)init;
- (ODClassType*)type;
- (void)testSignal;
+ (ODClassType*)type;
@end


