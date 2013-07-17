#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CNChain)
- (id)objectForKey:(id)key orUpdateWith:(id (^)())with;

- (id)modifyWith:(id (^)(id))with forKey:(id)key;
@end