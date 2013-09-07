#import "objdcore.h"
#import "CNTest.h"
@class CNMutableTreeMap;
@class CNTreeMapEntry;
@class CNTreeMapKeySet;
@class CNTreeMapKeyIterator;
@class CNTreeMapValues;
@class CNTreeMapValuesIterator;
@class CNTreeMapIterator;

@class CNTreeMapTest;

@interface CNTreeMapTest : CNTestCase
+ (id)treeMapTest;
- (id)init;
- (ODClassType*)type;
- (void)testMain;
+ (ODClassType*)type;
@end


