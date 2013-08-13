#import <Foundation/Foundation.h>
#import "CNTreeMap.h"
#import "CNCollection.h"

@class CNTreeSet;

@interface CNTreeSet : CNSet
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeSetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeSet*)new;
- (void)addObject:(id)object;
- (BOOL)removeObject:(id)object;
- (id)higherThanObject:(id)object;
- (id)lowerThanObject:(id)object;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (id)last;
@end


