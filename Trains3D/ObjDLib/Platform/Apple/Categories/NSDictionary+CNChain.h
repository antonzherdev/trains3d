#import <Foundation/Foundation.h>
#import "CNTypes.h"
#import "CNMap.h"

@class CNChain;

@protocol CNHashMap <NSObject, CNMap>
@end

@interface NSDictionary (CNChain) <CNImMap, CNHashMap>
+ (id <CNImMap>)imHashMap;
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key;

+ (CNType *)type;

- (CNChain *) chain;
- (void) forEach:(cnP)p;
- (NSDictionary*)addItem:(CNTuple*)item;
@end