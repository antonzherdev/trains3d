#import <Foundation/Foundation.h>
#import "CNTreeMap.h"
@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNIterable;
#import "CNSet.h"
#import "CNList.h"
@class CNChain;

@class CNTreeSet;

@interface CNTreeSet : NSObject<CNSet>
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeSetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeSet*)new;
- (id<CNList>)betweenA:(id)a b:(id)b;
- (void)addObject:(id)object;
- (BOOL)removeObject:(id)object;
- (id)higherThanObject:(id)object;
- (id)lowerThanObject:(id)object;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNIterator>)iteratorHigherThanObject:(id)object;
- (id)head;
- (id)last;
- (BOOL)containsObject:(id)object;
- (void)clear;
- (void)addAllObjects:(id<CNTraversable>)objects;
- (CNTreeSet*)reorder;
@end


