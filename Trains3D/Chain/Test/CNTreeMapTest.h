#import "objd.h"
#import "CNTest.h"
@class CNTreeMap;
@class CNTreeMapEntry;

@class CNTreeMapTest;

@interface CNTreeMapTest : CNTestCase
+ (id)treeMapTest;
- (id)init;
- (NSInteger)compA:(NSInteger)a b:(NSInteger)b;
- (void)testMain;
@end


