#import "objd.h"
@class CNChain;

@class CNCollection;

@protocol CNIterator<NSObject>
- (id)next;
@end


@interface CNCollection : NSObject<NSFastEnumeration>
+ (id)collection;
- (id)init;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (CNChain*)chain;
- (void)forEach:(cnP)p;
@end


