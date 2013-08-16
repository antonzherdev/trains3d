#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "CNCollection.h"

@protocol CNMap;
@protocol CNMutableMap;

@protocol CNMap<CNIterable>
- (id)applyKey:(id)key;
- (id<CNIterable>)keys;
- (id<CNIterable>)values;
- (BOOL)containsKey:(id)key;
@end


@protocol CNMutableMap<CNMap>
- (id)setObject:(id)object forKey:(id)forKey;
- (id)removeForKey:(id)key;
- (id)objectForKey:(id)key orUpdateWith:(id(^)())orUpdateWith;
- (id)modifyBy:(id(^)(id))by forKey:(id)forKey;
@end


