#import <Foundation/Foundation.h>

@interface NSDictionary (CNChain)
- (NSArray *)values;
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key;
- (id)optionObjectForKey:(id)key;
@end