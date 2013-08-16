#import <Foundation/Foundation.h>
#import "CNMap.h"

@interface NSMutableDictionary (CNChain) <CNMutableMap>
- (id)objectForKey:(id)key orUpdateWith:(id (^)())with;

- (id)modifyWith:(id (^)(id))with forKey:(id)key;
@end