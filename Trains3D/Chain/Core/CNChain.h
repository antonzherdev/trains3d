#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface CNChain : NSObject
+ (CNChain*)chainWithCollection:(id)collection;
+ (CNChain*)chainWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep;

- (CNChain*)link:(id<CNChainLink>)link;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;

- (CNChain*)map:(cnF)f;

- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;
- (CNChain*)exclude:(id)collection;
- (CNChain*)intersect:(id)collection;

- (CNChain*)mul :(id)collection;

- (CNChain*)reverse;

- (void)forEach:(cnP)p;
- (id)head;
- (id)randomItem;
- (NSUInteger)count;
- (NSArray*)array;
- (NSSet*)set;
- (id)fold:(cnF2)f withStart:(id)start;
@end
