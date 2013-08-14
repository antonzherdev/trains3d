#import <Foundation/Foundation.h>
#import "cnTypes.h"
#import "CNCollection.h"

@interface CNChain : NSObject <CNTraversable>
- (id)initWithLink:(id <CNChainLink>)link previous:(CNChain *)previous;

+ (id)chainWithLink:(id <CNChainLink>)link previous:(CNChain *)previous;

+ (CNChain*)chainWithCollection:(id)collection;

- (CNChain*)link:(id<CNChainLink>)link;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;

- (CNChain*)map:(cnF)f;
- (CNChain*)flatMap:(cnF)f;
- (CNChain*)flatMap:(cnF)f factor:(double) factor;
- (CNChain*)neighbors;
- (CNChain*)neighborsRing;
- (CNChain*)combinations;
- (CNChain*)uncombinations;

- (CNChain*)groupBy:(cnF)by fold:(cnF2)fold withStart:(cnF0)start;
- (CNChain*)groupBy:(cnF)by withBuilder:(cnF0)builder;
- (CNChain*)groupBy:(cnF)by;


- (CNChain*)append:(id)collection;
- (CNChain*)prepend:(id)collection;
- (CNChain*)exclude:(id)collection;
- (CNChain*)intersect:(id)collection;

- (CNChain*)mul :(id)collection;

- (CNChain*)reverse;
- (CNChain *)distinct;
- (CNChain *)distinctWithSelectivity:(double) selectivity;

- (void)forEach:(cnP)p;
- (id)head;
- (id)randomItem;
- (NSUInteger)count;
- (NSArray*)toArray;
- (NSSet*)toSet;
- (id)fold:(cnF2)f withStart:(id)start;
- (id)find:(cnPredicate)predicate;
- (id)min;
- (id)max;
- (NSDictionary *)toMap;
- (NSMutableDictionary *)toMutableMap;
- (CNYieldResult)apply:(CNYield *)yield;


@end
