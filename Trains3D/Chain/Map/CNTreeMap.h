#import "objd.h"

@class CNTreeMap;
@class CNTreeMapEntry;

@interface CNTreeMap : NSObject
@property (nonatomic, readonly) NSInteger(^comparator)(id, id);

+ (id)treeMapWithComparator:(NSInteger(^)(id, id))comparator;
- (id)initWithComparator:(NSInteger(^)(id, id))comparator;
- (NSUInteger)count;
- (id)objectForKey:(id)key;
- (id)setObject:(id)object forKey:(id)forKey;
+ (NSInteger)BLACK;
+ (NSInteger)RED;
@end


@interface CNTreeMapEntry : NSObject
@property (nonatomic, readonly) id key;
@property (nonatomic) id object;
@property (nonatomic, retain) CNTreeMapEntry* left;
@property (nonatomic, retain) CNTreeMapEntry* right;
@property (nonatomic) NSInteger color;
@property (nonatomic, retain) CNTreeMapEntry* parent;

+ (id)treeMapEntryWithKey:(id)key;
- (id)initWithKey:(id)key;
+ (CNTreeMapEntry*)newWithKey:(id)key object:(id)object parent:(CNTreeMapEntry*)parent;
@end


