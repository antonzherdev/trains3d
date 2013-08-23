#import <Foundation/Foundation.h>
#import "CNCollection.h"
@class CNChain;
@class CNTuple;

@class CNMapDefault;
@protocol CNMap;
@protocol CNMutableMap;

@protocol CNMap<CNIterable>
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
@end


@protocol CNMutableMap<CNMap>
- (void)setObject:(id)object forKey:(id)forKey;
- (id)removeForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyBy:(id(^)(id))by forKey:(id)forKey;
- (void)addObject:(CNTuple*)object;
- (void)removeObject:(CNTuple*)object;
@end


@interface CNMapDefault : NSObject<CNMutableIterable>
@property (nonatomic, readonly) id(^defaultFunc)(id);
@property (nonatomic, readonly) id<CNMutableMap> map;

+ (id)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (id)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMutableMap>)map;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
- (void)setObject:(id)object forKey:(id)forKey;
- (id)modifyBy:(id(^)(id))by forKey:(id)forKey;
- (void)addObject:(CNTuple*)object;
- (void)removeObject:(CNTuple*)object;
@end


