#import "objdcore.h"
#import "CNSet.h"
#import "CNCollection.h"
@class CNTreeMap;
@protocol CNTreeMapKeySet;
@class ODClassType;
@class CNChain;
@class CNDispatchQueue;
@class NSObject;
@class CNMTreeMap;
@class CNMTreeMapKeySet;

@class CNTreeSet;
@class CNImTreeSet;
@class CNTreeSetBuilder;
@class CNMTreeSet;

@interface CNTreeSet : NSObject<CNSet> {
@private
    CNTreeMap* _map;
}
@property (nonatomic, readonly) CNTreeMap* map;

+ (instancetype)treeSetWithMap:(CNTreeMap*)map;
- (instancetype)initWithMap:(CNTreeMap*)map;
- (ODClassType*)type;
- (id)higherThanItem:(id)item;
- (id)lowerThanItem:(id)item;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNIterator>)iteratorHigherThanItem:(id)item;
- (id)head;
- (id)headOpt;
- (id)last;
- (BOOL)containsItem:(id)item;
+ (ODClassType*)type;
@end


@interface CNImTreeSet : CNTreeSet
+ (instancetype)imTreeSetWithMap:(CNTreeMap*)map;
- (instancetype)initWithMap:(CNTreeMap*)map;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface CNTreeSetBuilder : NSObject<CNBuilder> {
@private
    NSInteger(^_comparator)(id, id);
    CNMTreeSet* _set;
}
@property (nonatomic, readonly) NSInteger(^comparator)(id, id);

+ (instancetype)treeSetBuilderWithComparator:(NSInteger(^)(id, id))comparator;
- (instancetype)initWithComparator:(NSInteger(^)(id, id))comparator;
- (ODClassType*)type;
+ (CNTreeSetBuilder*)apply;
- (void)appendItem:(id)item;
- (CNTreeSet*)build;
+ (ODClassType*)type;
@end


@interface CNMTreeSet : CNTreeSet<CNMSet> {
@private
    CNMTreeMap* _mmap;
}
@property (nonatomic, readonly) CNMTreeMap* mmap;

+ (instancetype)treeSetWithMmap:(CNMTreeMap*)mmap;
- (instancetype)initWithMmap:(CNMTreeMap*)mmap;
- (ODClassType*)type;
+ (CNMTreeSet*)applyComparator:(NSInteger(^)(id, id))comparator;
+ (CNMTreeSet*)apply;
- (id<CNMIterator>)mutableIterator;
- (void)appendItem:(id)item;
- (BOOL)removeItem:(id)item;
- (void)clear;
- (void)addAllObjects:(id<CNTraversable>)objects;
- (CNMTreeSet*)reorder;
+ (ODClassType*)type;
@end


