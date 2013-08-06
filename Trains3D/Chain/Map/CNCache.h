#import "objd.h"

@interface CNCache : NSObject
+ (id)cache;
- (id)init;
- (id)lookupWithInit:(id(^)())init forKey:(id)forKey;
- (id)setObject:(id)object forKey:(id)forKey;
- (void)clear;
@end


