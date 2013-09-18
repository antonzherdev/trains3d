#import "objdcore.h"
#import "CNSet.h"
@class NSObject;
@class CNMutableTreeMap;
@protocol CNIterator;
@class CNTreeMapKeySet;
@protocol CNTraversable;
@class ODClassType;
@protocol CNIterable;
@class CNChain;
@protocol CNBuilder;

@class CNMutableTreeSet;

@interface CNMutableTreeSet : NSObject<CNMutableSet>
@property (nonatomic, readonly) CNMutableTreeMap* map;

+ (id)mutableTreeSetWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
- (ODClassType*)type;
+ (CNMutableTreeSet*)newWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNMutableTreeSet*)apply;
- (id<CNSeq>)betweenA:(id)a b:(id)b;
- (void)addItem:(id)item;
- (BOOL)removeItem:(id)item;
- (id)higherThanItem:(id)item;
- (id)lowerThanItem:(id)item;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNIterator>)iteratorHigherThanItem:(id)item;
- (id)head;
- (id)last;
- (BOOL)containsItem:(id)item;
- (void)clear;
- (void)addAllObjects:(id<CNTraversable>)objects;
- (CNMutableTreeSet*)reorder;
+ (ODClassType*)type;
@end


