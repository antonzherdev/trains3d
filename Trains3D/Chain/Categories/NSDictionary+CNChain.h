#import <Foundation/Foundation.h>
#import "cnTypes.h"

@class CNChain;

@interface NSDictionary (CNChain)
- (NSArray *)values;
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key;
- (id)optionObjectForKey:(id)key;
- (CNChain *) chain;
- (void) forEach:(cnP)p;
- (BOOL) goOn:(BOOL(^)(id))on;
@end