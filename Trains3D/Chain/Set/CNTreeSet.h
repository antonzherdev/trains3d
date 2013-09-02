#import "objdcore.h"
#import "CNTreeMap.h"
@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNMutableTraversable;
@protocol CNIterable;
@protocol CNMutableIterable;
#import "CNSet.h"
#import "CNSeq.h"
@class CNChain;
@class CNOption;

@class CNMutableTreeSet;

@interface CNMutableTreeSet : NSObject<CNMutableSet>
@property (nonatomic, readonly) CNMutableTreeMap* map;

+ (id)mutableTreeSetWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
- (ODClassType*)type;
+ (CNMutableTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNMutableTreeSet*)new;
- (id<CNSeq>)betweenA:(id)a b:(id)b;
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
+ (ODClassType*)type;
@end


