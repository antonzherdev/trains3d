#import <Foundation/Foundation.h>
#import "cnTypes.h"

@class CNChain;


@interface NSArray (CNChain)
- (id) chain:(cnChainBuildBlock)block;
- (CNChain*) chain;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;
- (CNChain*)map:(cnF)f;

- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;
- (CNChain*)exclude:(id)collection;
- (CNChain*)intersect:(id)collection;
- (CNChain*) mul :(id)collection;

- (id) head;
- (id) randomItem;
- (void) forEach:(cnP)p;
@end