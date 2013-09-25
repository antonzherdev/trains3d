#import "objdcore.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;

@class CNMapDefault;
@protocol CNMap;
@protocol CNMutableMap;

@protocol CNMap<CNIterable>
- (id)applyKey:(id)key;
- (id)optKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
@end


@protocol CNMutableMap<CNMap, CNMutableIterable>
- (void)setValue:(id)value forKey:(id)forKey;
- (id)removeForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyBy:(id(^)(id))by forKey:(id)forKey;
- (void)addItem:(CNTuple*)item;
- (void)removeItem:(CNTuple*)item;
@end


@interface CNMapDefault : NSObject<CNMutableIterable>
@property (nonatomic, readonly) id(^defaultFunc)(id);
@property (nonatomic, readonly) id<CNMutableMap> map;

+ (id)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (id)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (ODClassType*)type;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (void)setValue:(id)value forKey:(id)forKey;
- (id)modifyBy:(id(^)(id))by forKey:(id)forKey;
- (void)addItem:(CNTuple*)item;
- (void)removeItem:(CNTuple*)item;
+ (ODClassType*)type;
@end


