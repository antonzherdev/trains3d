#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "CNCollection.h"

@class CNMap;
@class CNMutableMap;

@interface CNMap : CNIterable
+ (id)map;
- (id)init;
- (id)objectForKey:(id)key;
- (NSArray*)keys;
- (NSArray*)values;
@end


@interface CNMutableMap : CNMap
+ (id)mutableMap;
- (id)init;
- (id)setObject:(id)object forKey:(id)forKey;
- (id)removeObjectForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyWith:(id(^)(id))with forKey:(id)forKey;
@end


