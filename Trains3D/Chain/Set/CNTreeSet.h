#import <Foundation/Foundation.h>
#import "CNTreeMap.h"
@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNIterable;
#import "CNSet.h"
#import "CNList.h"
@class CNChain;

@class CNMutableTreeSet;

@interface CNMutableTreeSet : NSObject<CNSet>
@property (nonatomic, readonly) CNMutableTreeMap* map;

+ (id)mutableTreeSetWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
+ (CNMutableTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNMutableTreeSet*)new;
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
- (CNMutableTreeSet*)reorder;
@end


