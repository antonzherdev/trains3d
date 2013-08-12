#import "objd.h"
#import "CNCollection.h"

@class CNTreeMap;
@class CNTreeMapEntry;
@class CNTreeMapKeySet;
@class CNTreeMapKeyIterator;

@interface CNTreeMap : NSObject
@property (nonatomic, readonly) NSInteger(^comparator)(id, id);

+ (id)treeMapWithComparator:(NSInteger(^)(id, id))comparator;
- (id)initWithComparator:(NSInteger(^)(id, id))comparator;
+ (CNTreeMap*)new;
- (NSUInteger)count;
- (id)objectForKey:(id)key;
- (CNCollection*)keys;
- (id)setObject:(id)object forKey:(id)forKey;
- (id)removeObjectForKey:(id)key;
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


@interface CNTreeMapKeySet : CNCollection
@property (nonatomic, readonly) CNTreeMap* map;

+ (id)treeMapKeySetWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
@end


@interface CNTreeMapKeyIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNTreeMap* map;
@property (nonatomic, retain) CNTreeMapEntry* entry;

+ (id)treeMapKeyIteratorWithMap:(CNTreeMap*)map;
- (id)initWithMap:(CNTreeMap*)map;
+ (CNTreeMapKeyIterator*)newMap:(CNTreeMap*)map entry:(CNTreeMapEntry*)entry;
- (id)next;
@end


