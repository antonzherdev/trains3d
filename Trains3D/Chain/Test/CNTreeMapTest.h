#import "objdcore.h"
#import "TSTestCase.h"
@class CNMutableTreeMap;
@class CNChain;
@class CNTreeMapKeySet;
@class ODClassType;

@class CNTreeMapTest;

@interface CNTreeMapTest : TSTestCase
+ (id)treeMapTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODType*)type;
@end


