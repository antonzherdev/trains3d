#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "CNCollection.h"


@protocol CNMap<CNIterable>
- (id)objectForKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
@end


@protocol CNMutableMap<CNMap>
- (id)setObject:(id)object forKey:(id)forKey;
- (id)removeObjectForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyWith:(id(^)(id))with forKey:(id)forKey;
@end


