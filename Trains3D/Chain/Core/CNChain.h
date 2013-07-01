#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface CNChain : NSObject
+ (CNChain*)chainWithCollection:(id)collection;
+ (CNChain*)chainWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep;

- (NSArray*)array;
- (NSSet*)set;

- (CNChain*)link:(id<CNChainLink>)link;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;

- (CNChain*)map:(cnF)f;

- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;
- (CNChain*)exclude:(id)collection;
- (CNChain*)intersect:(id)collection;


- (CNChain*) mul :(id)collection;

- (void) forEach:(cnP)p;
- (id)head;
- (id)randomItem;
@end
