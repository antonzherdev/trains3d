#import "objd.h"
@class CNTreeMap;
@class CNTreeMapEntry;
@class CNTreeMapKeySet;
@class CNTreeMapKeyIterator;

@class CNTreeSet;

@interface CNTreeSet : NSObject
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeSetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeSet*)new;
- (void)addObject:(id)object;
- (NSUInteger)count;
@end


