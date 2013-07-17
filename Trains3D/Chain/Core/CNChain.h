#import <Foundation/Foundation.h>
#import "cnTypes.h"

@interface CNChain : NSObject
- (id)initWithLink:(id <CNChainLink>)link previous:(CNChain *)previous;

+ (id)chainWithLink:(id <CNChainLink>)link previous:(CNChain *)previous;

+ (CNChain*)chainWithCollection:(id)collection;
+ (CNChain*)chainWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep;

- (CNChain*)link:(id<CNChainLink>)link;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;

- (CNChain*)map:(cnF)f;
- (CNChain*)flatMap:(cnF)f;
- (CNChain*)flatMap:(cnF)f factor:(double) factor;

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
- (NSSet*)set;
- (id)fold:(cnF2)f withStart:(id)start;
- (id)find:(cnPredicate)predicate;
- (NSDictionary *)toMap;
- (NSMutableDictionary *)toMutableMap;
- (CNYieldResult)apply:(CNYield *)yield;

@end
