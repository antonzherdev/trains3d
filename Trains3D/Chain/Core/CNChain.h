#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface CNChain : NSObject
+ (CNChain*)chainWithCollection:(id)collection;

- (NSArray*)array;
- (NSSet*)set;

- (CNChain*)link:(id<CNChainLink>)link;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;

- (CNChain*)map:(cnF)f;

- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;

- (id) first;
@end
