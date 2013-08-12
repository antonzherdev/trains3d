#import <Foundation/Foundation.h>
#import "CNTreeMap.h"
#import "CNCollection.h"

@class CNTreeSet;

@interface CNTreeSet : CNIterable
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeSetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeSet*)new;
- (void)addObject:(id)object;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (id)last;
@end


