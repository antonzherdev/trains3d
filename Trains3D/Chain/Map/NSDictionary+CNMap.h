#import <Foundation/Foundation.h>

@interface NSDictionary (CNMap)
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key;
- (id)optionObjectForKey:(id)key;
@end