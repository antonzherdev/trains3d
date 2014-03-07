#import "objdcore.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;
@class CNDispatchQueue;

@class CNMapDefault;
@class CNHashMapBuilder;
@protocol CNMap;
@protocol CNImMap;
@protocol CNMMap;

@protocol CNMap<CNIterable>
- (id)applyKey:(id)key;
- (id)optKey:(id)key;
- (id)getKey:(id)key orValue:(id)orValue;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (BOOL)isValueEqualKey:(id)key value:(id)value;
@end


@protocol CNImMap<CNMap, CNImIterable>
- (id<CNImMap>)addItem:(CNTuple*)item;
@end


@protocol CNMMap<CNMap, CNMIterable>
- (void)setKey:(id)key value:(id)value;
- (id)removeForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyKey:(id)key by:(id(^)(id))by;
- (id)takeKey:(id)key;
- (void)appendItem:(CNTuple*)item;
- (BOOL)removeItem:(CNTuple*)item;
- (id<CNImMap>)im;
- (id<CNImMap>)imCopy;
@end


@interface CNMapDefault : NSObject<CNMIterable>
@property (nonatomic, readonly) id(^defaultFunc)(id);
@property (nonatomic, readonly) id<CNMMap> map;

+ (instancetype)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMMap>)map;
- (instancetype)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMMap>)map;
- (ODClassType*)type;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNMIterator>)mutableIterator;
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (void)setKey:(id)key value:(id)value;
- (id)modifyKey:(id)key by:(id(^)(id))by;
- (void)appendItem:(CNTuple*)item;
- (BOOL)removeItem:(CNTuple*)item;
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


