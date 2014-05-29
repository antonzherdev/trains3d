#import <Foundation/Foundation.h>
#import "CNTypes.h"
#import "CNMap.h"

@class CNChain;

@protocol CNHashMap <NSObject, CNMap>
@end

@interface NSDictionary (CNChain) <CNImMap, CNHashMap>
- (NSDictionary *)dictionaryByAddingValue:(id)value forKey:(id)key;

+ (CNType *)type;

- (CNChain *) chain;

+ (id <CNImMap>)imHashMap;

- (void) forEach:(cnP)p;
- (NSDictionary*)addItem:(CNTuple*)item;
@end