#import <Foundation/Foundation.h>
#import "CNMap.h"

@interface NSMutableDictionary (CNChain) <CNMutableMap>
- (id)objectForKey:(id)key orUpdateWith:(id (^)())with;

+ (NSMutableDictionary *)mutableDictionary;
@end