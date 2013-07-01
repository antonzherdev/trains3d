#import "objd.h"

@interface CNCache : NSObject
+ (id)cache;
- (id)init;
- (id)lookupWithDef:(id(^)())def forKey:(id)forKey;
- (id)setObject:(id)object forKey:(id)forKey;
- (void)clear;
@end


