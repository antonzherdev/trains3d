#import "objdcore.h"
#import "TSTestCase.h"
@class CNImQueue;
@class ODClassType;

@class CNQueueTest;

@interface CNQueueTest : TSTestCase
+ (id)queueTest;
- (id)init;
- (ODClassType*)type;
- (void)testDeque;
+ (ODClassType*)type;
@end


