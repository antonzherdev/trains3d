#import "objdcore.h"
#import "CNSet.h"
@class NSObject;
@class CNMutableTreeMap;
@protocol CNIterator;
@class CNTreeMapKeySet;
@protocol CNTraversable;

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


