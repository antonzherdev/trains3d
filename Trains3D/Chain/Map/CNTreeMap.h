#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "CNTuple.h"
#import "ODObject.h"
#import "CNCollection.h"
#import "CNMap.h"
@class CNChain;

@class CNTreeMap;
@class CNTreeMapEntry;
@class CNTreeMapKeySet;
@class CNTreeMapKeyIterator;
@class CNTreeMapValues;
@class CNTreeMapValuesIterator;
@class CNTreeMapIterator;

@interface CNTreeMap : NSObject<CNMutableMap>
@property (nonatomic, readonly) NSInteger(^comparator)(id, id);
@property (nonatomic, readonly) CNTreeMapKeySet* keys;
@property (nonatomic, readonly) CNTreeMapValues* values;

+ (id)treeMapWithComparator:(NSInteger(^)(id, id))comparator;
- (id)initWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeMap*)new;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)objectForKey:(id)key;
- (void)clear;
- (id<CNIterator>)iterator;
- (CNTreeMapIterator*)iteratorHigherThanKey:(id)key;
- (id)setObject:(id)object forKey:(id)forKey;
- (id)removeObjectForKey:(id)key;
- (id)pollFirst;
- (id)firstKey;
- (id)lastKey;
- (id)lowerKeyThanKey:(id)key;
- (id)higherKeyThanKey:(id)key;
+ (NSInteger)BLACK;
+ (NSInteger)RED;
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
@end


@interface CNTreeMapKeySet : NSObject<CNIterable>
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeMapKeySetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNIterator>)iteratorHigherThanKey:(id)key;
@end


@interface CNTreeMapKeyIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapKeyIteratorWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeMapKeyIterator*)newMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
@end


@interface CNTreeMapValues : NSObject<CNIterable>
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeMapValuesWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
@end


@interface CNTreeMapValuesIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapValuesIteratorWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeMapValuesIterator*)newMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
@end


@interface CNTreeMapIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapIteratorWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeMapIterator*)newMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (BOOL)hasNext;
- (id)next;
@end


