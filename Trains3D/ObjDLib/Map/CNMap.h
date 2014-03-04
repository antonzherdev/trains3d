#import "objdcore.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;
@class CNDispatchQueue;

@class CNMapDefault;
@class CNHashMapBuilder;
@protocol CNMap;
@protocol CNMutableMap;

@protocol CNMap<CNIterable>
- (id)applyKey:(id)key;
- (id)optKey:(id)key;
- (id)getKey:(id)key orValue:(id)orValue;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (BOOL)isValueEqualKey:(id)key value:(id)value;
- (id<CNMap>)addItem:(CNTuple*)item;
@end


@protocol CNMutableMap<CNMap, CNMutableIterable>
- (void)setKey:(id)key value:(id)value;
- (id)removeForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyKey:(id)key by:(id(^)(id))by;
- (id)takeKey:(id)key;
- (void)appendItem:(CNTuple*)item;
- (BOOL)removeItem:(CNTuple*)item;
@end


@interface CNMapDefault : NSObject<CNMutableIterable>
@property (nonatomic, readonly) id(^defaultFunc)(id);
@property (nonatomic, readonly) id<CNMutableMap> map;

+ (instancetype)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (instancetype)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (ODClassType*)type;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNMutableIterator>)mutableIterator;
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (void)setKey:(id)key value:(id)value;
- (id)modifyKey:(id)key by:(id(^)(id))by;
- (void)appendItem:(CNTuple*)item;
- (void)removeItem:(CNTuple*)item;
- (void)clear;
+ (ODClassType*)type;
@end


@interface CNHashMapBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableDictionary* map;

+ (instancetype)hashMapBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (void)appendItem:(CNTuple*)item;
- (NSDictionary*)build;
+ (ODClassType*)type;
@end


