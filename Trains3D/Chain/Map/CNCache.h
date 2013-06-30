#import "objd.h"

@interface CNCache : NSObject
+ (id)cache;
- (id)init;
- (id)lookupWithKey:(id)key value:(id(^)())value;
- (id)updateWithKey:(id)key value:(id)value;
- (void)clear;
@end


