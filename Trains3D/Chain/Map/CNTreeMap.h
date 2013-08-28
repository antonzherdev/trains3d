#import "objdcore.h"
#import "ODObject.h"
#import "CNCollection.h"
#import "CNMap.h"
@class CNChain;

@class CNMutableTreeMap;
@class CNTreeMapEntry;
@class CNTreeMapKeySet;
@class CNTreeMapKeyIterator;
@class CNTreeMapValues;
@class CNTreeMapValuesIterator;
@class CNTreeMapIterator;

@interface CNMutableTreeMap : NSObject<CNMutableMap>
@property (nonatomic, readonly) NSInteger(^comparator)(id, id);
@property (nonatomic, readonly) CNTreeMapKeySet* keys;
@property (nonatomic, readonly) CNTreeMapValues* values;

+ (id)mutableTreeMapWithComparator:(NSInteger(^)(id, id))comparator;
- (id)initWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNMutableTreeMap*)new;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)applyKey:(id)key;
- (void)clear;
- (id<CNIterator>)iterator;
- (CNTreeMapIterator*)iteratorHigherThanKey:(id)key;
- (void)setObject:(id)object forKey:(id)forKey;
- (id)removeForKey:(id)key;
- (id)pollFirst;
- (id)firstKey;
- (id)lastKey;
- (id)lowerKeyThanKey:(id)key;
- (id)higherKeyThanKey:(id)key;
- (ODType*)type;
+ (NSInteger)BLACK;
+ (NSInteger)RED;
+ (ODType*)type;
@end


@interface CNTreeMapEntry : NSObject
@property (nonatomic) id key;
@property (nonatomic) id object;
@property (nonatomic, retain) CNTreeMapEntry* left;
@property (nonatomic, retain) CNTreeMapEntry* right;
@property (nonatomic) NSInteger color;
@property (nonatomic, weak) CNTreeMapEntry* parent;

+ (id)treeMapEntry;
- (id)init;
+ (CNTreeMapEntry*)newWithKey:(id)key object:(id)object parent:(CNTreeMapEntry*)parent;
- (CNTreeMapEntry*)next;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNTreeMapKeySet : NSObject<CNIterable>
@property (nonatomic, readonly) CNMutableTreeMap* map;

+ (id)treeMapKeySetWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNIterator>)iteratorHigherThanKey:(id)key;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNTreeMapKeyIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNMutableTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapKeyIteratorWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
+ (CNTreeMapKeyIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNTreeMapValues : NSObject<CNIterable>
@property (nonatomic, readonly) CNMutableTreeMap* map;

+ (id)treeMapValuesWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNTreeMapValuesIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNMutableTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapValuesIteratorWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
+ (CNTreeMapValuesIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNTreeMapIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNMutableTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapIteratorWithMap:(CNMutableTreeMap*)map;
- (id)initWithMap:(CNMutableTreeMap*)map;
+ (CNTreeMapIterator*)newMap:(CNMutableTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
- (ODType*)type;
+ (ODType*)type;
@end


