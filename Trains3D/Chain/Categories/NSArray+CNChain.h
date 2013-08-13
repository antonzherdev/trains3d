#import <Foundation/Foundation.h>
#import "cnTypes.h"

@class CNChain;


@interface NSArray (CNChain)<CNIterable>
- (id) chain:(cnChainBuildBlock)block;
- (CNChain*) chain;
- (CNChain*)reverse;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;
- (CNChain*)map:(cnF)f;
- (CNChain*)flatMap:(cnF)f;

- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;
- (CNChain*)exclude:(id)collection;
- (CNChain*)intersect:(id)collection;
- (CNChain*) mul :(id)collection;

- (id) head;
- (id) randomItem;
- (void) forEach:(cnP)p;
- (BOOL) goOn:(BOOL(^)(id))on;
- (id)fold:(cnF2)f withStart:(id)start;
- (id)find:(cnPredicate)predicate;

- (CNChain *)distinct;

- (NSArray *)arrayByRemovingObject:(id)object;

- (NSSet *)toSet;
@end